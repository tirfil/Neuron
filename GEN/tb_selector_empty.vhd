--###############################
--# Project Name : 
--# File         : 
--# Author       : 
--# Description  : 
--# Modification History
--#
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_selector is
end tb_selector;

architecture stimulus of tb_selector is

-- COMPONENTS --
	component selector
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			SRST		: in	std_logic;
			DATA_IN		: in	std_logic_vector(15 downto 0);
			DATA_INFO		: in	std_logic_vector(1 downto 0);
			FIFO_OUT		: in	std_logic_vector(15 downto 0);
			FIFO_OK		: in	std_logic;
			FIFO_STALL		: out	std_logic;
			ADDER_INFO		: out	std_logic_vector(1 downto 0);
			ADDER_INA		: out	std_logic_vector(15 downto 0);
			ADDER_INB		: out	std_logic_vector(15 downto 0);
			END_FLAG		: out	std_logic
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal SRST		: std_logic;
	signal DATA_IN		: std_logic_vector(15 downto 0);
	signal DATA_INFO		: std_logic_vector(1 downto 0);
	signal FIFO_OUT		: std_logic_vector(15 downto 0);
	signal FIFO_OK		: std_logic;
	signal FIFO_STALL		: std_logic;
	signal ADDER_INFO		: std_logic_vector(1 downto 0);
	signal ADDER_INA		: std_logic_vector(15 downto 0);
	signal ADDER_INB		: std_logic_vector(15 downto 0);
	signal END_FLAG		: std_logic;

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
	I_selector_0 : selector
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SRST		=> SRST,
			DATA_IN		=> DATA_IN,
			DATA_INFO		=> DATA_INFO,
			FIFO_OUT		=> FIFO_OUT,
			FIFO_OK		=> FIFO_OK,
			FIFO_STALL		=> FIFO_STALL,
			ADDER_INFO		=> ADDER_INFO,
			ADDER_INA		=> ADDER_INA,
			ADDER_INB		=> ADDER_INB,
			END_FLAG		=> END_FLAG
		);

--
	CLOCK: process
	begin
		while (RUNNING = '1') loop
			MCLK <= '1';
			wait for 10 ns;
			MCLK <= '0';
			wait for 10 ns;
		end loop;
		wait;
	end process CLOCK;

	GO: process
	begin
		nRST <= '0';
		wait for 1000 ns;
		nRST <= '1';

		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;

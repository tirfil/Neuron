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

entity tb_fifo_out_adaptor is
end tb_fifo_out_adaptor;

architecture stimulus of tb_fifo_out_adaptor is

-- COMPONENTS --
	component fifo_out_adaptor
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			FIFO_OUT		: in	std_logic_vector(15 downto 0);
			FIFO_EMPTY		: in	std_logic;
			FIFO_READ		: out	std_logic;
			STALL		: in	std_logic;
			DATA_OUT		: out	std_logic_vector(15 downto 0);
			DATA_VALID		: out	std_logic
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal FIFO_OUT		: std_logic_vector(15 downto 0);
	signal FIFO_EMPTY		: std_logic;
	signal FIFO_READ		: std_logic;
	signal STALL		: std_logic;
	signal DATA_OUT		: std_logic_vector(15 downto 0);
	signal DATA_VALID		: std_logic;

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
	I_fifo_out_adaptor_0 : fifo_out_adaptor
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			FIFO_OUT		=> FIFO_OUT,
			FIFO_EMPTY		=> FIFO_EMPTY,
			FIFO_READ		=> FIFO_READ,
			STALL		=> STALL,
			DATA_OUT		=> DATA_OUT,
			DATA_VALID		=> DATA_VALID
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

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

entity tb_accumulator is
end tb_accumulator;

architecture stimulus of tb_accumulator is

-- COMPONENTS --
	component accumulator
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			SRST		: in	std_logic;
			DIN		: in	std_logic_vector(15 downto 0);
			INFO		: in	std_logic_vector(1 downto 0);
			DOUT		: out	std_logic_vector(15 downto 0);
			DOUT_OK		: out	std_logic
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal SRST		: std_logic;
	signal DIN		: std_logic_vector(15 downto 0);
	signal INFO		: std_logic_vector(1 downto 0);
	signal DOUT		: std_logic_vector(15 downto 0);
	signal DOUT_OK		: std_logic;

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
	I_accumulator_0 : accumulator
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SRST		=> SRST,
			DIN		=> DIN,
			INFO		=> INFO,
			DOUT		=> DOUT,
			DOUT_OK		=> DOUT_OK
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

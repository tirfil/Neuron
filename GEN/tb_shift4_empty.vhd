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

entity tb_shift4 is
end tb_shift4;

architecture stimulus of tb_shift4 is

-- COMPONENTS --
	component shift4
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			INFO_IN		: in	std_logic_vector(1 downto 0);
			INFO_OUT		: out	std_logic_vector(1 downto 0)
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal INFO_IN		: std_logic_vector(1 downto 0);
	signal INFO_OUT		: std_logic_vector(1 downto 0);

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
	I_shift4_0 : shift4
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			INFO_IN		=> INFO_IN,
			INFO_OUT		=> INFO_OUT
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

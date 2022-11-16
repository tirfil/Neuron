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

entity neuron is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		SRST		: in	std_logic;
		DIN		: in	std_logic_vector(15 downto 0);
		COEF		: in	std_logic_vector(15 downto 0);
		ENA		: in	std_logic;
		LAST		: in	std_logic;
		DOUT		: out	std_logic_vector(15 downto 0);
		DOUT_OK		: out	std_logic
	);
end neuron;

architecture rtl of neuron is

begin

	TODO: process(MCLK, nRST)
	begin
		if (nRST = '0') then

		elsif (MCLK'event and MCLK = '1') then

		end if;
	end process TODO;

end rtl;


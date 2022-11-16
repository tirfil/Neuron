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

entity accumulator is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		SRST		: in	std_logic;
		DIN		: in	std_logic_vector(15 downto 0);
		INFO		: in	std_logic_vector(1 downto 0);
		DOUT		: out	std_logic_vector(15 downto 0);
		DOUT_OK		: out	std_logic
	);
end accumulator;

architecture rtl of accumulator is

begin

	TODO: process(MCLK, nRST)
	begin
		if (nRST = '0') then

		elsif (MCLK'event and MCLK = '1') then

		end if;
	end process TODO;

end rtl;


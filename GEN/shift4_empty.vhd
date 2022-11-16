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

entity shift4 is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		INFO_IN		: in	std_logic_vector(1 downto 0);
		INFO_OUT		: out	std_logic_vector(1 downto 0)
	);
end shift4;

architecture rtl of shift4 is

begin

	TODO: process(MCLK, nRST)
	begin
		if (nRST = '0') then

		elsif (MCLK'event and MCLK = '1') then

		end if;
	end process TODO;

end rtl;


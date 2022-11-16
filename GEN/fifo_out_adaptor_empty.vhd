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

entity fifo_out_adaptor is
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
end fifo_out_adaptor;

architecture rtl of fifo_out_adaptor is

begin

	TODO: process(MCLK, nRST)
	begin
		if (nRST = '0') then

		elsif (MCLK'event and MCLK = '1') then

		end if;
	end process TODO;

end rtl;


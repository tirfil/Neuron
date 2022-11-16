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

entity selector is
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
end selector;

architecture rtl of selector is

begin

	TODO: process(MCLK, nRST)
	begin
		if (nRST = '0') then

		elsif (MCLK'event and MCLK = '1') then

		end if;
	end process TODO;

end rtl;


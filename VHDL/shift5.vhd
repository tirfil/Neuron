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

entity shift5 is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		INFO_IN		: in	std_logic_vector(1 downto 0);
		INFO_OUT	: out	std_logic_vector(1 downto 0);
        ORED        : out   std_logic
	);
end shift5;

architecture rtl of shift5 is
signal L1,L2,L3,L4,L5 : std_logic_vector(1 downto 0);
begin

	P0: process(MCLK, nRST)
	begin
		if (nRST = '0') then
            L1 <= (others=>'0');
            L2 <= (others=>'0');
            L3 <= (others=>'0');
            L4 <= (others=>'0');
            L5 <= (others=>'0');
		elsif (MCLK'event and MCLK = '1') then
            L1 <= INFO_IN;
            L2 <= L1;
            L3 <= L2;
            L4 <= L3;
            L5 <= L4;
		end if;
	end process P0;
    
    INFO_OUT <= L5;
    ORED <= L1(0) or L2(0) or L3(0) or L4(0) or L5(0);

end rtl;


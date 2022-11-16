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
		MCLK		    : in	std_logic;
		nRST		    : in	std_logic;
		SRST		    : in	std_logic;
		DATA_IN		    : in	std_logic_vector(15 downto 0);
		DATA_INFO		: in	std_logic_vector(1 downto 0);
		FIFO_OUT		: in	std_logic_vector(15 downto 0);
		FIFO_OK		    : in	std_logic;
		FIFO_STALL		: out	std_logic;
		ADDER_INFO		: out	std_logic_vector(1 downto 0);
		ADDER_INA		: out	std_logic_vector(15 downto 0);
		ADDER_INB		: out	std_logic_vector(15 downto 0);
		END_FLAG		: out	std_logic
	);
end selector;

architecture rtl of selector is
signal regA, regB : std_logic_vector(15 downto 0);
signal incomplete : std_logic;
signal tmp_end_info : std_logic;
signal end_info : std_logic;
begin

	P0: process(MCLK, nRST)
	begin
		if (nRST = '0') then
            ADDER_INFO <= (others=>'0');
            regA <= (others=>'0');
            regB <= (others=>'0');
            incomplete <= '0';
            tmp_end_info <= '0';
            end_info <= '0';
		elsif (MCLK'event and MCLK = '1') then
            if (DATA_INFO = "11") then
                end_info <= '1';
            end if;
            if (SRST='1') then
                ADDER_INFO <= (others=>'0');
                regA <= (others=>'0');
                regB <= (others=>'0');
                incomplete <= '0';
                tmp_end_info <= '0';
                end_info <= '0';
            elsif (FIFO_OK = '1' and DATA_INFO(0) = '1' and incomplete = '0') then
                -- out
                regA <= DATA_IN;
                regB <= FIFO_OUT;
                ADDER_INFO <= DATA_INFO;
            elsif (FIFO_OK = '1' and DATA_INFO(0) = '1' and incomplete = '1') then
                -- out
                regB <= DATA_IN;
                ADDER_INFO(0) <= '1';
                ADDER_INFO(1) <= tmp_end_info or DATA_INFO(1);
                tmp_end_info <= '0';
                incomplete <= '0';
            elsif (FIFO_OK = '0' and DATA_INFO(0) = '1' and incomplete = '0') then
                -- mem
                regA <= DATA_IN;
                incomplete <= '1';
                tmp_end_info <= DATA_INFO(1);
                ADDER_INFO <= (others=>'0');
            elsif (FIFO_OK = '0'  and DATA_INFO(0) = '1' and incomplete = '1') then
                -- out
                regB <= DATA_IN;
                incomplete <= '0';
                ADDER_INFO <= DATA_INFO;
            elsif (FIFO_OK = '1' and DATA_INFO(0) = '0' and incomplete = '0') then
                -- mem
                regA <= FIFO_OUT;
                incomplete <= '1';
                ADDER_INFO <= (others=>'0');
            elsif (FIFO_OK = '1' and DATA_INFO(0) = '0' and incomplete = '1') then
                regB <= FIFO_OUT;
                incomplete <= '0';
                ADDER_INFO(0) <= '1';
                ADDER_INFO(1) <= tmp_end_info;
                tmp_end_info <= '0';
            else
                ADDER_INFO <= (others=>'0');
            end if;
		end if;
	end process P0;
    
    ADDER_INA <= regA;
    ADDER_INB <= regB;
    
    FIFO_STALL <= '1' when (FIFO_OK = '1' and DATA_INFO(0) = '1' and incomplete = '1') else '0';
    
    END_FLAG <= '1' when (FIFO_OK = '0' and DATA_INFO(0) = '0' and incomplete = '1' and end_info = '1') else '0';

end rtl;


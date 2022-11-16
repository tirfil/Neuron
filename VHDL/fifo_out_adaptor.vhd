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
		MCLK		    : in	std_logic;
		nRST		    : in	std_logic;
		FIFO_OUT		: in	std_logic_vector(15 downto 0);
		FIFO_EMPTY		: in	std_logic;
		FIFO_READ		: out	std_logic;
		STALL		    : in	std_logic;
		DATA_OUT		: out	std_logic_vector(15 downto 0);
		DATA_VALID		: out	std_logic
	);
end fifo_out_adaptor;

architecture rtl of fifo_out_adaptor is
signal iread : std_logic;
signal loaded : std_logic;
signal read_q : std_logic;
signal reg : std_logic_vector(15 downto 0);
signal stall_q : std_logic;
signal stall_pulse : std_logic;
begin

    FIFO_READ <= iread;

    iread <=  not (FIFO_EMPTY or STALL);
    DATA_VALID <= read_q or loaded;
    
    DATA_OUT <= reg when (loaded = '1') else FIFO_OUT;
    

	P_SYNC: process(MCLK, nRST)
	begin
		if (nRST = '0') then
            read_q <= '0';
            stall_q <= '0';
		elsif (MCLK'event and MCLK = '1') then
            read_q <= iread;
            stall_q <= STALL;
		end if;
	end process P_SYNC;
    
    stall_pulse <= not(stall_q) and STALL;
    
    P_STALL: process(MCLK, nRST)
	begin
		if (nRST = '0') then
            loaded <= '0';
            reg <= (others=>'0');
		elsif (MCLK'event and MCLK = '1') then
            if (stall_pulse='1' and read_q = '1') then
                reg <= FIFO_OUT;
                loaded <= '1';
            elsif (loaded = '1' and STALL='0') then
                loaded <= '0';
            end if;
		end if;
	end process P_STALL;

end rtl;


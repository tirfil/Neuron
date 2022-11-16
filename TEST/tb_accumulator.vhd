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
use std.textio.all;

entity tb_accumulator is
end tb_accumulator;

architecture stimulus of tb_accumulator is

constant C_FILE_NAME :string  := "input.textio";
file fptr: text;

-- COMPONENTS --
	component accumulator
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			SRST		: in	std_logic;
			DIN		    : in	std_logic_vector(15 downto 0);
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
	signal DOUT_OK	: std_logic;
	signal DOUT_OK_RESYNC	: std_logic;

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
	I_accumulator_0 : accumulator
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SRST		=> SRST,
			DIN		    => DIN,
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
    
    P_RESYNC: process(MCLK)
    begin
        if (MCLK'event and MCLK='1') then
            DOUT_OK_RESYNC <= DOUT_OK;
        end if;
    end process P_RESYNC;
    
	GO: process
        type state_t is (S_AHEAD,S_START,S_RUN,S_STOP);
        variable FLINE : line;
        variable FSTATUS : file_open_status;
        variable input : bit_vector(15 downto 0);
        variable state : state_t;
        variable store : std_logic_vector(15 downto 0);
	begin
        file_open(FSTATUS,fptr,C_FILE_NAME, read_mode);
		nRST <= '0';
        INFO <= (others=>'0');
        DIN <= (others=>'0');
        SRST <= '0';
        state := S_AHEAD;
		wait for 1001 ns;
		nRST <= '1';
        wait for 100 ns;
        while (not endfile(fptr)) loop
            readline(fptr,FLINE);
            if (state = S_AHEAD) then
                read(FLINE,input);
                store := to_stdlogicvector(input);
                state := S_START;
            elsif (state = S_START) then
                INFO(0)<='1';
                read(FLINE,input);
                DIN <= store;
                store := to_stdlogicvector(input);
                wait for 20 ns;
                state := S_RUN;
            elsif (state = S_RUN) then
                if (FLINE'length = 0) then
                    INFO <= "11";
                    DIN <= store;
                    wait for 20 ns;
                    state := S_STOP;
                else
                    read(FLINE,input);
                    DIN <= store;
                    store := to_stdlogicvector(input);
                    wait for 20 ns; 
                end if;
            elsif (state = S_STOP) then
                if (FLINE'length = 0) then
                    state := S_AHEAD;
                else
                    read(FLINE,input);
                    INFO <= "00";
                    wait until (DOUT_OK_RESYNC'event and DOUT_OK_RESYNC = '1');
                    wait for 10 ns;
                    wait until (MCLK'event and MCLK='1');
                    wait for 1 ns;
                    store := to_stdlogicvector(input);
                    assert (DOUT = store) report "!!" severity warning;
                    report "DOUT= " & integer'image(to_integer(unsigned(DOUT))) & " Expected= " & integer'image(to_integer(unsigned(store)));
                    SRST <= '1';
                    wait for 20 ns;
                    SRST <= '0';
                    wait for 40 ns;
                end if;
            else
                state := S_AHEAD;
            end if;
        end loop;
        
		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;

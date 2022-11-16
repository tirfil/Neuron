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

entity tb_accumulator is
end tb_accumulator;

architecture stimulus of tb_accumulator is

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

	GO: process
	begin
		nRST <= '0';
        INFO <= (others=>'0');
        DIN <= (others=>'0');
        SRST <= '0';
		wait for 1001 ns;
		nRST <= '1';
        wait for 100 ns;
        INFO(0)<='1';
        DIN <= x"3C00"; -- 1
        wait for 20 ns; 
        DIN <= x"4000"; -- 2
        wait for 20 ns;
        DIN <= x"4200"; -- 3
        wait for 20 ns;
        DIN <= x"4400"; -- 4
        wait for 20 ns;
        DIN <= x"4500"; -- 5
        wait for 20 ns;
        DIN <= x"4600"; -- 6 
        wait for 20 ns;
        DIN <= x"4700"; -- 7
        wait for 20 ns;
        DIN <= x"4800"; -- 8
        wait for 20 ns;
        INFO(1)<='1';
        DIN <= x"4880"; -- 9
        wait for 20 ns;
        INFO <= (others=>'0');
        
        wait for 2000 ns;
        -- expect 0x51A0 = 45d
        
        
		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;

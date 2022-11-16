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

entity tb_neuron is
end tb_neuron;

architecture stimulus of tb_neuron is

-- COMPONENTS --
	component neuron
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			SRST		: in	std_logic;
			DIN		    : in	std_logic_vector(15 downto 0);
			COEF		: in	std_logic_vector(15 downto 0);
			ENA		    : in	std_logic;
			LAST		: in	std_logic;
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
	signal COEF		: std_logic_vector(15 downto 0);
	signal ENA		: std_logic;
	signal LAST		: std_logic;
	signal DOUT		: std_logic_vector(15 downto 0);
	signal DOUT_OK		: std_logic;

--
	signal RUNNING	: std_logic := '1';
    
    signal DOUT_OK_RESYNC   : std_logic;

begin

-- PORT MAP --
	I_neuron_0 : neuron
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SRST		=> SRST,
			DIN		    => DIN,
			COEF		=> COEF,
			ENA		    => ENA,
			LAST		=> LAST,
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
	begin
		nRST <= '0';
        ENA <= '0';
        LAST <= '0';
        DIN <= (others=>'0');
        COEF <= (others=>'0');
		wait for 501 ns;
		nRST <= '1';
        wait for 100 ns;
        ENA <= '1';
        DIN <=  x"3C00"; -- 1
        COEF <= x"3C00";
        wait for 20 ns;
        DIN <=  x"4000"; -- 2
        COEF <= x"4000";
        wait for 20 ns;
        DIN <=  x"4200"; -- 3
        COEF <= x"4200";
        wait for 20 ns;
        DIN <=  x"4400"; -- 4
        COEF <= x"4400";
        wait for 20 ns;
        DIN <=  x"4500"; -- 5
        COEF <= x"4500";
        wait for 20 ns;
        DIN <=  x"4600"; -- 6
        COEF <= x"4600";
        wait for 20 ns;
        DIN <=  x"4700"; -- 7
        COEF <= x"4700";
        wait for 20 ns;
        DIN <=  x"4800"; -- 8
        COEF <= x"4800";
        wait for 20 ns;
        LAST <= '1';
        DIN <=  x"4880"; -- 9
        COEF <= x"4880";
        wait for 20 ns;
        ENA <= '0';
        LAST <= '0';
        -- expect 285d = x"5C74"
        wait until DOUT_OK_RESYNC='1' and DOUT_OK_RESYNC'event;
        wait for 20 ns;
        
        

		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;

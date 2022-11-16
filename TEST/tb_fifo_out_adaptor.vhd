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

entity tb_fifo_out_adaptor is
end tb_fifo_out_adaptor;

architecture stimulus of tb_fifo_out_adaptor is

-- COMPONENTS --
	component fifo_out_adaptor
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
	end component;
    
	component fifo_control
		port(
			MCLK			: in	std_logic;
			nRST			: in	std_logic;
			FIFO_WRITE		: in	std_logic;
			FIFO_READ		: in	std_logic;
			WRADDRESS		: out	std_logic_vector(2 downto 0);
			RDADDRESS		: out	std_logic_vector(2 downto 0);
			SET_FULL		: out	std_logic;
			FIFO_FULL		: out	std_logic;
			SET_EMPTY	    : out	std_logic;
			FIFO_EMPTY		: out	std_logic;
            ABORT           : in    std_logic
		);
	end component;
    
    component dp8x16
        PORT
        (
            address_a	: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            address_b	: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            clock_a		: IN STD_LOGIC  := '1';
            clock_b		: IN STD_LOGIC 	:= '1';
            data_a		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            data_b		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            wren_a		: IN STD_LOGIC  := '0';
            wren_b		: IN STD_LOGIC  := '0';
            q_a			: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            q_b			: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
	end component;
--
-- SIGNALS --
	signal MCLK		        : std_logic;
	signal nRST		        : std_logic;
	signal FIFO_OUT		    : std_logic_vector(15 downto 0);
	signal FIFO_EMPTY		: std_logic;
	signal FIFO_READ		: std_logic;
	signal STALL		    : std_logic;
	signal DATA_OUT		    : std_logic_vector(15 downto 0);
	signal DATA_VALID		: std_logic;

--
	signal RUNNING	: std_logic := '1';
    signal logic0 : std_logic := '0';
    signal zero16 : std_logic_vector(15 downto 0) := (others=>'0');
    
    signal address_a : std_logic_vector(2 downto 0);
    signal address_b : std_logic_vector(2 downto 0);
    
    signal FIFO_WRITE : std_logic;
    signal FIFO_IN : std_logic_vector(15 downto 0);
    
    signal lfsr		: std_logic_vector(16 downto 0);
    signal fifo_full : std_logic;

begin

-- PORT MAP --
	I_fifo_out_adaptor_0 : fifo_out_adaptor
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			FIFO_OUT		=> FIFO_OUT,
			FIFO_EMPTY		=> FIFO_EMPTY,
			FIFO_READ		=> FIFO_READ,
			STALL		=> STALL,
			DATA_OUT		=> DATA_OUT,
			DATA_VALID		=> DATA_VALID
		);
    I_fifo_control_0 : fifo_control
		port map (
			MCLK			=> MCLK,
			nRST			=> nRST,
			FIFO_WRITE		=> FIFO_WRITE,
			FIFO_READ		=> FIFO_READ,
			WRADDRESS		=> address_a,
			RDADDRESS		=> address_b,
			SET_FULL		=> open,
			FIFO_FULL		=> fifo_full,
			SET_EMPTY   	=> open,
			FIFO_EMPTY		=> FIFO_EMPTY,
            ABORT           => logic0
		);
	I_RAM_0 : dp8x16
		port map (
			address_a => address_a,
			address_b => address_b,
			clock_a => MCLK,
			clock_b => MCLK,
			data_a => FIFO_IN,
			data_b => zero16,
			wren_a => FIFO_WRITE,
			wren_b => logic0,
			q_a => open,
			q_b => FIFO_OUT
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
    

	PLFSR: process(MCLK, nRST)
	begin
		if (nRST = '0') then
			--lfsr <= (0=>'1',others=>'0');
			--lfsr <= (others=>'1');
			lfsr <= "11100011100011100";
		elsif (MCLK'event and MCLK = '1') then
			lfsr(0) <= lfsr(16) xor lfsr(13);
			lfsr(16 downto 1) <= lfsr(15 downto 0);
		end if;
	end process PLFSR;

	GO: process
    variable i : INTEGER range 0 to 255;
	begin
		nRST <= '0';
        --STALL <= '0';
        FIFO_WRITE <= '0';
        FIFO_IN <= (others=>'0');
		wait for 1001 ns;
		nRST <= '1';
        wait for 200 ns;
        for i in  0 to 255 loop
            while (lfsr(1 downto 0) = "00") loop
                FIFO_WRITE <= '0';
                wait for 20 ns;
            end loop;
            --if ((i = 32) or (i = 33)) then
                --STALL <= '1';
            --else
                --STALL <= '0';
            --end if;
            while (fifo_full = '1') loop
                FIFO_WRITE <= '0';
                wait for 20 ns;
            end loop;
            FIFO_WRITE <= '1';
            FIFO_IN <= std_logic_vector(to_unsigned(i,16));
            wait for 20 ns;
        end loop;
        FIFO_WRITE <= '0';
        wait for 1000 ns;
		RUNNING <= '0';
		wait;
	end process GO;
    
    GO1: process
    begin
        --wait until DATA_VALID='1';
        wait until MCLK'event and MCLK = '1';
        wait for 1 ns;
        if (DATA_VALID='1') then 
            if (lfsr(3 downto 2) = "01") then
                STALL <= '1';
            else
                STALL <= '0';
            end if;
        else
            STALL <= '0';
        end if;
        --wait until MCLK'event and MCLK = '1';
    end process GO1;
    
    
	PPP : process(MCLK)
		variable value : integer;
		variable test  : integer := 0;
	begin
		if (MCLK'event and MCLK = '1') then
			if (DATA_VALID='1' and STALL='0') then
				value := to_integer(unsigned(DATA_OUT));
				report integer'image(value) & "/" & integer'image(test);
				assert value = test report "wrong value" severity failure;
				test := test + 1;
			end if;
		end if;
	end process PPP;
        

end stimulus;

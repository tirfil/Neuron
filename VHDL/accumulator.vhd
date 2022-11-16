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

entity accumulator is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		SRST		: in	std_logic;
		DIN		    : in	std_logic_vector(15 downto 0);
		INFO		: in	std_logic_vector(1 downto 0);
		DOUT		: out	std_logic_vector(15 downto 0);
		DOUT_OK		: out	std_logic
	);
end accumulator;

architecture struct of accumulator is

	component selector
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			SRST		: in	std_logic;
			DATA_IN		: in	std_logic_vector(15 downto 0);
			DATA_INFO		: in	std_logic_vector(1 downto 0);
			FIFO_OUT		: in	std_logic_vector(15 downto 0);
			FIFO_OK		    : in	std_logic;
			FIFO_STALL		: out	std_logic;
			ADDER_INFO		: out	std_logic_vector(1 downto 0);
			ADDER_INA		: out	std_logic_vector(15 downto 0);
			ADDER_INB		: out	std_logic_vector(15 downto 0);
			END_FLAG		: out	std_logic
		);
	end component;
    
	component shift5
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			INFO_IN		: in	std_logic_vector(1 downto 0);
			INFO_OUT	: out	std_logic_vector(1 downto 0);
            ORED        : out   std_logic
		);
	end component;
    
	component fp16adderppl
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			ENABLE		: in	std_logic;
			IN1		    : in	std_logic_vector(15 downto 0);
			IN2		    : in	std_logic_vector(15 downto 0);
			OUT0		: out	std_logic_vector(15 downto 0)
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
			SET_EMPTY	: out	std_logic;
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

    signal logic0 : std_logic := '0';
    signal logic1 : std_logic := '1';
    signal zero16  : std_logic_vector(15 downto 0) := (others=>'0');
    
    
    signal FIFO_OUT :  std_logic_vector(15 downto 0);
    signal FIFO_EMPTY : std_logic;
    signal FIFO_READ : std_logic;
    signal FIFO_STALL : std_logic;
    signal ADDER_INA :  std_logic_vector(15 downto 0);
    signal ADDER_INB :  std_logic_vector(15 downto 0);
    --signal ADDER_OK : std_logic;
    signal END_FLAG : std_logic;
    signal data_a :  std_logic_vector(15 downto 0);
    signal fifo_info : std_logic_vector(1 downto 0);
    signal ADDER_INFO : std_logic_vector(1 downto 0);
    signal address_a :  std_logic_vector(2 downto 0);
    signal address_b :  std_logic_vector(2 downto 0);
    signal DATA_OUT :  std_logic_vector(15 downto 0);
    signal DATA_VALID : std_logic;
    
    signal ored       : std_logic;
    
begin


	I_selector_0 : selector
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SRST		=> SRST,
			DATA_IN		=> DIN,
			DATA_INFO		=> INFO,
			FIFO_OUT		=> DATA_OUT,
			FIFO_OK		    => DATA_VALID,
			FIFO_STALL		=> FIFO_STALL,
			ADDER_INFO		=> ADDER_INFO,
			ADDER_INA		=> ADDER_INA,
			ADDER_INB		=> ADDER_INB,
			END_FLAG		=> END_FLAG
		);
        
	I_shift5_0 : shift5
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			INFO_IN		=> ADDER_INFO,
			INFO_OUT	=> fifo_info,
            ORED        => ored
		);
    
	I_fp16adderppl_0 : fp16adderppl
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			ENABLE		=> logic1,
			IN1		=> ADDER_INA,
			IN2		=> ADDER_INB,
			OUT0		=> data_a
		);
                
    I_fifo_control_0 : fifo_control
		port map (
			MCLK			=> MCLK,
			nRST			=> nRST,
			FIFO_WRITE		=> fifo_info(0),
			FIFO_READ		=> FIFO_READ,
			WRADDRESS		=> address_a,
			RDADDRESS		=> address_b,
			SET_FULL		=> open,
			FIFO_FULL		=> open,
			SET_EMPTY   	=> open,
			FIFO_EMPTY		=> FIFO_EMPTY,
            ABORT           => SRST
		);
        
	I_fifo_out_adaptor_0 : fifo_out_adaptor
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			FIFO_OUT		=> FIFO_OUT,
			FIFO_EMPTY		=> FIFO_EMPTY,
			FIFO_READ		=> FIFO_READ,
			STALL		    => FIFO_STALL,
			DATA_OUT		=> DATA_OUT,
			DATA_VALID		=> DATA_VALID
		);
        
	I_RAM_0 : dp8x16
		port map (
			address_a => address_a,
			address_b => address_b,
			clock_a => MCLK,
			clock_b => MCLK,
			data_a => data_a,
			data_b => zero16,
			wren_a => fifo_info(0),
			wren_b => logic0,
			q_a => open,
			q_b => FIFO_OUT
		);
        
    DOUT <= ADDER_INA;
    DOUT_OK <= END_FLAG and FIFO_EMPTY and not ored;

    
end struct;


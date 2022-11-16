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

entity neuron is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
        SRST        : in    std_logic;
		DIN		    : in	std_logic_vector(15 downto 0);
		COEF		: in	std_logic_vector(15 downto 0);
		ENA		    : in	std_logic;
		LAST		: in	std_logic;
		DOUT		: out	std_logic_vector(15 downto 0);
		DOUT_OK		: out	std_logic
	);
end neuron;

architecture rtl of neuron is
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
	component shift4
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			INFO_IN		: in	std_logic_vector(1 downto 0);
			INFO_OUT	: out	std_logic_vector(1 downto 0);
            ORED        : out   std_logic
		);
	end component;
	component fp16multppl
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			ENABLE		: in	std_logic;
			IN1		: in	std_logic_vector(15 downto 0);
			IN2		: in	std_logic_vector(15 downto 0);
			OUT0		: out	std_logic_vector(15 downto 0)
		);
	end component;
signal MULTOUT : std_logic_vector(15 downto 0);
signal ADDINFO : std_logic_vector(1 downto 0);
signal MULTINFO : std_logic_vector(1 downto 0);
signal ACCOUT  : std_logic_vector(15 downto 0);
signal logic1 : std_logic := '1';
        
begin
    -- ACCUMULATOR
	I_accumulator_0 : accumulator
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SRST		=> SRST,
			DIN		    => MULTOUT,
			INFO		=> ADDINFO,
			DOUT		=> ACCOUT,
			DOUT_OK		=> DOUT_OK
		);
        
    -- MULT
    MULTINFO(0) <= ENA;
    MULTINFO(1) <= LAST;
	I_shift4_0 : shift4
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			INFO_IN		=> MULTINFO,
			INFO_OUT	=> ADDINFO,
            ORED        => open
		);
	I_fp16multppl_0 : fp16multppl
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			ENABLE		=> logic1,
			IN1		    => DIN,
			IN2		    => COEF,
			OUT0		=> MULTOUT
		);
        
    -- activation function: RELU
    DOUT <= ACCOUT when ACCOUT(1) = '0' else (others=>'0');


end rtl;


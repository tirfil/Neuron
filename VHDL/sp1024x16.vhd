--###############################
--# Project Name : 
--# File         : 
--# Project      : VHDL RAM model
--# Engineer     : 
--# Modification History
--###############################
-- VHDL model for altera

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

ENTITY sp1024x16 IS
	PORT
	(
		address	    : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q			: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END sp1024x16;

architecture rtl of sp1024x16 is
    type memory is array(0 to 1023) of std_logic_vector(15 downto 0);
    impure function init_ram_from_file( filename : in string) return memory is
        file text_file : text is in filename;
        variable text_line : line;
        variable ram : memory;
        variable bv : bit_vector(15 downto 0);
        
    begin
      for I in memory'range loop
        readline(text_file, text_line);
        read(text_line, bv);
        ram(I) := to_stdlogicvector(bv);
      end loop;
      return ram;
    end function;
    
	signal mem : memory := init_ram_from_file("sp1024x16.dat");
begin
	RAM : process(clock)
	begin
		if (clock'event and clock='1') then
				if (wren = '0') then
					q <= mem(to_integer(unsigned(address)));
				else
					mem(to_integer(unsigned(address))) <= data;
					q <= data;  -- ????
				end if;
		end if;
	end process RAM;
end rtl;

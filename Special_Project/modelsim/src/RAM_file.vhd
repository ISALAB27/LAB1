library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity RAM_file is
	generic(mem_width 		: integer 	:= 32;
			mem_height		: integer	:= 12;
			file_name		: string);
	port(	Address			: in std_logic_vector(mem_height-1 downto 0);
			WriteData 		: in std_logic_vector(mem_width-1 downto 0);
			MemWrite		: in std_logic;
			MemRead			: in std_logic;
			ReadData 		: out std_logic_vector(mem_width-1 downto 0));
end entity;

architecture behaviour of RAM_file is

	type MEM is array (0 to (2**mem_height)-1) of std_logic_vector(mem_width-1 downto 0);
	
begin
	
	process(Address, MemWrite, MemRead)
	
		impure function init_data return MEM is
			file text_file : text open READ_MODE is file_name;
			variable text_line : line;
			variable text_data : MEM := (others => (others => '0'));	-- fill with zeros
			variable bv : bit_vector(text_data(0)'range);
		begin
			for i in 0 to (2**mem_height)-1 loop
				if not endfile(text_file) then
					readline(text_file, text_line);
					read(text_line, bv);
					text_data(i) := To_StdLogicVector(bv);
				else
					exit;
				end if;
			end loop;
			return text_data;
		end function;
	
		variable data : MEM := init_data;
	
	begin
		if (MemRead = '1' and MemWrite = '0') then
			ReadData <= data(to_integer(unsigned(Address)));
		elsif (MemRead = '0' and MemWrite = '1') then
			data(to_integer(unsigned(Address))) := WriteData;
			ReadData <= (others => 'Z');
		else
			ReadData <= (others => 'Z');
		end if;
	end process;
	
end architecture;
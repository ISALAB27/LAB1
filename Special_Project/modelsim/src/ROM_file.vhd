library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity ROM_file is
	generic(mem_width 		: integer 	:= 32;
			mem_height		: integer	:= 12;
			file_name		: string);
	port(	Address			: in std_logic_vector(mem_height-1 downto 0);
			ReadData 		: out std_logic_vector(mem_width-1 downto 0));
end entity;

architecture behaviour of ROM_file is

	type MEM is array (0 to (2**mem_height)-1) of std_logic_vector(mem_width-1 downto 0);
	
begin

	process(Address)
		
		impure function init_data return MEM is
			file text_file : text open READ_MODE is file_name;
			variable text_line : line;
			variable text_data : MEM := (others => (x"00000013"));	-- fill with nop
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
		
		-- write data only on initialization
		variable data : MEM := init_data;

	begin
		ReadData <= data(to_integer(unsigned(Address)));
	end process;
	
end architecture;
library ieee;
use ieee.std_logic_1164.all;

entity tb_ROM_file is
end entity; 

architecture behaviour of tb_ROM_file is

	component ROM_file is
		generic(mem_width 		: integer;
				mem_height		: integer;
				file_name		: string);
		port(	Address			: in std_logic_vector(mem_height-1 downto 0);
				ReadData 		: out std_logic_vector(mem_width-1 downto 0));
	end component;

signal Address 	: std_logic_vector(11 downto 0);
signal ReadData : std_logic_vector(31 downto 0);

begin

	Address <= x"000", x"001" after 10 ns, x"002" after 20 ns, x"003" after 30 ns, x"004" after 40 ns, x"005" after 50 ns;
	
	DUT : ROM_file generic map (mem_width => 32, mem_height => 12, file_name => "../ROM_bin.txt") port map (Address => Address, ReadData => ReadData);

end architecture; 

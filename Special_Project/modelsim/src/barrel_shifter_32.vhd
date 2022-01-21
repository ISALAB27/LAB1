library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrel_shifter_32 is
	port(	Input				: in std_logic_vector(31 downto 0);
			ShiftAmount			: in std_logic_vector(4 downto 0);
			Output				: out std_logic_vector(31 downto 0));
end entity;

architecture behaviour of barrel_shifter_32 is
begin

	Output <= to_stdlogicvector(to_bitvector(Input) sra to_integer(unsigned(ShiftAmount)));
	
end architecture;
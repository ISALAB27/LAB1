library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult is
	generic(N 		: integer 	:= 6);
	port(	a 		: in std_logic_vector(N-1 downto 0);
			b 		: in std_logic_vector(N-1 downto 0);
			res		: out std_logic_vector((N*2)-1 downto 0));
end mult;

architecture behaviour of mult is
begin
	res <= std_logic_vector(signed(a) * signed(b));
end behaviour;

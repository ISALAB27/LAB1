Library ieee;
use ieee.std_logic_1164.all;

entity tb_mult_radix4 is
end tb_mult_radix4; 

architecture beh of tb_mult_radix4 is

	component mult_radix4 is
		port(	A 		: in std_logic_vector(23 downto 0);
				B 		: in std_logic_vector(23 downto 0);
				P 		: out std_logic_vector(47 downto 0));
	end component;

signal A, B		: std_logic_vector(23 downto 0);
signal P		: std_logic_vector(47 downto 0);

begin

	A <= X"000000"; --X"9E377A";
	B <= X"000000"; --X"9E377A";

	DUT : mult_radix4 port map (A => A, B => B, P => P);

end architecture; 

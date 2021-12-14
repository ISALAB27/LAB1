library ieee;
use ieee.std_logic_1164.all;

entity half_adder is
	port (	x, y 	: in std_logic;
			sum 	: out std_logic;
			cout 	: out std_logic);
end entity;

architecture beh of half_adder is
signal carry_sig : std_logic;
begin
	carry_sig <= x and y;
	cout <= carry_sig;
	sum <= carry_sig nor (x nor y);
	
	--sum 	<= x xor y;
	--cout 	<= x and y;
end architecture;
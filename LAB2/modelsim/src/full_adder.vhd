library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
	port (	x, y, cin 	: in std_logic;
			sum 		: out std_logic;
			cout 		: out std_logic);
end entity;

architecture low_power of full_adder is
signal int_sig1, int_sig2, int_sig3 : std_logic;
begin

	int_sig1 	<= x nand y;
	int_sig2 	<= (x nand int_sig1) nand (y nand int_sig1);
	int_sig3 	<= cin nand int_sig2;
	
	sum 		<= (int_sig2 nand int_sig3) nand (cin nand int_sig3);
	cout 		<= int_sig1 nand int_sig3;
end architecture;

--architecture high_speed of full_adder is
--begin
--	sum 	<= (x xor y) xor cin;
--	cout 	<= (x and y) or (x and cin) or (y and cin);
--end architecture;

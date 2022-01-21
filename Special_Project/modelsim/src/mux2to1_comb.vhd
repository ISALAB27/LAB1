library ieee;
use ieee.std_logic_1164.all;

entity mux2to1_comb is
	port(	A, B	: in std_logic;
			S		: in std_logic;
			Y		: out std_logic);
end entity;

architecture behaviour of mux2to1_comb is
begin

	--Y <= (A and not(S)) or (B and S);
	Y <= (A nand not(S)) nand (B nand S);
	
end architecture;
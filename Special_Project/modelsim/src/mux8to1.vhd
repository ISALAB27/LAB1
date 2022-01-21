library ieee;
use ieee.std_logic_1164.all;

entity mux8to1 is
	generic(N 						: integer := 8);
	port(	A, B, C, D, E, F, G, H	: in std_logic_vector(N-1 downto 0);
			S						: in std_logic_vector(2 downto 0);
			Y						: out std_logic_vector(N-1 downto 0));
end entity;

architecture behaviour of mux8to1 is
begin

	process (A, B, C, D, E, F, G, H, S)
	begin
		if S = "000" then
			Y <= A;
		elsif S = "001" then
			Y <= B;
		elsif S = "010" then
			Y <= C;
		elsif S = "011" then
			Y <= D;
		elsif S = "100" then
			Y <= E;
		elsif S = "101" then
			Y <= F;
		elsif S = "110" then
			Y <= G;
		else
			Y <= H;
		end if;
	end process;
	
end architecture;
library ieee;
use ieee.std_logic_1164.all;

entity mux4to1 is
	generic(N 			: integer := 8);
	port(	A, B, C, D	: in std_logic_vector(N-1 downto 0);
			S			: in std_logic_vector(1 downto 0);
			Y			: out std_logic_vector(N-1 downto 0));
end entity;

architecture behaviour of mux4to1 is
begin

	process (A, B, C, D, S)
	begin
		if S = "00" then
			Y <= A;
		elsif S = "01" then
			Y <= B;
		elsif S = "10" then
			Y <= C;
		else
			Y <= D;
		end if;
	end process;
	
end architecture;
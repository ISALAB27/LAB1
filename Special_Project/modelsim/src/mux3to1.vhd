library ieee;
use ieee.std_logic_1164.all;

entity mux3to1 is
	generic(N 		: integer := 8);
	port(	A, B, C	: in std_logic_vector(N-1 downto 0);
			S		: in std_logic_vector(1 downto 0);
			Y		: out std_logic_vector(N-1 downto 0));
end entity;

architecture behaviour of mux3to1 is
begin

	process (A, B, C, S)
	begin
		if S = "00" then
			Y <= A;
		elsif S = "01" then
			Y <= B;
		else
			Y <= C;
		end if;
	end process;
	
end architecture;
library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
	generic(N 		: integer := 8);
	port(	A, B	: in std_logic_vector(N-1 downto 0);
			S		: in std_logic;
			Y		: out std_logic_vector(N-1 downto 0));
end entity;

architecture struct of mux2to1 is 

	component mux2to1_comb
		port(	A, B	: in std_logic;
				S		: in std_logic;
				Y		: out std_logic);
	end component;

begin

	genMUX : for i in 0 to N-1 generate
		mux_x : mux2to1_comb port map (
			A => A(i),
			B => B(i),
			S => S,
			Y => Y(i)
		);
	end generate genMUX;

end architecture;

--architecture behaviour of mux2to1 is
--begin
--	process (A, B, S)
--	begin
--		if S = '0' then
--			Y <= A;
--		else
--			Y <= B;
--		end if;
--	end process;
--end architecture;
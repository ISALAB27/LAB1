library ieee;
use ieee.std_logic_1164.all;
 
entity RCS is
	generic(N		: integer := 8);
	port(	x		: in std_logic_vector(N-1 downto 0);
			y		: in std_logic_vector(N-1 downto 0);
			b_in	: in std_logic;
			sub		: out std_logic_vector(N-1 downto 0);
			b_out	: out std_logic ); 
end entity;

architecture struct of RCS is

	component full_subtractor is
		port(	x		: in std_logic;    
				y 		: in std_logic;
				b_in 	: in std_logic;
				sub 	: out std_logic;
				b_out 	: out std_logic);
	end component;
	

signal b_sig: std_logic_vector(N downto 0);

begin

	b_sig(0) <= b_in;

	RCS_gen : for i in 0 to N-1 generate
		FSx : full_subtractor port map(
			x		=> x(i),
			y 		=> y(i),
			b_in 	=> b_sig(i),
			sub 	=> sub(i),
			b_out 	=> b_sig(i + 1)
		);
	end generate RCS_gen;
	
	b_out <= b_sig(N);

end architecture;
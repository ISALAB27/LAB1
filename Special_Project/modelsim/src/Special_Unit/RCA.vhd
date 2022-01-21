library ieee;
use ieee.std_logic_1164.all;

entity RCA is
	generic(N 			: integer := 32);
	port (	a          	: in std_logic_vector(N-1 downto 0);
			b          	: in std_logic_vector(N-1 downto 0);
			carry_in   	: in std_logic;
			sum        	: out std_logic_vector(N-1 downto 0);
			carry_out  	: out std_logic);
end entity;

architecture structural of RCA is

	component full_adder
		port (	x, y, cin  : in std_logic;
				sum        : out std_logic;
				cout       : out std_logic);
	end component;
 
signal carrys_sig : std_logic_vector(N downto 0);
 
begin

	carrys_sig(0) <= carry_in;

	RCA_gen : for i in 0 to N - 1 generate
		FAx : full_adder port map(
			x		=> a(i),
			y 		=> b(i),
			cin 	=> carrys_sig(i),
			sum 	=> sum(i),
			cout 	=> carrys_sig(i + 1)
		);
	end generate RCA_gen;
	
	carry_out <= carrys_sig(N);

end architecture;
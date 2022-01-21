library ieee;
use ieee.std_logic_1164.all;

entity tb_ALU is
end entity; 

architecture behaviour of tb_ALU is

	component ALU is
		generic(N 		: integer);
		port(	a 		: in std_logic_vector(N-1 downto 0);
				b 		: in std_logic_vector(N-1 downto 0);
				ctrl	: in std_logic_vector(2 downto 0);
				zero	: out std_logic;
				res		: out std_logic_vector(N-1 downto 0));
	end component;

signal a, b, res 	: std_logic_vector(31 downto 0);
signal ctrl			: std_logic_vector(2 downto 0);
signal zero			: std_logic;

begin

	a	<= x"55555555";  --x"7FFFFFFF";
	b  	<= x"AAAAAAAA";  --x"7FFFFFFF";
	ctrl <= "000", "001" after 10 ns, "010" after 20 ns, "011" after 30 ns, "100" after 40 ns, "101" after 50 ns;
	
	DUT : ALU generic map (N => 32) port map (a => a, b => b, ctrl => ctrl, zero => zero, res => res);

end architecture; 

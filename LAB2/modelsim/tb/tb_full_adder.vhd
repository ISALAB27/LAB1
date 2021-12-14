Library ieee;
use ieee.std_logic_1164.all;

entity tb_full_adder is
end tb_full_adder; 

architecture beh of tb_full_adder is

	component full_adder is
		port (	x, y, cin 	: in std_logic;
				sum 		: out std_logic;
				cout 		: out std_logic);
	end component;

signal x, y, cin, sum, cout	: std_logic;

begin

	x <= '0', '1' after 5 ns, '0' after 10 ns, '1' after 15 ns, '0' after 20 ns, '1' after 25 ns, '0' after 30 ns, '1' after 35 ns;
	y <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns;
	cin <= '0', '1' after 20 ns;
	
	DUT : entity work.full_adder(low_power) port map (x => x, y => y, cin => cin, sum => sum, cout => cout);

end architecture; 

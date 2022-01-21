library ieee;
use ieee.std_logic_1164.all;

entity tb_RCS is
end entity;

architecture beh of tb_RCS is

	component RCS is
		generic(N		: integer);
		port(	x		: in std_logic_vector(N-1 downto 0);
				y		: in std_logic_vector(N-1 downto 0);
				b_in	: in std_logic;
				sub		: out std_logic_vector(N-1 downto 0);
				b_out	: out std_logic ); 
	end component;

signal x, y, sub	: std_logic_vector (3 downto 0);
signal b_in, b_out 	: std_logic;

begin

	process
	begin 
		x <= "0000";
		y <= "0000";
		b_in <= '0';

		wait for 5 ns;
		x <= "1010";
		y <= "0001";
		b_in <= '0';

		wait for 5 ns;
		x <= "1111";
		y <= "1111";
		b_in <= '0';
		
		wait for 5 ns;
		x <= "1111";
		y <= "0000";
		b_in <= '1';
		
		wait for 5 ns;
		x <= "0000";
		y <= "1111";
		b_in <= '0';
		
		wait for 5 ns;
		x <= "0000";
		y <= "1111";
		b_in <= '1';
		
		wait for 5 ns;
		x <= "0111";
		y <= "1111";
		b_in <= '0';

		wait for 20 ns;
	end process;

	DUT : RCS generic map (N => 4) port map (
		x 			=> x,
		y 			=> y,
		b_in		=> b_in,
		sub 		=> sub,
		b_out		=> b_out
	);

end architecture;
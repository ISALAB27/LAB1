library ieee;
use ieee.std_logic_1164.all;

entity tb_RCA is
end entity;

architecture beh of tb_RCA is

	component RCA is
		generic(N 			: integer);
		port (	a 			: in std_logic_vector(N-1 downto 0);
				b			: in std_logic_vector(N-1 downto 0);
				carry_in	: in std_logic;
				sum 		: out std_logic_vector(N-1 downto 0);
				carry_out 	: out std_logic);
	end component;


signal a, b 	: std_logic_vector (3 downto 0);
signal sum 		: std_logic_vector (3 downto 0);
signal carry_in, carry_out : std_logic;

begin

	process
	begin 
		a <= "0001";
		b <= "0001";
		carry_in <= '1';

		wait for 5 ns;
		a <= "0001";
		b <= "0001";
		carry_in <= '1';

		wait for 5 ns;
		a <= "0001";
		b <= "1111";
		carry_in <= '0';

		wait for 5 ns;
		a <= "0000";
		b <= "1010";
		carry_in <= '0';

		wait for 5 ns;
		a <= "0011";
		b <= "0101";
		carry_in <= '0';

		wait for 5 ns;
	end process;

	DUT : RCA generic map (N => 4) port map (
		a 			=> a,
		b 			=> b,
		carry_in 	=> carry_in,
		carry_out 	=> carry_out,
		sum 		=> sum
	);

end architecture;
library ieee;
use ieee.std_logic_1164.all;

entity tb_CSA is
end entity;

architecture beh of tb_CSA is

	component CSA is
		generic(bits		: integer;
				block_bits 	: integer);
		port (	a 			: in std_logic_vector(bits-1 downto 0);
				b			: in std_logic_vector(bits-1 downto 0);
				carry_in	: in std_logic;
				sum 		: out std_logic_vector(bits-1 downto 0);
				carry_out 	: out std_logic);
	end component;

signal a, b, sum			: std_logic_vector (9 downto 0);
signal carry_in, carry_out 	: std_logic;

begin

	process
	begin 
		a <= "10" & x"aa";
		b <= "00" & x"01";
		carry_in <= '1';

		wait for 5 ns;
		a <= "11" & x"ff";
		b <= "11" & x"ff";
		carry_in <= '0';
		
		wait for 5 ns;
		a <= "11" & x"ff";
		b <= "00" & x"00";
		carry_in <= '0';
		
		wait for 5 ns;
		a <= "00" & x"00";
		b <= "00" & x"00";
		carry_in <= '0';
		
		wait for 50 ns;
	end process;

	DUT : CSA generic map (bits => 10, block_bits => 4) port map (
		a 			=> a,
		b 			=> b,
		carry_in 	=> carry_in,
		sum 		=> sum,
		carry_out 	=> carry_out
	);

end architecture;
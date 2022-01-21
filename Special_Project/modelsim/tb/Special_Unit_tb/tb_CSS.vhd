library ieee;
use ieee.std_logic_1164.all;

entity tb_CSS is
end entity;

architecture beh of tb_CSS is

	component CSS is
		generic(bits		: integer;
				block_bits 	: integer);
		port (	a 			: in std_logic_vector(bits-1 downto 0);
				b			: in std_logic_vector(bits-1 downto 0);
				b_in		: in std_logic;
				sub 		: out std_logic_vector(bits-1 downto 0);
				b_out 		: out std_logic);
	end component;

signal a, b, sub	: std_logic_vector (9 downto 0);
signal b_in, b_out 	: std_logic;

begin

	process
	begin 
		a <= "10" & x"aa";
		b <= "00" & x"01";
		b_in <= '1';

		wait for 5 ns;
		a <= "11" & x"ff";
		b <= "11" & x"ff";
		b_in <= '0';
		
		wait for 5 ns;
		a <= "11" & x"ff";
		b <= "00" & x"00";
		b_in <= '0';
		
		wait for 5 ns;
		a <= "00" & x"00";
		b <= "00" & x"00";
		b_in <= '0';
		
		wait for 50 ns;
	end process;

	DUT : CSS generic map (bits => 10, block_bits => 4) port map (
		a 		=> a,
		b 		=> b,
		b_in 	=> b_in,
		sub 	=> sub,
		b_out 	=> b_out
	);

end architecture;
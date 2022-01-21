library ieee;
use ieee.std_logic_1164.all;

entity Special_Unit is
	generic(square_root_bits : integer := 12);
	port (	x		: in std_logic_vector(31 downto 0);
			ctrl	: in std_logic;
			res		: out std_logic_vector(31 downto 0));
end entity;

architecture beh of Special_Unit is

	component square_root is
		generic(N 		: integer);
		port(	rad		: in std_logic_vector(N-1 downto 0);
				r		: out std_logic_vector((N+1)/2 downto 0);
				q		: out std_logic_vector(((N+1)/2)-1 downto 0));
	end component;
	
	component mux2to1 
		generic(N 		: integer);
		port(	A, B	: in std_logic_vector(N-1 downto 0);
				S		: in std_logic;
				Y		: out std_logic_vector(N-1 downto 0));
	end component;

signal r_sig : std_logic_vector((square_root_bits+1)/2 downto 0);
signal q_sig : std_logic_vector(((square_root_bits+1)/2) downto 0);

begin

	SR : square_root generic map (N => square_root_bits) port map (
		rad => x(square_root_bits-1 downto 0),
		r 	=> r_sig,
		q 	=> q_sig(((square_root_bits+1)/2)-1 downto 0)
	);
	
	mux : mux2to1 generic map (N => ((square_root_bits+1)/2)+1) port map (
		A	=> q_sig,
		B	=> r_sig,
		S	=> ctrl,
		Y	=> res((square_root_bits+1)/2 downto 0)
	);
	
	q_sig((square_root_bits+1)/2) <= '0';
	res(31 downto ((square_root_bits+1)/2)+1) <= (others => '0');

end architecture;

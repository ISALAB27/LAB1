library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port(	a 		: in std_logic_vector(31 downto 0);
			b 		: in std_logic_vector(31 downto 0);
			ctrl	: in std_logic_vector(2 downto 0);
			zero	: out std_logic;
			res		: out std_logic_vector(31 downto 0));
end entity;

architecture behaviour of ALU is

	component mux8to1 is
		generic(N 						: integer);
		port(	A, B, C, D, E, F, G, H	: in std_logic_vector(N-1 downto 0);
				S						: in std_logic_vector(2 downto 0);
				Y						: out std_logic_vector(N-1 downto 0));
	end component;
	
	component barrel_shifter_32 is
		port(	Input				: in std_logic_vector(31 downto 0);
				ShiftAmount			: in std_logic_vector(4 downto 0);
				Output				: out std_logic_vector(31 downto 0));
	end component;


signal SRAI_sig, SLT_sig, XOR_sig, AND_sig, ADD_sig, SUB_sig : std_logic_vector(31 downto 0);
signal sub_with_cout : std_logic_vector(32 downto 0);
signal res_sig : std_logic_vector(31 downto 0);

begin

	srai : barrel_shifter_32 port map (
		Input			=> a,
		ShiftAmount		=> b(4 downto 0),
		Output			=> SRAI_sig
	);

	--SRAI_sig(31-to_integer(unsigned(b(4 downto 0))) downto 0) <= a(31 downto to_integer(unsigned(b(4 downto 0))));
	--SRAI_sig(31 downto 31-to_integer(unsigned(b(4 downto 0)))) <= (others => a(31));
	sub_with_cout <= std_logic_vector(resize(signed(a), 33) - resize(signed(b), 33));
	SLT_sig(0) <= sub_with_cout(32);
	SLT_sig(31 downto 1) <= (others => '0');
	XOR_sig		<= a xor b;
	AND_sig		<= a and b;
	ADD_sig		<= std_logic_vector(signed(a) + signed(b));
	SUB_sig		<= std_logic_vector(signed(a) - signed(b));

	mux : mux8to1 generic map (N => 32) port map (
		A	=> SRAI_sig,
		B	=> SLT_sig,
		C	=> XOR_sig,
		D	=> AND_sig,
		E	=> ADD_sig,
		F	=> SUB_sig,
		G	=> (others => '0'),
		H	=> (others => '0'),
		S	=> ctrl,
		Y	=> res_sig
	);
	
	res <= res_sig;
	zero <= '1' when to_integer(unsigned(res_sig)) = 0 else '0'; 

end architecture;

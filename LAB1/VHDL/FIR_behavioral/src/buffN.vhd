library ieee;
use ieee.std_logic_1164.all;
use work.array_type.all;

entity buffN is
	generic(N 		: integer 	:= 11);
	port(	load, clk, rst 		: in std_logic;
			sin 				: in std_logic_vector(lenght-1 downto 0 );
			pout 				: out array_slv(0 to N-1));
end buffN;

architecture behaviour of buffN is

	component regN is
		generic(N 		: integer);
		port(	load, clk, rst 		: in std_logic;
				pin 				: in std_logic_vector(N-1 downto 0 );
				pout 				: out std_logic_vector(N-1 downto 0 ));
	end component;

signal r_sig		: array_slv(0 to N);
begin

	r_sig(0) <= sin;

	GEN_BUFF: for I in 0 to n-1 generate
				RX : regN generic map(n => lenght) port map(load => load, clk => CLK, rst => rst, pin => r_sig(I), pout => r_sig(I+1));
			  end generate GEN_BUFF;
			  
	pout <= r_sig(1 to N);
end behaviour;

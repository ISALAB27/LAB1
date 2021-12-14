library ieee;
use ieee.std_logic_1164.all;

entity tb_PP_Selector is
end entity; 

architecture beh of tb_PP_Selector is

	component PP_Selector is
		port(	A 			: in std_logic_vector (23 downto 0);
				S 			: in std_logic_vector (11 downto 0);
				S_neg 		: in std_logic_vector (11 downto 0);
				Shift 		: in std_logic_vector (11 downto 0);
				Shift_neg 	: in std_logic_vector (11 downto 0);
				Zero 		: in std_logic_vector (12 downto 0);
				PP0 		: out std_logic_vector (24 downto 0);
				PP1 		: out std_logic_vector (24 downto 0);
				PP2 		: out std_logic_vector (24 downto 0);
				PP3 		: out std_logic_vector (24 downto 0);
				PP4 		: out std_logic_vector (24 downto 0);
				PP5 		: out std_logic_vector (24 downto 0);
				PP6 		: out std_logic_vector (24 downto 0);
				PP7			: out std_logic_vector (24 downto 0);
				PP8 		: out std_logic_vector (24 downto 0);
				PP9 		: out std_logic_vector (24 downto 0);
				PP10 		: out std_logic_vector (24 downto 0);
				PP11 		: out std_logic_vector (24 downto 0);
				PP12 		: out std_logic_vector (23 downto 0));
	end component;

signal A 			: std_logic_vector (23 downto 0) := X"FFFFFF";
signal S 			: std_logic_vector (11 downto 0) := X"000";
signal S_neg 		: std_logic_vector (11 downto 0);
signal Shift 		: std_logic_vector (11 downto 0) := X"001";
signal Shift_neg 	: std_logic_vector (11 downto 0);
signal Zero 		: std_logic_vector (12 downto 0) := '0' & X"000";
signal PP0 			: std_logic_vector (24 downto 0);
signal PP1 			: std_logic_vector (24 downto 0);
signal PP2 			: std_logic_vector (24 downto 0);
signal PP3 			: std_logic_vector (24 downto 0);
signal PP4 			: std_logic_vector (24 downto 0);
signal PP5 			: std_logic_vector (24 downto 0);
signal PP6 			: std_logic_vector (24 downto 0);
signal PP7			: std_logic_vector (24 downto 0);
signal PP8 			: std_logic_vector (24 downto 0);
signal PP9 			: std_logic_vector (24 downto 0);
signal PP10 		: std_logic_vector (24 downto 0);
signal PP11 		: std_logic_vector (24 downto 0);
signal PP12 		: std_logic_vector (23 downto 0);

begin	
	
	--S_gen: process
	--begin
	--	wait for 2.5 ns;
	--	S <= S(10 downto 0) & '0';		-- sll
	--	wait for 2.5 ns;
	--end process S_gen;
	
	Shift_gen: process
	begin
		wait for 2.5 ns;
		Shift <= Shift(10 downto 0) & '0';		-- sll
		wait for 2.5 ns;
	end process Shift_gen;
	
	S_neg 		<= not S;
	Shift_neg 	<= not Shift;
	
	DUT : PP_Selector port map (A, S, S_neg, Shift, Shift_neg, Zero, PP0, PP1, PP2, PP3, PP4, PP5, PP6, PP7, PP8, PP9, PP10, PP11, PP12);

end architecture;

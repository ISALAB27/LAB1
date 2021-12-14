library ieee;
use ieee.std_logic_1164.all;
 
entity PP_gen is
	port(	A 		: in std_logic_vector(23 downto 0);
			X 		: in std_logic_vector(23 downto 0);
			S 		: out std_logic_vector(11 downto 0);
			S_neg 	: out std_logic_vector(11 downto 0);
			PP0 	: out std_logic_vector(24 downto 0);
			PP1 	: out std_logic_vector(24 downto 0);
			PP2 	: out std_logic_vector(24 downto 0);
			PP3 	: out std_logic_vector(24 downto 0);
			PP4 	: out std_logic_vector(24 downto 0);
			PP5 	: out std_logic_vector(24 downto 0);
			PP6 	: out std_logic_vector(24 downto 0);
			PP7		: out std_logic_vector(24 downto 0);
			PP8 	: out std_logic_vector(24 downto 0);
			PP9 	: out std_logic_vector(24 downto 0);
			PP10 	: out std_logic_vector(24 downto 0);
			PP11 	: out std_logic_vector(24 downto 0);
			PP12 	: out std_logic_vector(23 downto 0));
end entity;
 
architecture beh of PP_gen is
	component BRU
		port(	X			: in std_logic_vector(2 downto 0);    
				S 			: out std_logic;
				S_neg 		: out std_logic;
				Shift 		: out std_logic;
				Shift_neg 	: out std_logic;
				Zero 		: out std_logic);
	end component;

	component PP_Selector is
	port(	A 			: in std_logic_vector(23 downto 0);
			S 			: in std_logic_vector(11 downto 0);
			S_neg 		: in std_logic_vector(11 downto 0);
			Shift 		: in std_logic_vector(11 downto 0);
			Shift_neg 	: in std_logic_vector(11 downto 0);
			Zero 		: in std_logic_vector(12 downto 0);
			PP0 		: out std_logic_vector(24 downto 0);
			PP1 		: out std_logic_vector(24 downto 0);
			PP2 		: out std_logic_vector(24 downto 0);
			PP3 		: out std_logic_vector(24 downto 0);
			PP4 		: out std_logic_vector(24 downto 0);
			PP5 		: out std_logic_vector(24 downto 0);
			PP6 		: out std_logic_vector(24 downto 0);
			PP7			: out std_logic_vector(24 downto 0);
			PP8 		: out std_logic_vector(24 downto 0);
			PP9 		: out std_logic_vector(24 downto 0);
			PP10 		: out std_logic_vector(24 downto 0);
			PP11 		: out std_logic_vector(24 downto 0);
			PP12 		: out std_logic_vector(23 downto 0));
	end component;

signal S_sig, S_neg_sig				: std_logic_vector(11 downto 0);
signal Shift_sig, Shift_neg_sig		: std_logic_vector(11 downto 0);
signal Zero_sig						: std_logic_vector(12 downto 0);
signal PP0_sig, PP1_sig, PP2_sig, PP3_sig, PP4_sig, PP5_sig, PP6_sig, PP7_sig, PP8_sig, PP9_Sig, PP10_sig, PP11_sig : std_logic_vector(24 downto 0);
signal PP12_sig 					: std_logic_vector(23 downto 0); 

begin
	
	-- BRU LSB
	S_sig(0) 			<= X(1);
	S_neg_sig(0) 		<= not X(1);
	Shift_sig(0) 		<= not X(0);
	Shift_neg_sig(0) 	<= X(0);
	Zero_sig(0)			<= X(1) nor X(0);
	-- BRU
	GEN_BRU: for I in 1 to 11 generate
		BRUX : BRU port map (X => X((2*I)+1 downto (2*I)-1), S => S_sig(I), S_neg => S_neg_sig(I), Shift => Shift_sig(I), Shift_neg => Shift_neg_sig(I), Zero => Zero_sig(I));
	end generate GEN_BRU;
	-- BRU MSB
	Zero_sig(12) <= not X(23);
	
	PP_Sel: PP_Selector port map(	A => A, S => S_sig, S_neg => S_neg_sig, Shift => Shift_sig, Shift_neg => Shift_neg_sig, 
									Zero => Zero_sig, PP0 => PP0_sig, PP1 => PP1_sig, PP2 => PP2_sig, PP3 => PP3_sig, PP4 => PP4_sig,
									PP5 => PP5_sig, PP6 => PP6_sig, PP7 => PP7_sig, PP8 => PP8_sig, PP9 => PP9_sig, PP10 => PP10_sig,
									PP11 => PP11_sig, PP12 => PP12_sig);
	
	S 		<= S_sig;
	S_neg 	<= S_neg_sig;	
	PP0  	<= PP0_sig;
	PP1  	<= PP1_sig;
	PP2  	<= PP2_sig;
	PP3  	<= PP3_sig;
	PP4  	<= PP4_sig;
	PP5  	<= PP5_sig;
	PP6  	<= PP6_sig;
	PP7  	<= PP7_sig;
	PP8  	<= PP8_sig;
	PP9  	<= PP9_sig;
	PP10 	<= PP10_sig;
	PP11 	<= PP11_sig;
	PP12 	<= PP12_sig;
	
end architecture;

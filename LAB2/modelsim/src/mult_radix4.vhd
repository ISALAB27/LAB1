library ieee;
use ieee.std_logic_1164.all;
 
entity mult_radix4 is
	port(	A 		: in std_logic_vector(23 downto 0);
			B 		: in std_logic_vector(23 downto 0);
			P 		: out std_logic_vector(47 downto 0));
end entity;
 
architecture beh of mult_radix4 is
	component PP_gen is
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
				PP12	: out std_logic_vector(23 downto 0));
	end component;

	component dadda_tree is
		port(	S, S_neg	: in std_logic_vector(11 downto 0);
				PP0			: in std_logic_vector(24 downto 0);
				PP1			: in std_logic_vector(24 downto 0);
				PP2			: in std_logic_vector(24 downto 0);
				PP3			: in std_logic_vector(24 downto 0);
				PP4			: in std_logic_vector(24 downto 0);
				PP5			: in std_logic_vector(24 downto 0);
				PP6			: in std_logic_vector(24 downto 0);
				PP7			: in std_logic_vector(24 downto 0);
				PP8			: in std_logic_vector(24 downto 0);
				PP9			: in std_logic_vector(24 downto 0);
				PP10		: in std_logic_vector(24 downto 0);
				PP11		: in std_logic_vector(24 downto 0);
				PP12		: in std_logic_vector(23 downto 0);
				P 			: out std_logic_vector(47 downto 0));
	end component;	

signal S_sig, S_neg_sig						: std_logic_vector(11 downto 0);
signal PP0_sig, PP1_sig, PP2_sig, PP3_sig, PP4_sig, PP5_sig, PP6_sig, PP7_sig, PP8_sig, PP9_Sig, PP10_sig, PP11_sig : std_logic_vector(24 downto 0);
signal PP12_sig 							: std_logic_vector(23 downto 0);  
signal P_sig 								: std_logic_vector(47 downto 0);

begin

	PP : PP_gen port map(	A => A, X => B, S => S_sig, S_neg => S_neg_sig, PP0 => PP0_sig, PP1 => PP1_sig, PP2 => PP2_sig, 
							PP3 => PP3_sig, PP4 => PP4_sig, PP5 => PP5_sig, PP6 => PP6_sig, PP7 => PP7_sig, PP8 => PP8_sig,
							PP9 => PP9_sig, PP10 => PP10_sig, PP11 => PP11_sig, PP12 => PP12_sig);
	
	tree : dadda_tree port map(	S => S_sig, S_neg => S_neg_sig, PP0 => PP0_sig, PP1 => PP1_sig, PP2 => PP2_sig, PP3 => PP3_sig,
								PP4 => PP4_sig, PP5 => PP5_sig, PP6 => PP6_sig, PP7 => PP7_sig, PP8 => PP8_sig, PP9 => PP9_sig,
								PP10 => PP10_sig, PP11 => PP11_sig, PP12 => PP12_sig, P => P_sig);
								
	P <= P_sig;
	
end architecture;
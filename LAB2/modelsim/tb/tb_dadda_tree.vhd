Library ieee;
use ieee.std_logic_1164.all;

entity tb_dadda_tree is
end tb_dadda_tree; 

architecture beh of tb_dadda_tree is

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

signal S, S_neg	: std_logic_vector(11 downto 0);
signal PP0		: std_logic_vector(24 downto 0);
signal PP1		: std_logic_vector(24 downto 0);
signal PP2		: std_logic_vector(24 downto 0);
signal PP3		: std_logic_vector(24 downto 0);
signal PP4		: std_logic_vector(24 downto 0);
signal PP5		: std_logic_vector(24 downto 0);
signal PP6		: std_logic_vector(24 downto 0);
signal PP7		: std_logic_vector(24 downto 0);
signal PP8		: std_logic_vector(24 downto 0);
signal PP9		: std_logic_vector(24 downto 0);
signal PP10		: std_logic_vector(24 downto 0);
signal PP11		: std_logic_vector(24 downto 0);
signal PP12		: std_logic_vector(23 downto 0);
signal P 		: std_logic_vector(47 downto 0);

begin

	S	 	<= "000000000000";
	S_neg 	<= not S;
	PP0  	<= '1' & X"ffffff";
	PP1  	<= '1' & X"ffffff";
	PP2  	<= '0' & X"000000";
	PP3  	<= '1' & X"ffffff";
	PP4  	<= '0' & X"000000";
	PP5  	<= '0' & X"000000";
	PP6  	<= '0' & X"000000";
	PP7  	<= '0' & X"000000";
	PP8  	<= '0' & X"000000";
	PP9  	<= '0' & X"000000";
	PP10 	<= '0' & X"000000";
	PP11 	<= '0' & X"000000";
	PP12 	<= X"000000";
	
	DUT : dadda_tree port map (	S => S, S_neg => S_neg, PP0 => PP0, PP1 => PP1, PP2 => PP2, PP3 => PP3, PP4 => PP4,
								PP5 => PP5, PP6 => PP6, PP7 => PP7, PP8 => PP8, PP9 => PP9, PP10 => PP10, PP11 => PP11, PP12 => PP12, P => P);

end architecture; 

library ieee;
use ieee.std_logic_1164.all;
 
entity BRU is
	port(	X			: in std_logic_vector(2 downto 0);    
			S 			: out std_logic;
			S_neg 		: out std_logic;
			Shift 		: out std_logic;
			Shift_neg 	: out std_logic;
			Zero 		: out std_logic);
end entity;
 
architecture beh of BRU is

signal S_sig, S_neg_sig, Shift_neg_sig : std_logic; 

begin
	S_neg_sig 		<= X(2) nand (X(1) nand X(0));
	S_sig 			<= not S_neg_sig;
	Shift_neg_sig 	<= X(1) xor X(0);
	
	S			<= S_sig;
	S_neg		<= S_neg_sig;
	Shift 		<= not Shift_neg_sig;
	Shift_neg	<= Shift_neg_sig;
	Zero		<= S_sig nor (X(2) nor (X(1) nor X(0)));
end architecture;

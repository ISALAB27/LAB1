library ieee;
use ieee.std_logic_1164.all;
 
entity full_subtractor is
	port(	x		: in std_logic;    
			y 		: in std_logic;
			b_in 	: in std_logic;
			sub 	: out std_logic;
			b_out 	: out std_logic);
end entity;
 
architecture struct of full_subtractor is	

signal out_nand_1, out_nand_2, out_nand_3, out_nand_4, in_mux : std_logic; 
signal out_nand_5, out_nand_6	: std_logic;
signal Xn						: std_logic;

begin
	Xn <= not X;

	out_nand_1 	<= (Xn NAND Y);
	out_nand_2 	<= (Xn NAND (not Y));
	out_nand_3 	<= (X NAND Y);
	out_nand_4 	<= (out_nand_2 NAND out_nand_3);
	out_nand_5 	<= out_nand_4 NAND b_in;
	out_nand_6 	<= (not out_nand_4) NAND (not b_in);
	b_out 		<= out_nand_1 NAND out_nand_5;
	sub 		<= out_nand_5 NAND out_nand_6;

end architecture;
library ieee;
use ieee.std_logic_1164.all;

entity ALU_Control is
	port (	bit30	: in std_logic;
			F3		: in std_logic_vector(2 downto 0);
			ALUop	: in std_logic_vector(1 downto 0);
			ALUctrl	: out std_logic_vector(2 downto 0));
end entity;

architecture beh of ALU_Control is
begin

	ALUctrl <= 	"100" when (bit30 = '0' and F3 = "000" and ALUop = "11") else	-- ADD
				"001" when (bit30 = '0' and F3 = "010" and ALUop = "11") else	-- SLT
				"010" when (bit30 = '0' and F3 = "100" and ALUop = "11") else	-- XOR
				"100" when (F3 = "010" and ALUop = "00") 				 else	-- SW/LW	
				"101" when (F3 = "000" and ALUop = "01") 				 else	-- BEQ	
				"100" when (F3 = "000" and ALUop = "00") 				 else	-- ADDI	
				"011" when (F3 = "111" and ALUop = "00") 				 else	-- ANDI	
				"000" when (bit30 = '1' and F3 = "101" and ALUop = "00") else	-- SRAI	
				"100" when (ALUop = "10") 								 else	-- AUIPC/LUI/JAL
				"100";															-- ADD by default
	
end architecture;

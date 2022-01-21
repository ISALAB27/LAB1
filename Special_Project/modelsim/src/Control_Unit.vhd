library ieee;
use ieee.std_logic_1164.all;

entity Control_Unit is
	port (	OPCODE		: in std_logic_vector (6 downto 0);
			Jump		: out std_logic;
			Branch		: out std_logic;
			MemRead		: out std_logic;
			MemWrite	: out std_logic;
			ALUsrc		: out std_logic_vector (1 downto 0);
			RegWrite	: out std_logic;
			ALUop		: out std_logic_vector (1 downto 0);
			ALU_SPC		: out std_logic);
end entity;

architecture beh of Control_Unit is
begin

	process (OPCODE)
	begin
		
		Jump			<= '0';
		Branch 			<= '0';
		MemRead		 	<= '0';
		MemWrite	 	<= '0';
		ALUsrc 			<= "00";
		RegWrite 		<= '0';
		ALUop 			<= "00";
		ALU_SPC			<= '0';
		
		case OPCODE is 
			when "0110011" =>					-- ADD/SLT/XOR
				RegWrite 		<= '1';
				ALUop 			<= "11";
				
			when "0100011" =>					-- SW
				MemWrite	 	<= '1';
				ALUsrc 			<= "01";
			
			when "1100011" =>					-- BEQ
				Branch 			<= '1';
				ALUop 			<= "01";
			
			when "0000011" =>					-- LW
				ALUsrc 			<= "01";
				MemRead			<= '1';
				RegWrite 		<= '1';
				
			when "0010011" =>					-- ADDI/ANDI/SRAI
				ALUsrc 			<= "01";
				RegWrite 		<= '1';
			
			when "0010111" =>					-- AUIPC
				ALUsrc 			<= "10";
				RegWrite 		<= '1';
				ALUop 			<= "10";
			
			when "0110111" =>					-- LUI
				ALUsrc 			<= "01";
				RegWrite 		<= '1';
				ALUop 			<= "10";
	
			when "1101111" =>					-- JAL
				Jump 			<= '1';
				ALUsrc 			<= "11";
				RegWrite 		<= '1';
				ALUop 			<= "10";
				
			when "1010101" =>					-- SQRT/SQRT_RES
				RegWrite 		<= '1';
				ALU_SPC			<= '1';
							
			when others =>
							
		end case;
	end process;
	
end architecture;

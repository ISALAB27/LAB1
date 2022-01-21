library ieee;
use ieee.std_logic_1164.all;

entity stage2 is
	port(	instruction 	: in std_logic_vector (31 downto 0);
			PC_in			: in std_logic_vector (31 downto 0);
			write_reg		: in std_logic;  						--write_enable
			write_data		: in std_logic_vector (31 downto 0);
			reg_write		: in std_logic_vector (4 downto 0); 	--write address
			rst				: in std_logic;
			clk				: in std_logic;
			Stall			: out std_logic;
			Jump 			: out std_logic;
			Branch 			: out std_logic; 
			MemRead 		: out std_logic; 
			MemWrite 		: out std_logic;
			ALUsrc 			: out std_logic_vector (1 downto 0);
			ALU_SPC			: out std_logic;
			RegWrite 		: out std_logic;
			ALUop 			: out std_logic_vector (1 downto 0);
			PC_out		  	: out std_logic_vector (31 downto 0);
			read_data1		: out std_logic_vector (31 downto 0);
			read_data2		: out std_logic_vector (31 downto 0);
			IMM_output		: out std_logic_vector (31 downto 0);
			f3				: out std_logic_vector (2 downto 0);
			inst_30			: out std_logic;
			rs1				: out std_logic_vector (4 downto 0);
			rs2				: out std_logic_vector (4 downto 0);
			rd				: out std_logic_vector (4 downto 0));
end entity;

architecture beh of stage2 is

	component Control_Unit is
		port(	OPCODE		: in std_logic_vector (6 downto 0);
				Jump		: out std_logic;
				Branch		: out std_logic;
				MemRead		: out std_logic;
				MemWrite	: out std_logic;
				ALUsrc		: out std_logic_vector (1 downto 0);
				RegWrite	: out std_logic;
				ALUop		: out std_logic_vector (1 downto 0);
				ALU_SPC		: out std_logic);
	end component;

	component IMM_Gen is
		port (	IMM_in		: in	std_logic_vector(31 downto 0);
				IMM_output	: out std_logic_vector(31 downto 0));
	end component;

	component register_file is
		port(	read_reg1 	: in std_logic_vector (4 downto 0);
				read_reg2 	: in std_logic_vector (4 downto 0);
				write_reg 	: in std_logic;  							--write_enable
				write_data	: in std_logic_vector (31 downto 0);
				reg_write 	: in std_logic_vector (4 downto 0); 		--write address
				rst			: in std_logic;
				clk			: in std_logic;
				read_data1	: out std_logic_vector (31 downto 0);
				read_data2	: out std_logic_vector (31 downto 0));
	end component;
	
	component regN is
		generic(N				: integer);
		port(	load, clk, rst 	: in std_logic;
				pin 			: in std_logic_vector(N-1 downto 0);
				pout 			: out std_logic_vector(N-1 downto 0));
	end component;
	
	component ff_D
		port(	D, CLK, RST		: in std_logic;
				Q 				: out std_logic);
	end component;
	
signal WB		: std_logic;
signal M		: std_logic_vector(3 downto 0);
signal EX		: std_logic_vector(4 downto 0);
signal imm_out 	: std_logic_vector(31 downto 0);

begin

	registers : register_file port map (
		read_reg1 		=> instruction(19 downto 15),
		read_reg2 		=> instruction(24 downto 20),
		write_reg		=> write_reg,
		write_data 		=> write_data,
		reg_write		=> reg_write,
		rst				=> rst,
		clk				=> clk,
		read_data1 		=> read_data1,
		read_data2 		=> read_data2 
	);

	CU : Control_Unit port map (
		OPCODE 		=> instruction(6 downto 0), 
		Jump		=> M(3),
		Branch 		=> M(2), 
		MemRead 	=> M(1), 
		MemWrite 	=> M(0), 
		ALUsrc 		=> EX(3 downto 2), 
		RegWrite 	=> WB, 
		ALUop 		=> EX(1 downto 0),
		ALU_SPC		=> EX(4)
	);
	
	immgen : IMM_Gen port map (
		IMM_in 		=> instruction, 
		IMM_output 	=> imm_out
	);

	PC_reg : regN generic map (N => 32) port map (
		load 	=> '1', 
		clk		=> clk, 
		rst 	=> rst,		
		pin 	=> PC_in,				
		pout 	=> PC_out	
	);
	
	f3_reg : regN generic map (N => 3) port map (
		load 	=> '1', 
		clk		=> clk, 
		rst 	=> rst,		
		pin 	=> instruction(14 downto 12),				
		pout 	=> f3	
	);
	
	ff_30 : ff_D port map (
		D 	=> instruction(30), 
		CLK => clk, 
		RST	=> rst,
		Q 	=> inst_30	
	);
	
	rs1_reg : regN generic map (N => 5) port map (
		load 	=> '1', 
		clk		=> clk, 
		rst 	=> rst,		
		pin 	=> instruction(19 downto 15),				
		pout 	=> rs1	
	);
	
	rs2_reg : regN generic map (N => 5) port map (
		load 	=> '1', 
		clk		=> clk, 
		rst 	=> rst,		
		pin 	=> instruction(24 downto 20),				
		pout 	=> rs2
	);
	
	rd_reg : regN generic map (N => 5) port map (
		load 	=> '1', 
		clk		=> clk, 
		rst 	=> rst,		
		pin 	=> instruction(11 downto 7),				
		pout 	=> rd	
	);
	
	WB_reg : ff_D port map (
		D 	=> WB, 
		CLK => clk, 
		RST	=> rst,
		Q 	=> RegWrite	
	);
	
	M_reg : regN generic map (N => 4) port map (
		load 	=> '1', 
		clk		=> clk, 
		rst 	=> rst,		
		pin 	=> M,
		pout(3) => Jump,
		pout(2) => Branch, 
		pout(1) => MemRead, 
		pout(0) => MemWrite				
	);
	
	EX_reg : regN generic map (N => 5) port map (
		load 			 	=> '1', 
		clk				 	=> clk, 
		rst 			 	=> rst,		
		pin 				=> EX,	
		pout(4) 			=> ALU_SPC,
		pout(3 downto 2) 	=> ALUsrc,
		pout(1 downto 0) 	=> ALUop			
	);
	
	imm_reg : regN generic map (N => 32) port map (
		load 	=> '1', 
		clk		=> clk, 
		rst 	=> rst,		
		pin 	=> imm_out,				
		pout 	=> IMM_output	
	);
	
	Stall <= M(3) or M(2);		-- Jump or Branch
	
end architecture;
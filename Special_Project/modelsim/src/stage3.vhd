library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage3 is
	port (	RegWrite_in 	: in std_logic;
			Jump_in	 		: in std_logic;
			Branch_in 		: in std_logic;
			MemRead_in 		: in std_logic; 
			MemWrite_in 	: in std_logic;
			Aluop 			: in std_logic_vector (1 downto 0);
			Alusrc 			: in std_logic_vector (1 downto 0);
			ALU_SPC			: in std_logic;
			PC 				: in std_logic_vector (31 downto 0);
			Read_data1 		: in std_logic_vector (31 downto 0);
			Read_data2_in 	: in std_logic_vector (31 downto 0);			
			IMM_out 		: in std_logic_vector (31 downto 0);
			bit30 			: in std_logic;
			F3 				: in std_logic_vector (2 downto 0);
			Rd_in 			: in std_logic_vector (4 downto 0);
			fu_mux1_sel		: in std_logic_vector (1 downto 0);
			fu_mux2_sel		: in std_logic_vector (1 downto 0);
			ALURes_MEM		: in std_logic_vector (31 downto 0);
			ALURes_WB		: in std_logic_vector (31 downto 0);	
			rst				: in std_logic;
			clk				: in std_logic;
			Stall		 	: out std_logic;
			RegWrite_out 	: out std_logic;
			Jump_out	 	: out std_logic;
			Branch_out 		: out std_logic;
			MemRead_out 	: out std_logic; 
			MemWrite_out	: out std_logic;
			AddSum 			: out std_logic_vector (31 downto 0);
			Zero 			: out std_logic;
			Alu_result 		: out std_logic_vector (31 downto 0);
			Read_data2_out 	: out std_logic_vector (31 downto 0);
			Rd_out 			: out std_logic_vector (4 downto 0));
end entity;


architecture beh of stage3 is

	component ALU
		port(	a 		: in std_logic_vector(31 downto 0);
				b 		: in std_logic_vector(31 downto 0);
				ctrl	: in std_logic_vector(2 downto 0);
				zero	: out std_logic;
				res		: out std_logic_vector(31 downto 0));
	end component;

	component Alu_Control
		port (	bit30	:	in	std_logic;
				F3		:	in	std_logic_vector(2 downto 0);
				ALUop	:	in	std_logic_vector(1 downto 0);
				ALUctrl	:	out std_logic_vector(2 downto 0));
	end component;
	
	component Special_Unit is
		port (	x		: in std_logic_vector(31 downto 0);
				ctrl	: in std_logic;
				res		: out std_logic_vector(31 downto 0));
	end component;
	
	component SPC_Control is
		port (	F3		: in std_logic_vector(2 downto 0);
				SPCctrl	: out std_logic);
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
	
	component mux3to1 is
		generic(N 		: integer);
		port(	A, B, C	: in std_logic_vector(N-1 downto 0);
				S		: in std_logic_vector(1 downto 0);
				Y		: out std_logic_vector(N-1 downto 0));
	end component;
	
	component mux2to1 is
		generic(N 		: integer);
		port(	A, B	: in std_logic_vector(N-1 downto 0);
				S		: in std_logic;
				Y		: out std_logic_vector(N-1 downto 0));
	end component;

signal ctrlALU 			: std_logic_vector (2 downto 0);
signal Alu_result_sig 	: std_logic_vector (31 downto 0);
signal Zero_sig 		: std_logic;
signal mux1_out 		: std_logic_vector (31 downto 0);
signal mux2_out 		: std_logic_vector (31 downto 0);
signal imm_x2 			: std_logic_vector (31 downto 0);

signal ctrlSPC 			: std_logic;
signal SPC_res_sig 		: std_logic_vector (31 downto 0);

signal ALU_SPC_mux_out	: std_logic_vector (31 downto 0);

signal AddSum_sig 		: std_logic_vector (31 downto 0);

-- forwarding unit mux signals
signal fu_mux1_out, fu_mux2_out	: std_logic_vector(31 downto 0);

begin
	
	fu_mux1 : mux3to1 generic map (N => 32) port map (
		A	=> Read_data1,
		B 	=> ALURes_MEM,
		C	=> ALURes_WB,
		S 	=> fu_mux1_sel,
		Y	=> fu_mux1_out
	);
	
	fu_mux2 : mux3to1 generic map (N => 32) port map (
		A	=> Read_data2_in,
		B 	=> ALURes_MEM,
		C	=> ALURes_WB,
		S 	=> fu_mux2_sel,
		Y	=> fu_mux2_out
	);
	
	mux1_out <= fu_mux1_out when ALUsrc(1) = '0' else PC;
	
	mux2_out <= fu_mux2_out 	when ALUsrc = "00" else
				x"00000004" 	when ALUsrc = "11" else
				IMM_out;
				
	Stall <= Jump_in or Branch_in;
	
	imm_x2 <= IMM_out(30 downto 0) & '0';
	
	AddSum_sig <= std_logic_vector(unsigned(PC) + unsigned(imm_x2));
	
	AddSum_regN : regN generic map (N => 32) port map (
		load 	=> '1',
		clk 	=> clk,
		rst 	=> rst,
		pin 	=> AddSum_sig,
		pout 	=> AddSum
	);
	
	ALU_CTRL_instance : Alu_Control port map (
		bit30 	=> bit30,
		F3 		=> F3,
		ALUop 	=> ALUop,
		ALUctrl => ctrlALU
	);
	
	ALU_instance : ALU port map (
		a 		=> mux1_out,
		b 		=> mux2_out,
		ctrl 	=> ctrlALU,
		zero 	=> Zero_sig,
		res 	=> Alu_result_sig
	);

	SPC_Control_instance : SPC_Control port map (
		F3 		=> F3,
		SPCctrl => ctrlSPC
	);
	
	Special_Unit_instance : Special_Unit port map (
		x 		=> mux1_out,
		ctrl 	=> ctrlSPC,
		res 	=> SPC_res_sig
	);
	
	ALU_SPC_mux : mux2to1 generic map (N => 32) port map (
		A	=> Alu_result_sig,
		B 	=> SPC_res_sig,
		S 	=> ALU_SPC,
		Y	=> ALU_SPC_mux_out
	);
	
	Alu_result_regN : regN generic map (N => 32) port map (
		load 	=> '1', 
		clk 	=> clk, 
		rst 	=> rst, 
		pin 	=> ALU_SPC_mux_out, 
		pout 	=> Alu_result
	);
	
	Zero_ffD : ff_D port map (
		D 		=> Zero_sig, 
		CLK		=> clk, 
		RST 	=> rst, 
		Q		=> Zero
	);

	RegWrite_out_ffD : ff_D port map (
		D 		=> RegWrite_in,
		CLK		=> clk,
		RST 	=> rst,
		Q		=> RegWrite_out
	);
	
	Jump_out_ffD : ff_D port map (
		D 		=> Jump_in, 
		CLK		=> clk,
		RST 	=> rst, 
		Q		=> Jump_out
	);
	
	Branch_out_ffD : ff_D port map (
		D 		=> Branch_in, 
		CLK		=> clk, 
		RST 	=> rst, 
		Q		=> Branch_out
	);
	
	MemRead_out_ffD : ff_D port map (
		D 		=> MemRead_in , 
		CLK		=> clk, 
		RST 	=> rst, 
		Q		=> MemRead_out
	);
	
	MemWrite_out_ffD : ff_D port map (
		D 		=> MemWrite_in,
		CLK		=> clk, 
		RST 	=> rst, 
		Q		=> MemWrite_out
	);
	
	Read_data2_out_regN : regN generic map (N => 32) port map (
		load 	=> '1', 
		clk 	=> clk, 
		rst 	=> rst, 
		pin 	=> fu_mux2_out, 
		pout 	=> Read_data2_out
	);
	
	Rd_out_regN: regN generic map (N => 5) port map (
		load 	=> '1',
		clk 	=> clk,
		rst 	=> rst,
		pin 	=> Rd_in,
		pout 	=> Rd_out
	);

end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity RISC_V_lite is
	port(	inst_read 		: in std_logic_vector(31 downto 0);
			data_read 		: in std_logic_vector(31 downto 0);
			rst, clk		: in std_logic;
			inst_add		: out std_logic_vector(31 downto 0);
			data_add		: out std_logic_vector(31 downto 0);
			data_MemRead	: out std_logic;
			data_MemWrite	: out std_logic;
			data_write		: out std_logic_vector(31 downto 0));
end entity;

architecture behaviour of RISC_V_lite is
	
	component stage1 is
		port(	PCSrc				: in std_logic;
				branch_add			: in std_logic_vector (31 downto 0);
				inst_mem_read_in	: in std_logic_vector (31 downto 0);
				PC_in				: in std_logic_vector (31 downto 0);
				Stall_ID			: in std_logic;
				Stall_EX			: in std_logic;
				Stall_MEM			: in std_logic;
				rst					: in std_logic;
				clk					: in std_logic;
				out_mux				: out std_logic_vector (31 downto 0);
				PC_out				: out std_logic_vector (31 downto 0);
				inst_mem_add_out	: out std_logic_vector (31 downto 0);
				inst_mem_read_out	: out std_logic_vector (31 downto 0));
	end component;
	
	component stage2 is
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
	end component;
	
	component stage3 is
		port(	RegWrite_in 	: in std_logic;
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
				MemRead_out		: out std_logic; 
				MemWrite_out 	: out std_logic;
				AddSum 			: out std_logic_vector (31 downto 0);
				Zero 			: out std_logic;
				Alu_result 		: out std_logic_vector (31 downto 0);
				Read_data2_out 	: out std_logic_vector (31 downto 0);
				Rd_out 			: out std_logic_vector (4 downto 0));
	end component;
	
	component stage4 is
		port(	RegWrite_in 	: in std_logic;
				Jump	 		: in std_logic;
				Branch_in 		: in std_logic;
				Zero 			: in std_logic;
				MemRead_in 		: in std_logic;
				MemWrite_in		: in std_logic;
				Address_in 		: in std_logic_vector (31 downto 0);
				WriteData_in	: in std_logic_vector (31 downto 0);
				Rd_in 			: in std_logic_vector (4 downto 0);
				ReadData_in 	: in std_logic_vector (31 downto 0);
				rst				: in std_logic;
				clk				: in std_logic;
				Stall		 	: out std_logic;
				RegWrite_out 	: out std_logic;
				Branch_out 		: out std_logic;
				MemRead_out 	: out std_logic;
				MemWrite_out	: out std_logic;
				ALURes_MEM	 	: out std_logic_vector (31 downto 0);
				ReadData_out 	: out std_logic_vector (31 downto 0);
				Address_out 	: out std_logic_vector (31 downto 0);
				MemAddress_out 	: out std_logic_vector (31 downto 0);
				WriteData_out 	: out std_logic_vector (31 downto 0);
				Rd_out 			: out std_logic_vector (4 downto 0);
				MemToReg 		: out std_logic);
	end component;
	
	component stage5 is
		port(	ReadData 		: in std_logic_vector(31 downto 0);
				Address			: in std_logic_vector(31 downto 0);
				MemToReg		: in std_logic;
				RegWrite_in		: in std_logic;
				Rd_in			: in std_logic_vector(4 downto 0);
				RegWrite_out	: out std_logic;
				WriteRegister	: out std_logic_vector(4 downto 0);
				WriteData		: out std_logic_vector(31 downto 0));
	end component;
	
	component Forwarding_Unit is
		port (	Rs1				: in std_logic_vector(4 downto 0);
				Rs2				: in std_logic_vector(4 downto 0);
				Rd_MEM			: in std_logic_vector(4 downto 0);
				Rd_WB			: in std_logic_vector(4 downto 0);
				RegWrite_MEM	: in std_logic;
				RegWrite_WB		: in std_logic;
				Forward1		: out std_logic_vector(1 downto 0);
				Forward2		: out std_logic_vector(1 downto 0));
	end component;
	
-- stage1 signals
signal s1_out_mux, s1_PC_in, s1_PC_out, s1_inst_mem_read_out : std_logic_vector (31 downto 0);

-- stage2 signals
signal s2_PC_out, s2_IMM_output 	: std_logic_vector (31 downto 0);
signal s2_Stall, s2_Jump, s2_Branch, s2_MemRead, s2_MemWrite, s2_ALU_SPC, s2_RegWrite, s2_inst_30 : std_logic; 
signal s2_ALUsrc, s2_ALUop 			: std_logic_vector (1 downto 0);
signal s2_read_data1, s2_read_data2 : std_logic_vector (31 downto 0);
signal s2_f3 						: std_logic_vector (2 downto 0);
signal s2_rs1, s2_rs2, s2_rd 		: std_logic_vector (4 downto 0);

-- stage3 signals
signal s3_Stall, s3_RegWrite_out, s3_Jump_out, s3_Branch_out, s3_MemRead_out, s3_MemWrite_out, s3_Zero : std_logic;
signal s3_AddSum 						: std_logic_vector (31 downto 0);
signal s3_Alu_result, s3_Read_data2_out : std_logic_vector (31 downto 0);
signal s3_Rd_out 						: std_logic_vector (4 downto 0);

-- stage4 signals
signal s4_Stall, s4_RegWrite_out, s4_Branch_out, s4_MemToReg 	: std_logic;
signal s4_ReadData_out, s4_Address_out, s4_ALURes_MEM 			: std_logic_vector (31 downto 0);
signal s4_Rd_out 			: std_logic_vector (4 downto 0);

-- stage5 signals
signal s5_RegWrite_out 	: std_logic;
signal s5_WriteRegister : std_logic_vector(4 downto 0);
signal s5_WriteData		: std_logic_vector(31 downto 0);

-- forwarding unit signals
signal fu_mux1_sel, fu_mux2_sel	: std_logic_vector(1 downto 0);
	
begin
	
	PC : process(clk, rst)
	begin
		if rst = '0' then
			s1_PC_in <= x"00400000"; 
		elsif (clk'event and clk = '1') then
			s1_PC_in <= s1_out_mux;
		end if;
	end process PC;
	
	S1 : stage1 port map (	
		PCSrc				=> s4_Branch_out, 
		branch_add			=> s3_AddSum, 
		inst_mem_read_in 	=> inst_read, 
		PC_in 				=> s1_PC_in,
		Stall_ID			=> s2_Stall,
		Stall_EX			=> s3_Stall,
		Stall_MEM			=> s4_Stall,
		rst					=> rst,
		clk					=> clk,
		out_mux 			=> s1_out_mux, 
		PC_out 				=> s1_PC_out, 
		inst_mem_add_out	=> inst_add,
		inst_mem_read_out 	=> s1_inst_mem_read_out
	);
	
	S2 : stage2 port map (	
		instruction 	=> s1_inst_mem_read_out, 
		PC_in			=> s1_PC_out, 
		write_reg		=> s5_RegWrite_out,
		write_data		=> s5_WriteData,
		reg_write		=> s5_WriteRegister,
		rst				=> rst,
		clk				=> clk,
		Stall			=> s2_Stall,
		Jump			=> s2_Jump,
		Branch 			=> s2_Branch, 
		MemRead 		=> s2_MemRead,
		MemWrite 		=> s2_MemWrite,
		ALUsrc 			=> s2_ALUsrc,
		ALU_SPC			=> s2_ALU_SPC,
		RegWrite 		=> s2_RegWrite, 
		ALUop 			=> s2_ALUop, 
		PC_out 			=> s2_PC_out, 
		read_data1 		=> s2_read_data1, 
		read_data2 		=> s2_read_data2, 
		IMM_output		=> s2_IMM_output, 
		f3 				=> s2_f3,
		inst_30 		=> s2_inst_30,
		rs1				=> s2_rs1,
		rs2				=> s2_rs2,
		rd 				=> s2_rd
	);
	
	S3 : stage3 port map (
		RegWrite_in 	=> s2_RegWrite,
		Jump_in	 		=> s2_Jump,
		Branch_in 		=> s2_Branch,
		MemRead_in 		=> s2_MemRead,
		MemWrite_in 	=> s2_MemWrite,
		Aluop 			=> s2_ALUop,
		Alusrc 			=> s2_ALUsrc,
		ALU_SPC			=> s2_ALU_SPC,
		PC 				=> s2_PC_out,
		Read_data1 		=> s2_read_data1,
		Read_data2_in 	=> s2_read_data2,			
		IMM_out 		=> s2_IMM_output,
		bit30 			=> s2_inst_30,
		F3 				=> s2_f3,
		Rd_in 			=> s2_rd,
		fu_mux1_sel		=> fu_mux1_sel,
		fu_mux2_sel		=> fu_mux2_sel,
		ALURes_MEM		=> s4_ALURes_MEM,
		ALURes_WB		=> s5_WriteData,
		Stall		 	=> s3_Stall,
		rst				=> rst,
		clk				=> clk,
		RegWrite_out 	=> s3_RegWrite_out,
		Jump_out	 	=> s3_Jump_out,
		Branch_out 		=> s3_Branch_out,
		MemRead_out 	=> s3_MemRead_out,
		MemWrite_out	=> s3_MemWrite_out,
		AddSum 			=> s3_AddSum,
		Zero 			=> s3_Zero,
		Alu_result 		=> s3_Alu_result,
		Read_data2_out 	=> s3_Read_data2_out,
		Rd_out 			=> s3_Rd_out
	);
	
	S4 : stage4 port map (
		RegWrite_in 	=> s3_RegWrite_out,
		Jump	 		=> s3_Jump_out,
		Branch_in 		=> s3_Branch_out,
		Zero 			=> s3_Zero,
		MemRead_in 		=> s3_MemRead_out,
		MemWrite_in		=> s3_MemWrite_out,
		Address_in 		=> s3_Alu_result,
		WriteData_in 	=> s3_Read_data2_out,
		Rd_in 			=> s3_Rd_out,
		ReadData_in 	=> data_read,
		rst				=> rst,
		clk				=> clk,
		Stall		 	=> s4_Stall,
		RegWrite_out 	=> s4_RegWrite_out,
		Branch_out 		=> s4_Branch_out,
		MemRead_out 	=> data_MemRead,
		MemWrite_out	=> data_MemWrite,
		ALURes_MEM	 	=> s4_ALURes_MEM,
		ReadData_out 	=> s4_ReadData_out,
		Address_out 	=> s4_Address_out,
		MemAddress_out 	=> data_add,
		WriteData_out 	=> data_write,
		Rd_out 			=> s4_Rd_out,
		MemToReg 		=> s4_MemToReg
	);
	
	S5 : stage5 port map (
		ReadData 		=> s4_ReadData_out,
		Address			=> s4_Address_out,
		MemToReg		=> s4_MemToReg,
		RegWrite_in		=> s4_RegWrite_out,
		Rd_in			=> s4_Rd_out,
		RegWrite_out	=> s5_RegWrite_out,
		WriteRegister	=> s5_WriteRegister,
		WriteData		=> s5_WriteData
	);
	
	FU : Forwarding_Unit port map (
		Rs1				=> s2_rs1,
		Rs2				=> s2_rs2,
		Rd_MEM			=> s3_Rd_out,
		Rd_WB			=> s4_Rd_out,
		RegWrite_MEM	=> s3_RegWrite_out,
		RegWrite_WB		=> s4_RegWrite_out,
		Forward1		=> fu_mux1_sel,
		Forward2		=> fu_mux2_sel
	);
	
end architecture;
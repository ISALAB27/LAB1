library ieee;
use ieee.std_logic_1164.all;

entity stage4 is
	port (	RegWrite_in 	: in std_logic;
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
end entity;

architecture beh of stage4 is

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

begin

	MemAddress_out	<= Address_in;
	WriteData_out 	<= WriteData_in;
	MemRead_out  	<= MemRead_in;
	MemWrite_out 	<= MemWrite_in;
	
	Stall <= Jump or Branch_in;
	Branch_out <= Jump or (Zero and Branch_in);
	
	ALURes_MEM <= Address_in when MemRead_in = '0' else ReadData_in;
	
	RegWrite_out_ffD : ff_D port map (
		D 		=> RegWrite_in,
		CLK		=> clk,
		RST 	=> rst,
		Q		=> RegWrite_out
	);
	
	MemToReg_ffD : ff_D port map (
		D 		=> MemRead_in, 
		CLK		=> clk, 
		RST 	=> rst, 
		Q		=> MemToReg
	);
	
	ReadData_out_regN : regN generic map (N => 32) port map (
		load 	=> '1',
		clk 	=> clk,
		rst 	=> rst,
		pin 	=> ReadData_in,
		pout 	=> ReadData_out
	);
	
	Address_out_regN : regN generic map (N => 32) port map (
		load 	=> '1',
		clk 	=> clk,
		rst 	=> rst,
		pin 	=> Address_in,
		pout 	=> Address_out
	);
	
	Rd_out_regN : regN generic map (N => 5) port map (
		load 	=> '1', 
		clk 	=> clk, 
		rst		=> rst,
		pin 	=> Rd_in, 
		pout 	=> Rd_out
	);

end architecture;
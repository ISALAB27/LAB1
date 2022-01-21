library ieee;
use ieee.std_logic_1164.all;

entity Forwarding_Unit is
	port (	Rs1				: in std_logic_vector(4 downto 0);
			Rs2				: in std_logic_vector(4 downto 0);
			Rd_MEM			: in std_logic_vector(4 downto 0);
			Rd_WB			: in std_logic_vector(4 downto 0);
			RegWrite_MEM	: in std_logic;
			RegWrite_WB		: in std_logic;
			Forward1		: out std_logic_vector(1 downto 0);
			Forward2		: out std_logic_vector(1 downto 0));
end entity;

architecture beh of Forwarding_Unit is

	component mux4to1 is
		generic(N 			: integer);
		port(	A, B, C, D	: in std_logic_vector(N-1 downto 0);
				S			: in std_logic_vector(1 downto 0);
				Y			: out std_logic_vector(N-1 downto 0));
	end component;
	
	component mux2to1 is
		generic(N 		: integer);
		port(	A, B	: in std_logic_vector(N-1 downto 0);
				S		: in std_logic;
				Y		: out std_logic_vector(N-1 downto 0));
	end component;

signal Rd_WB_eq_Rs1, Rd_MEM_eq_Rs1, Rd_WB_eq_Rs2, Rd_MEM_eq_Rs2 : std_logic;
signal RegWrite_WB_and_RegWrite_MEM 		: std_logic;
signal f1_mux2to1_out, f2_mux2to1_out 		: std_logic_vector(1 downto 0);

begin

	Rd_WB_eq_Rs1 <= '1' when Rd_WB = Rs1 else '0';
	Rd_MEM_eq_Rs1 <= '1' when Rd_MEM = Rs1 else '0';
	
	Rd_WB_eq_Rs2 <= '1' when Rd_WB = Rs2 else '0';
	Rd_MEM_eq_Rs2 <= '1' when Rd_MEM = Rs2 else '0';
	
	RegWrite_WB_and_RegWrite_MEM <= RegWrite_WB and RegWrite_MEM;

	Forward1_4to1 : mux4to1 generic map (N => 2) port map (
		A 		=> "00",
		B 		=> "01",
		C 		=> "10",
		D 		=> f1_mux2to1_out,
		S(1) 	=> Rd_WB_eq_Rs1,
		S(0)	=> Rd_MEM_eq_Rs1,
		Y 		=> Forward1 
	);
	
	Forward1_2to1 : mux2to1 generic map (N => 2) port map (
		A	=> "10",
		B	=> "01",
		S 	=> RegWrite_WB_and_RegWrite_MEM,
		Y	=> f1_mux2to1_out 
	);
	
	Forward2_4to1 : mux4to1 generic map (N => 2) port map (
		A 		=> "00",
		B 		=> "01",
		C 		=> "10",
		D 		=> f2_mux2to1_out,
		S(1) 	=> Rd_WB_eq_Rs2,
		S(0)	=> Rd_MEM_eq_Rs2,
		Y 		=> Forward2 
	);
	
	Forward2_2to1 : mux2to1 generic map (N => 2) port map (
		A	=> "10",
		B	=> "01",
		S 	=> RegWrite_WB_and_RegWrite_MEM,
		Y	=> f2_mux2to1_out 
	);

	--Forward1 <= "00" when (Rd_WB /= Rs1 and Rd_MEM /= Rs1) else
	--			"01" when (Rd_WB /= Rs1 and Rd_MEM  = Rs1) else
	--			"10" when (Rd_WB  = Rs1 and Rd_MEM /= Rs1) else
	--			"01" when ((Rd_WB = Rs1 and Rd_MEM = Rs1) and (RegWrite_WB = '1' and RegWrite_MEM = '1')) else
	--			"10" when ((Rd_WB = Rs1 and Rd_MEM = Rs1) and (RegWrite_WB = '0' or RegWrite_MEM = '0'));

	--Forward2 <= "00" when (Rd_WB /= Rs2 and Rd_MEM /= Rs2) else
	--			"01" when (Rd_WB /= Rs2 and Rd_MEM  = Rs2) else
	--			"10" when (Rd_WB  = Rs2 and Rd_MEM /= Rs2) else
	--			"01" when ((Rd_WB = Rs2 and Rd_MEM = Rs2) and (RegWrite_WB = '1' and RegWrite_MEM = '1')) else
	--			"10" when ((Rd_WB = Rs2 and Rd_MEM = Rs2) and (RegWrite_WB = '0' or RegWrite_MEM = '0'));

end architecture;

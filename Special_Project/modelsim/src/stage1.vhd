library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage1 is
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
end entity;

architecture beh of stage1 is

	component regN
		generic(N					: integer);
		port(	load, clk, rst 		: in std_logic;
				pin 				: in std_logic_vector(N-1 downto 0);
				pout 				: out std_logic_vector(N-1 downto 0));
	end component;

signal Stall		: std_logic;
signal out_add, stall_mux_out, nop_mux_out	: std_logic_vector (31 downto 0);

begin
	
	PC_reg : regN generic map (N => 32) port map (
		load 	=> '1', 
		clk		=> clk, 
		rst 	=> rst,		
		pin 	=> PC_in,				
		pout	=> PC_out		
	);
	
	mem_reg : regN generic map (N => 32) port map (
		load 	=> '1', 
		clk		=> clk, 
		rst 	=> rst,		
		pin 	=> nop_mux_out,				
		pout	=> inst_mem_read_out		
	);

	-- pc mux
	out_mux <= out_add when PCSrc = '0' else branch_add;
	
	-- stall mux
	Stall <= Stall_ID or Stall_EX or Stall_MEM;
	stall_mux_out <= x"00000004" when Stall = '0' else x"00000000";
	
	-- nop mux
	nop_mux_out <= 	inst_mem_read_in when Stall = '0' else x"00000013";		-- nop instruction

	-- adder
	out_add <= std_logic_vector(unsigned(PC_in) + unsigned(stall_mux_out));

	inst_mem_add_out <= PC_in;

end architecture;
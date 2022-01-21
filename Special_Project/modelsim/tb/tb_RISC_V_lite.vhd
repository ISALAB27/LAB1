library ieee;
use ieee.std_logic_1164.all;

entity tb_RISC_V_lite is
end entity; 

architecture behaviour of tb_RISC_V_lite is

constant MemWidth 		: integer 	:= 32;
constant MemHeight 		: integer 	:= 12;
constant CLOCK_PERIOD	: time 		:= 10 ns;

	component RISC_V_lite is
		port(	inst_read 		: in std_logic_vector(31 downto 0);
				data_read 		: in std_logic_vector(31 downto 0);
				rst, clk		: in std_logic;
				inst_add		: out std_logic_vector(31 downto 0);
				data_add		: out std_logic_vector(31 downto 0);
				data_MemRead	: out std_logic;
				data_MemWrite	: out std_logic;
				data_write		: out std_logic_vector(31 downto 0));
	end component;
	
	component RAM_file
		generic(mem_width 		: integer 	:= 32;
				mem_height		: integer	:= 12;
				file_name		: string);
		port(	Address			: in std_logic_vector(mem_height-1 downto 0);
				WriteData 		: in std_logic_vector(mem_width-1 downto 0);
				MemWrite		: in std_logic;
				MemRead			: in std_logic;
				ReadData 		: out std_logic_vector(mem_width-1 downto 0));
	
	end component;
	
	component ROM_file
		generic(mem_width 		: integer 	:= 32;
				mem_height		: integer	:= 12;
				file_name		: string);
		port(	Address			: in std_logic_vector(mem_height-1 downto 0);
				ReadData 		: out std_logic_vector(mem_width-1 downto 0));
	end component;

signal inst_read, inst_add						: std_logic_vector(31 downto 0);
signal data_add, data_write, data_read			: std_logic_vector(MemWidth-1 downto 0);
signal rst, clk, data_MemRead, data_MemWrite	: std_logic;

begin

	clk_gen: process
	begin
		clk <= '0', '1' after CLOCK_PERIOD/2;
		wait for CLOCK_PERIOD;
	end process clk_gen;

	rst <= '0', '1' after CLOCK_PERIOD/4;
	
	RAM_DUT : RAM_file generic map (mem_width => MemWidth, mem_height => MemHeight, file_name => "../RAM_bin.txt") port map (
		Address 	=> data_add(MemHeight+1 downto 2), 		-- address multiplied by 4
		WriteData	=> data_write, 
		MemWrite 	=> data_MemWrite, 
		MemRead		=> data_MemRead, 
		ReadData 	=> data_read
	); 

	ROM_DUT : ROM_file generic map (mem_width => MemWidth, mem_height => MemHeight, file_name => "../ROM_bin.txt") port map (
		Address 	=> inst_add(MemHeight+1 downto 2),		-- address multiplied by 4
		ReadData 	=> inst_read
	);
	
	DUT : RISC_V_lite port map (
		inst_read 		=> inst_read, 
		data_read		=> data_read, 
		rst				=> rst, 
		clk 			=> clk, 
		inst_add 		=> inst_add, 
		data_add 		=> data_add,
		data_MemRead 	=> data_MemRead,
		data_MemWrite 	=> data_MemWrite,
		data_write		=> data_write
	);

end architecture; 
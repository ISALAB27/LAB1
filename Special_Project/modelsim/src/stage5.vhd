library ieee;
use ieee.std_logic_1164.all;

entity stage5 is
	port(	ReadData 		: in std_logic_vector(31 downto 0);
			Address			: in std_logic_vector(31 downto 0);
			MemToReg		: in std_logic;
			RegWrite_in		: in std_logic;
			Rd_in			: in std_logic_vector(4 downto 0);
			RegWrite_out	: out std_logic;
			WriteRegister	: out std_logic_vector(4 downto 0);
			WriteData		: out std_logic_vector(31 downto 0));
end entity;

architecture behaviour of stage5 is
begin

	RegWrite_out 	<= RegWrite_in;
	WriteRegister	<= Rd_in;
	
	WriteData <= ReadData when MemToReg = '1' else Address;
	
end architecture;
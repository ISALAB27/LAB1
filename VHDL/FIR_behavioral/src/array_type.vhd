library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package array_type is
	constant lenght : integer := 6;
	
	-- STD_LOGIC
	type array_std_logic is array(integer range <>) of std_logic;

	-- STD_LOGIC_VECTOR
	type array_slv is array(integer range <>) of std_logic_vector(lenght-1 downto 0);

	-- INTEGER
	type array_int is array(integer range <>) of integer;
	
end package array_type;

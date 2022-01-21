library ieee;
use ieee.std_logic_1164.all;

package matrix_array_type is

	-- STD_LOGIC
	type array_std_logic is array(integer range <>) of std_logic;
	type matrix_std_logic is array(integer range <>, integer range <>) of std_logic;
	
	-- STD_LOGIC_VECTOR
	type array_slv_32 is array(integer range <>) of std_logic_vector(31 downto 0);
	
end package matrix_array_type;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package array_type is
	-- STD_LOGIC
	type array_std_logic is array(integer range <>) of std_logic;

	-- STD_LOGIC_VECTOR
	--type array_slv is array(integer range <>) of std_logic_vector(lenght-1 downto 0);
	type array_slv6 is array(integer range <>) of std_logic_vector(5 downto 0);
	type array_slv12 is array(integer range <>) of std_logic_vector(11 downto 0);

	-- INTEGER
	type array_int is array(integer range <>) of integer;
	
end package array_type;

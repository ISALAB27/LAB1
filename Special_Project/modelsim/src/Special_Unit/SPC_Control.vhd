library ieee;
use ieee.std_logic_1164.all;

entity SPC_Control is
	port (	F3		: in std_logic_vector(2 downto 0);
			SPCctrl	: out std_logic);
end entity;

architecture beh of SPC_Control is
begin

	SPCctrl <= 	F3(0);

end architecture;

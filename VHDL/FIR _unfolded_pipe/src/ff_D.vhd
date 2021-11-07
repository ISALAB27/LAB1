library ieee;
use ieee.std_logic_1164.all;

entity ff_D is
      port (D, CLK, RST	: in std_logic;
			Q 			: out std_logic);
end entity;

architecture behavior of ff_D is
begin
    process (CLK, RST)
		begin
		    if RST = '0' then 	-- asynchronous clear
				Q <= '0';
			elsif (CLK 'event and CLK = '1') then 
				Q <= D;
			end if;
		end process;
end architecture;
library ieee;
use ieee.std_logic_1164.all;

entity regN is
	generic(N 		: integer 	:= 13);
	port(	load, clk, rst 		: in std_logic;
			pin 				: in std_logic_vector(N-1 downto 0);
			pout 				: out std_logic_vector(N-1 downto 0));
end regN;

architecture behaviour of regN is
begin
	process(clk, rst)
	begin
		if rst = '0' then
			pout <= (others => '0'); 
		elsif (clk'event and clk = '1') then
			if load = '1' then
				pout <= pin;
			end if;
		end if;
	end process;
end behaviour;
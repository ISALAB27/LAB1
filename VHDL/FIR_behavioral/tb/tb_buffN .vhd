Library ieee;
use ieee.std_logic_1164.all;
use work.array_type.all;

entity tb_buffN is
end tb_buffN; 

Architecture behavior of tb_buffN   is


component buffN

	generic(n 		: integer 	:= 11;
			delay 	: time 		:= 0 ns);
	port(	load, clk, rst 		: in std_logic;
			sin 				: in std_logic_vector(lenght-1 downto 0 );
			pout 				: out array_slv(0 to n-1));

end component;


signal data_in : std_logic_vector (12 downto 0);
signal data_out : array_slv (0 to 10);
signal clk,rst, load : std_logic;

begin

clk_generation: process
	begin
		clk <= '0', '1' after 10 ns;
		wait for 20 ns;
	end process clk_generation;
	
	rst <= '0', '1' after 5 ns;
	load <= '0', '1' after 7 ns;


process
begin
 data_in <= "0101011010101";
 wait for 20 ns;
 data_in <= "1010101000101";
 wait for 20 ns;
 data_in <= "0101000101010";
 wait for 20 ns;
 data_in <= "1001010010101";
end process;


DUT1 : buffN generic map (n => 11, delay => 0 ns) port map (load=>load, clk=>clk, rst=>rst, sin=>data_in, pout (0 to 10)=>data_out(0 to 10));



end behavior; 

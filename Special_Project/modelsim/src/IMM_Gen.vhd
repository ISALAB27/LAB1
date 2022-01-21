library ieee;
use ieee.std_logic_1164.all;

entity IMM_Gen is
	port (	IMM_in		: in std_logic_vector(31 downto 0);
			IMM_output	: out std_logic_vector(31 downto 0));
end entity;

architecture beh of IMM_Gen is
begin

	process (IMM_in)
	begin
		
		IMM_output <= x"00000000";

		case IMM_in(6 downto 0) is 
			when "0100011" =>	-- SW
				IMM_output(11 downto 0)  <= IMM_in(31 downto 25) & IMM_in(11 downto 7);
				IMM_output(31 downto 12) <= (others => IMM_in(31));
						
			when "1100011" =>	-- BEQ
				IMM_output(11 downto 0)  <= IMM_in(31) & IMM_in(7) & IMM_in(30 downto 25) & IMM_in(11 downto 8);
				IMM_output(31 downto 12) <= (others => IMM_in(31));
				
			when "0000011" =>	-- LW
				IMM_output(11 downto 0)  <= IMM_in(31 downto 20);
				IMM_output(31 downto 12) <= (others => IMM_in(31));
		
			when "0010011" =>	-- ADDI/ANDI/SRAI
				IMM_output(11 downto 0)  <= IMM_in(31 downto 20);
				IMM_output(31 downto 12) <= (others => IMM_in(31));
		
			when "0010111" =>	-- AUIPC
				IMM_output <=  IMM_in(31 downto 12) & x"000";
			
			when "0110111" =>	-- LUI
				IMM_output <=  IMM_in(31 downto 12) & x"000";
			
			when "1101111" =>	-- JAL
				IMM_output(19 downto 0)  <= IMM_in(31) & IMM_in(19 downto 12) & IMM_in(20) & IMM_in(30 downto 21);
				IMM_output(31 downto 20) <= (others => IMM_in(31));
			
			when others =>		-- ADD/SLT/XOR ("0110011")

		end case;
	end process;

end architecture;

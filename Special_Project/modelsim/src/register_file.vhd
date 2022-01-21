library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.matrix_array_type.all;

entity register_file is
	port(	read_reg1 	: in std_logic_vector (4 downto 0);
			read_reg2 	: in std_logic_vector (4 downto 0);
			write_reg 	: in std_logic;  							--write_enable
			write_data	: in std_logic_vector (31 downto 0);
			reg_write 	: in std_logic_vector (4 downto 0); 		--write address
			rst			: in std_logic;
			clk			: in std_logic;
			read_data1	: out std_logic_vector (31 downto 0);
			read_data2	: out std_logic_vector (31 downto 0));
end entity;

architecture beh of register_file is
begin 

	process (clk, rst) is
		variable pouts : array_slv_32 (31 downto 0);
	begin
		if rst = '0' then
			pouts := (others => (others => '0'));
			read_data1 <= (others => '0');
			read_data2 <= (others => '0');
		elsif clk'event and clk = '1' then
			read_data1 <= pouts(to_integer(unsigned(read_reg1)));
			read_data2 <= pouts(to_integer(unsigned(read_reg2)));
			if write_reg = '1' then
				pouts(to_integer(unsigned(reg_write))) := write_data;
			end if;
		end if;
	end process;

end architecture;

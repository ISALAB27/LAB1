library ieee;
use ieee.std_logic_1164.all;

entity tb_square_root is
end entity; 

architecture behaviour of tb_square_root is

	component square_root is
		generic(N 		: integer);
		port(	rad		: in std_logic_vector(N-1 downto 0);
				r		: out std_logic_vector((N+1)/2 downto 0);
				q		: out std_logic_vector(((N+1)/2)-1 downto 0));
	end component;

signal rad		: std_logic_vector(15 downto 0);
signal r		: std_logic_vector(8 downto 0);
signal q 		: std_logic_vector(7 downto 0);

--signal rad		: std_logic_vector(2 downto 0);
--signal r		: std_logic_vector(2 downto 0);
--signal q 		: std_logic_vector(1 downto 0);

--signal rad		: std_logic_vector(3 downto 0);
--signal r		: std_logic_vector(2 downto 0);
--signal q 		: std_logic_vector(1 downto 0);

--signal rad		: std_logic_vector(7 downto 0);
--signal r		: std_logic_vector(4 downto 0);
--signal q 		: std_logic_vector(3 downto 0);

--signal rad		: std_logic_vector(30 downto 0);
--signal r		: std_logic_vector(16 downto 0);
--signal q 		: std_logic_vector(15 downto 0);

begin

--	rad <= 	"0000" & x"0000000",
--			"1111" & x"FFFFFFF" after 10 ns,
--			"0000" & x"0000001" after 20 ns, 
--			"0000" & x"0000008" after 30 ns, 
--			"1111" & x"0FFF00A" after 40 ns, 
--			"0000" & x"AAAAAAA" after 50 ns,
--			"0000" & x"000003B" after 60 ns,
--			"0000" & x"0000057" after 70 ns,
--			"0000" & x"0045D23" after 80 ns;
			
--	rad <= 	"000" & x"0000000",
--			"111" & x"FFFFFFF" after 10 ns,
--			"000" & x"0000001" after 20 ns, 
--			"000" & x"0000008" after 30 ns, 
--			"111" & x"0FFF00A" after 40 ns, 
--			"000" & x"AAAAAAA" after 50 ns,
--			"000" & x"000003B" after 60 ns,
--			"000" & x"0000057" after 70 ns,
--			"000" & x"0045D23" after 80 ns;

--	rad <= 	"0000", "1111" after 10 ns, "0001" after 20 ns, "1000" after 30 ns, "0100" after 40 ns;
	
--	rad <= 	"00000", "11111" after 10 ns, "00001" after 20 ns, "01000" after 30 ns, "00100" after 40 ns;

--	rad <= 	x"00", x"FF" after 10 ns, x"01" after 20 ns, x"08" after 30 ns, x"04" after 40 ns;

--	rad <= 	"000", "111" after 10 ns, "001" after 20 ns, "100" after 30 ns, "010" after 40 ns;

rad <= 	x"0000",
		x"FFFF" after 10 ns,
		x"0001" after 20 ns, 
		x"0008" after 30 ns, 
		x"F00A" after 40 ns, 
		x"AAAA" after 50 ns,
		x"003B" after 60 ns,
		x"0057" after 70 ns,
		x"5D23" after 80 ns;

	--DUT : configuration work.square_root_CSM_sub_cfg generic map (N => 16) port map (rad => rad, r => r, q => q);
	--DUT : configuration work.square_root_CSA_sub_cfg generic map (N => 16) port map (rad => rad, r => r, q => q);
	DUT : configuration work.square_root_beh_cfg generic map (N => 16) port map (rad => rad, r => r, q => q);

end architecture;

--configuration tb_square_root_config of tb_square_root is
--    for behaviour
--        for DUT : square_root
--				--use configuration work.square_root_CSM_sub_cfg;
--				--use configuration work.square_root_CSA_sub_cfg;
--				use configuration work.square_root_beh_cfg;
--       end for;
--    end for;
--end configuration;
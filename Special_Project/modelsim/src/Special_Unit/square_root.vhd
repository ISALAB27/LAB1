library ieee;
use ieee.std_logic_1164.all;

entity square_root is
	generic(N 		: integer := 8);		-- WITH N > 2
	port(	rad		: in std_logic_vector(N-1 downto 0);
			r		: out std_logic_vector((N+1)/2 downto 0);
			q		: out std_logic_vector(((N+1)/2)-1 downto 0));
end entity;

architecture behaviour of square_root is

constant N_ceil 	: integer := N + (N mod 2);
--constant N_floor 	: integer := N - (N mod 2);
	
	component square_root_stage is
		generic(N 				: integer);
		port (	r_int_in 		: in std_logic_vector(N-1 downto 0);
				q_int			: in std_logic_vector(N-1 downto 0);
				q_out 			: out std_logic;
				r_int_out 		: out std_logic_vector(N-1 downto 0));
	end component;

type array_slv is array(integer range <>) of std_logic_vector((N_ceil/2)+2 downto 0);

signal r_int 			: array_slv(N_ceil/2 downto 0);			-- N                 ((N+1)/2)+1 downto 0
signal q_int 			: array_slv((N_ceil/2)-1 downto 0);		-- ((N+1)/2)+2       ((N+1)/2)+1 downto 0

signal rad_sig 			: std_logic_vector(N_ceil-1 downto 0);
signal q_sig			: std_logic_vector((N_ceil/2)-1 downto 0);

begin
	
	rad_sig <= rad when (N mod 2) = 0 else '0' & rad;
	
	-- layer 1
	r_int(0)((N_ceil/2)+2 downto 2) <= (others => '0');
	r_int(0)(1 downto 0) <= rad_sig(N_ceil-1 downto N_ceil-2);
	
	q_int(0)((N_ceil/2)+2 downto 2) <= (others => '0');
	q_int(0)(1 downto 0) <= "01";

	q_sig((N_ceil/2)-1) <= rad_sig(N_ceil-1) or rad_sig(N_ceil-2);
	r_int(1)(3 downto 2) <= (rad_sig(N_ceil-1) and rad_sig(N_ceil-2)) & (rad_sig(N_ceil-1) and not (rad_sig(N_ceil-2)));
				
	-- layer 2 to N_ceil/2
	gen : for i in 1 to (N_ceil/2)-1 generate
		
		r_int(i)((N_ceil/2)+2 downto i+3) <= (others => '0');
		r_int(i)(1 downto 0) <= rad_sig(N_ceil-1-(i*2) downto N_ceil-2-(i*2));
		
		q_int(i)((N_ceil/2)+2 downto i+2) <= (others => '0');
		q_int(i)(i+1 downto 2) <= q_sig((N_ceil/2)-1 downto (N_ceil/2)-i);
		q_int(i)(1 downto 0) <= "01";
		
		genStage : if i < (N_ceil/2)-1 generate
			stageX : square_root_stage generic map (N => i+3) port map (
				r_int_in 		=> r_int(i)(i+2 downto 0),
				q_int			=> q_int(i)(i+2 downto 0),
				q_out 			=> q_sig((N_ceil/2)-1-i),
				r_int_out 		=> r_int(i+1)(i+4 downto 2)
			);
		end generate genStage;
		
		genStageLSB : if i >= (N_ceil/2)-1 generate
			stageLSB : square_root_stage generic map (N => i+3) port map (
				r_int_in 		=> r_int(i)(i+2 downto 0),
				q_int			=> q_int(i)(i+2 downto 0),
				q_out 			=> q_sig((N_ceil/2)-1-i),
				r_int_out 		=> r_int(i+1)(i+2 downto 0)
			);
		end generate genStageLSB;
	end generate gen;
	
	r_int(N_ceil/2)((N_ceil/2)+2) <= '0';
	
	q <= q_sig((N_ceil/2)-1 downto 0);
	r <= r_int(N_ceil/2)(N_ceil/2 downto 0);
	
end architecture;
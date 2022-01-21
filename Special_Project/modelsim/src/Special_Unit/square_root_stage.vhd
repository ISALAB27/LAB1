library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity square_root_stage is
	generic(N 				: integer := 32);
	port (	r_int_in 		: in std_logic_vector(N-1 downto 0);
			q_int			: in std_logic_vector(N-1 downto 0);
			q_out 			: out std_logic;
			r_int_out 		: out std_logic_vector(N-1 downto 0));
end entity;

architecture CSS of square_root_stage is

type array_integer is array (integer range <>) of integer range 0 to 255;

-- shorter critical path with constraints on critical path
--constant block_bits_array : array_integer(0 to 18) := (0, 1, 2, 3, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 3, 4, 5, 4);
-- shorter critical path without constraints on critical path
constant block_bits_array : array_integer(0 to 18) := (0, 1, 2, 1, 2, 2, 2, 2, 2, 3, 2, 3, 3, 3, 3, 3, 4, 3, 3);
-- smaller area with constraints on critical path
--constant block_bits_array : array_integer(0 to 18) := (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18);
-- smaller area without constraints on critical path
--constant block_bits_array : array_integer(0 to 18) := (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18);

	component CSS is
		generic(bits		: integer;
				block_bits 	: integer);
		port (	a 			: in std_logic_vector(bits-1 downto 0);
				b			: in std_logic_vector(bits-1 downto 0);
				b_in		: in std_logic;
				sub 		: out std_logic_vector(bits-1 downto 0);
				b_out 		: out std_logic);
	end component;
	
	component mux2to1 
		generic(N 		: integer);
		port(	A, B	: in std_logic_vector(N-1 downto 0);
				S		: in std_logic;
				Y		: out std_logic_vector(N-1 downto 0));
	end component;

signal sub_int 	: std_logic_vector(N downto 0);
signal b_in_sig : std_logic;

signal r_int_in0_n	: std_logic;

signal out_nand_1, out_nand_2	: std_logic;
signal r_int_in1_n	: std_logic;

begin

	r_int_in0_n <= not r_int_in(0);
	sub_int(0)  <= r_int_in0_n;
	
	r_int_in1_n <= not r_int_in(1);

	out_nand_1 	<= (r_int_in1_n nand r_int_in0_n);
	out_nand_2 	<= (r_int_in(1) nand (not r_int_in0_n));
	sub_int(1) 	<= (out_nand_1 nand out_nand_2);
	b_in_sig 	<= not out_nand_1;
	
	subtractor : CSS generic map (bits => N-3, block_bits => block_bits_array(N-3)) port map (
		a 		=> r_int_in(N-2 downto 2),
		b 		=> q_int(N-2 downto 2),
		b_in 	=> b_in_sig,
		sub		=> sub_int(N-2 downto 2),
		b_out 	=> sub_int(N-1)
	);
	
	sub_int(N) <= sub_int(N-1) nand (not r_int_in(N-1));
	
	q_out <= sub_int(N);
	
	mux : mux2to1 generic map (N => N) port map (
		A	=> r_int_in,
		B	=> sub_int(N-1 downto 0),
		S	=> sub_int(N),
		Y	=> r_int_out
	);

end architecture;

-- architecture CSA_sub of square_root_stage is

-- type array_integer is array (integer range <>) of integer range 0 to 255;

-- -- shorter critical path with constraints on critical path
-- constant block_bits_array : array_integer(0 to 18) := (0, 1, 2, 3, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3);
-- -- shorter critical path without constraints on critical path
-- --constant block_bits_array : array_integer(0 to 32) := (0, );
-- -- smaller area with constraints on critical path
-- --constant block_bits_array : array_integer(0 to 32) := (0, );
-- -- smaller area without constraints on critical path
-- --constant block_bits_array : array_integer(0 to 32) := (0, );

	-- component CSA is
		-- generic(bits		: integer;
				-- block_bits 	: integer);
		-- port (	a 			: in std_logic_vector(bits-1 downto 0);
				-- b			: in std_logic_vector(bits-1 downto 0);
				-- carry_in	: in std_logic;
				-- sum 		: out std_logic_vector(bits-1 downto 0);
				-- carry_out 	: out std_logic);
	-- end component;
	
	-- component mux2to1 
		-- generic(N 		: integer);
		-- port(	A, B	: in std_logic_vector(N-1 downto 0);
				-- S		: in std_logic;
				-- Y		: out std_logic_vector(N-1 downto 0));
	-- end component;

-- signal q_int_n : std_logic_vector(N-1 downto 0);
-- signal sub_int : std_logic_vector(N downto 0);

-- begin

	-- q_int_n <= not (q_int);

	-- subtractor : CSA generic map (bits => N, block_bits => block_bits_array(N)) port map (
		-- a 			=> r_int_in,
		-- b 			=> q_int_n,
		-- carry_in 	=> '1',
		-- sum		 	=> sub_int(N-1 downto 0),
		-- carry_out 	=> sub_int(N)
	-- );
	
	-- q_out <= sub_int(N);
	
	-- mux : mux2to1 generic map (N => N) port map (
		-- A	=> r_int_in,
		-- B	=> sub_int(N-1 downto 0),
		-- S	=> sub_int(N),
		-- Y	=> r_int_out
	-- );
	
-- end architecture;

-- architecture behaviour of square_root_stage is

-- signal sub_int : std_logic_vector(N downto 0);

-- begin

	-- sub_int 	<= std_logic_vector(resize(unsigned(r_int_in), N+1) - resize(unsigned(q_int), N+1));
	-- q_out 		<= not sub_int(N);
	-- r_int_out 	<= sub_int(N-1 downto 0) when sub_int(N) = '0' else r_int_in;

-- end architecture;

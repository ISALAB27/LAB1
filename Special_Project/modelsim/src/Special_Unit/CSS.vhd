library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity CSS is
	generic(bits		: integer := 8; 	-- bits >= block_bits
			block_bits 	: integer := 2);
	port (	a 			: in std_logic_vector(bits-1 downto 0);
			b			: in std_logic_vector(bits-1 downto 0);
		 	b_in		: in std_logic;
			sub 		: out std_logic_vector(bits-1 downto 0);
			b_out 		: out std_logic);
end entity;

architecture structural of CSS is

constant N_block 	: integer := bits / block_bits;
constant rem_bits 	: integer := bits mod block_bits;

	component RCS
		generic(N 			: integer);
		port (	x 			: in std_logic_vector(N-1 downto 0);
				y			: in std_logic_vector(N-1 downto 0);
				b_in		: in std_logic;
				sub 		: out std_logic_vector(N-1 downto 0);
				b_out 		: out std_logic);
	end component;
	
	component mux2to1 
		generic(N 		: integer);
		port(	A, B	: in std_logic_vector(N-1 downto 0);
				S		: in std_logic;
				Y		: out std_logic_vector(N-1 downto 0));
	end component;
	
	component mux2to1_comb
		port(	A, B	: in std_logic;
				S		: in std_logic;
				Y		: out std_logic);
	end component;
	
type array_slv is array(integer range <>) of std_logic_vector(block_bits-1 downto 0);
	
signal sub0_sig 		: array_slv(N_block-2 downto 0);
signal sub1_sig 		: array_slv(N_block-2 downto 0);
signal sub0_rem_sig 	: std_logic_vector(rem_bits-1 downto 0);
signal sub1_rem_sig 	: std_logic_vector(rem_bits-1 downto 0);
signal b_out0_sig 	: std_logic_vector(N_block-1 downto 0);
signal b_out1_sig 	: std_logic_vector(N_block-1 downto 0);
signal sel_muxes 		: std_logic_vector(N_block downto 0);
	
begin

	-- first RCS
	RCS0 : RCS generic map (N => block_bits) port map (
		x 		=> a(block_bits-1 downto 0),
		y 		=> b(block_bits-1 downto 0),
		b_in 	=> b_in,
		sub 	=> sub(block_bits-1 downto 0),
		b_out 	=> sel_muxes(0)
	);
	
	-- all the select RCS
	select_RCS_gen : for i in 1 to N_block-1 generate
		
		RCS_b0x : RCS generic map (N => block_bits) port map (
			x 		=> a((i*block_bits + (block_bits-1)) downto i*block_bits),
			y 		=> b((i*block_bits + (block_bits-1)) downto i*block_bits),
			b_in 	=> '0',
			sub 	=> sub0_sig(i-1),
			b_out 	=> b_out0_sig(i-1)
		);

		RCS_b1x : RCS generic map (N => block_bits) port map (
			x 		=> a((i*block_bits + (block_bits-1)) downto i*block_bits),
			y 		=> b((i*block_bits + (block_bits-1)) downto i*block_bits),
			b_in 	=> '1',
			sub 	=> sub1_sig(i-1),
			b_out 	=> b_out1_sig(i-1)
		);
		
		mux2to1x : mux2to1 generic map (N => block_bits) port map (
			A 	=> sub0_sig(i-1),
			B 	=> sub1_sig(i-1),
			S 	=> sel_muxes(i-1),
			Y 	=> sub((i*block_bits + (block_bits-1)) downto i*block_bits)
		);

		mux2to1bx : mux2to1_comb port map (
			A 	=> b_out0_sig(i-1),
			B 	=> b_out1_sig(i-1),
			S 	=> sel_muxes(i-1),
			Y 	=> sel_muxes(i)
		);

	end generate select_RCS_gen;
	
	-- generate last select RCS if the remaining bits are more than 0
	last_select_RCS_gen : if rem_bits > 0 generate
		
		last_RCS_b0 : RCS generic map (N => rem_bits) port map (
			x 		=> a(bits-1 downto bits-rem_bits),
			y 		=> b(bits-1 downto bits-rem_bits),
			b_in 	=> '0',
			sub 	=> sub0_rem_sig,
			b_out 	=> b_out0_sig(N_block-1)
		);

		last_RCS_b1 : RCS generic map (N => rem_bits) port map (
			x 		=> a(bits-1 downto bits-rem_bits),
			y 		=> b(bits-1 downto bits-rem_bits),
			b_in 	=> '1',
			sub 	=> sub1_rem_sig,
			b_out 	=> b_out1_sig(N_block-1)
		);

		last_mux2to1 : mux2to1 generic map (N => rem_bits) port map (
			A 	=> sub0_rem_sig,
			B 	=> sub1_rem_sig,
			S 	=> sel_muxes(N_block-1),
			Y 	=> sub(bits-1 downto bits-rem_bits)
		);
	
		last_mux2to1b : mux2to1_comb port map (
			A 	=> b_out0_sig(N_block-1),
			B 	=> b_out1_sig(N_block-1),
			S 	=> sel_muxes(N_block-1),
			Y 	=> sel_muxes(N_block)
		);

	end generate last_select_RCS_gen;
	
	b_out_gen : if rem_bits = 0 generate
	
		sub0_rem_sig 	<= (others => '0');
		sub1_rem_sig 	<= (others => '0');
		b_out 			<= sel_muxes(N_block-1);

	end generate b_out_gen;
	
	last_b_out_gen : if rem_bits > 0 generate
	
		b_out <= sel_muxes(N_block);
	
	end generate last_b_out_gen;

end architecture;
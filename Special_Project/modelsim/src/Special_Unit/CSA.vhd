library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity CSA is
	generic(bits		: integer := 8; 	-- bits >= block_bits
			block_bits 	: integer := 2);
	port (	a 			: in std_logic_vector(bits-1 downto 0);
			b			: in std_logic_vector(bits-1 downto 0);
		 	carry_in	: in std_logic;
			sum 		: out std_logic_vector(bits-1 downto 0);
			carry_out 	: out std_logic);
end entity;

architecture structural of CSA is

constant N_block 	: integer := bits / block_bits;
constant rem_bits 	: integer := bits mod block_bits;

	component RCA
		generic(N 			: integer);
		port (	a 			: in std_logic_vector(N-1 downto 0);
				b			: in std_logic_vector(N-1 downto 0);
				carry_in	: in std_logic;
				sum 		: out std_logic_vector(N-1 downto 0);
				carry_out 	: out std_logic);
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
	
signal sum0_sig 		: array_slv(N_block-2 downto 0);
signal sum1_sig 		: array_slv(N_block-2 downto 0);
signal sum0_rem_sig 	: std_logic_vector(rem_bits-1 downto 0);
signal sum1_rem_sig 	: std_logic_vector(rem_bits-1 downto 0);
signal carry_out0_sig 	: std_logic_vector(N_block-1 downto 0);
signal carry_out1_sig 	: std_logic_vector(N_block-1 downto 0);
signal sel_muxes 		: std_logic_vector(N_block downto 0);
	
begin

	-- first RCA
	RCA0 : RCA generic map (N => block_bits) port map (
		a 			=> a(block_bits-1 downto 0),
		b 			=> b(block_bits-1 downto 0),
		carry_in 	=> carry_in,
		sum 		=> sum(block_bits-1 downto 0),
		carry_out 	=> sel_muxes(0)
	);
	
	-- all the select RCA
	select_RCA_gen : for i in 1 to N_block-1 generate
		
		RCA_carry0x : RCA generic map (N => block_bits) port map (
			a 			=> a((i*block_bits + (block_bits-1)) downto i*block_bits),
			b 			=> b((i*block_bits + (block_bits-1)) downto i*block_bits),
			carry_in 	=> '0',
			sum 		=> sum0_sig(i-1),
			carry_out 	=> carry_out0_sig(i-1)
		);

		RCA_carry1x : RCA generic map (N => block_bits) port map (
			a 			=> a((i*block_bits + (block_bits-1)) downto i*block_bits),
			b 			=> b((i*block_bits + (block_bits-1)) downto i*block_bits),
			carry_in 	=> '1',
			sum 		=> sum1_sig(i-1),
			carry_out 	=> carry_out1_sig(i-1)
		);
		
		mux2to1x : mux2to1 generic map (N => block_bits) port map (
			A 	=> sum0_sig(i-1),
			B 	=> sum1_sig(i-1),
			S 	=> sel_muxes(i-1),
			Y 	=> sum((i*block_bits + (block_bits-1)) downto i*block_bits)
		);

		mux2to1carryx : mux2to1_comb port map (
			A 	=> carry_out0_sig(i-1),
			B 	=> carry_out1_sig(i-1),
			S 	=> sel_muxes(i-1),
			Y 	=> sel_muxes(i)
		);

	end generate select_RCA_gen;
	
	-- generate last select RCA if the remaining bits are more than 0
	last_select_RCA_gen : if rem_bits > 0 generate
		
		last_RCA_carry0 : RCA generic map (N => rem_bits) port map (
			a 			=> a(bits-1 downto bits-rem_bits),
			b 			=> b(bits-1 downto bits-rem_bits),
			carry_in 	=> '0',
			sum 		=> sum0_rem_sig,
			carry_out 	=> carry_out0_sig(N_block-1)
		);

		last_RCA_carry1 : RCA generic map (N => rem_bits) port map (
			a 			=> a(bits-1 downto bits-rem_bits),
			b 			=> b(bits-1 downto bits-rem_bits),
			carry_in 	=> '1',
			sum 		=> sum1_rem_sig,
			carry_out 	=> carry_out1_sig(N_block-1)
		);

		last_mux2to1 : mux2to1 generic map (N => rem_bits) port map (
			A 	=> sum0_rem_sig,
			B 	=> sum1_rem_sig,
			S 	=> sel_muxes(N_block-1),
			Y 	=> sum(bits-1 downto bits-rem_bits)
		);
	
		last_mux2to1carry : mux2to1_comb port map (
			A 	=> carry_out0_sig(N_block-1),
			B 	=> carry_out1_sig(N_block-1),
			S 	=> sel_muxes(N_block-1),
			Y 	=> sel_muxes(N_block)
		);

	end generate last_select_RCA_gen;
	
	carry_out_gen : if rem_bits = 0 generate
	
		sum0_rem_sig <= (others => '0');
		sum1_rem_sig <= (others => '0');
		carry_out <= sel_muxes(N_block-1);

	end generate carry_out_gen;
	
	last_carry_out_gen : if rem_bits > 0 generate
	
		carry_out <= sel_muxes(N_block);
	
	end generate last_carry_out_gen;


end architecture;
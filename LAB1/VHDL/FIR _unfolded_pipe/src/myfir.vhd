library ieee;
use ieee.std_logic_1164.all;
use work.array_type.all;

entity myfir is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
	VIN   : in std_logic;
    DIN1  : in std_logic_vector(12 downto 0);
	DIN2  : in std_logic_vector(12 downto 0);
	DIN3  : in std_logic_vector(12 downto 0);
	VOUT  : out std_logic;
    DOUT1 : out std_logic_vector(12 downto 0);
	DOUT2 : out std_logic_vector(12 downto 0);
	DOUT3 : out std_logic_vector(12 downto 0);
	B0    : in std_logic_vector(12 downto 0);
	B1    : in std_logic_vector(12 downto 0);
	B2    : in std_logic_vector(12 downto 0);
	B3    : in std_logic_vector(12 downto 0);
	B4    : in std_logic_vector(12 downto 0);
	B5    : in std_logic_vector(12 downto 0));
end myfir;

architecture beh of myfir is
-- aproximates inputs by n bit (NB_APPROXIMATION > 6)
constant NB_APPROXIMATION : integer := 7;
 -- modifies the index of bn to use only 6 coefficients, the others are symmetrical
constant bn_index : array_int(0 to 10) := (0, 1, 2, 3, 4, 5, 4, 3, 2, 1, 0);

	-- flip-flop D component
	component ff_D is
		port (	D, CLK, RST	: in std_logic;
				Q 			: out std_logic);
	end component;
	
	-- register component
	component regN is
		generic(N 		: integer);
		port(	load, clk, rst 		: in std_logic;
				pin 				: in std_logic_vector(N-1 downto 0);
				pout 				: out std_logic_vector(N-1 downto 0));
	end component;
	
	-- adder component
	component adder is
		generic(N 		: integer);
		port(	a 		: in std_logic_vector(N-1 downto 0);
				b 		: in std_logic_vector(N-1 downto 0);
				res		: out std_logic_vector(N-1 downto 0));  -- do not care about overflow
	end component;
	
	-- multiplier component
	component mult is
		generic(N 		: integer);
		port(	a 		: in std_logic_vector(N-1 downto 0);
				b 		: in std_logic_vector(N-1 downto 0);
				res		: out std_logic_vector((N*2)-1 downto 0));
	end component;

-- BN reg signals
signal bn_r_out		: array_slv6(0 to 5);

-- DINX reg signal
signal x1, x2, x3   : std_logic_vector(12-NB_APPROXIMATION downto 0);

-- mult signals
signal multx1_res, multx2_res, multx3_res	: array_slv12(1 to 10);

-- adder signals
signal addx1_res, addx2_res, addx3_res		: array_slv12(0 to 10);
signal addx1_b, addx2_b, addx3_b			: array_slv12(0 to 10);

-- column reg signals
signal reg_out		: array_slv12(0 to 9);

-- pipeline reg signals
signal mult1_pipe_out	: array_slv6(0 to 9);
signal add1_pipe_out	: array_slv12(0 to 9);
signal mult2_pipe_out	: array_slv6(0 to 9);
signal add2_pipe_out	: array_slv12(0 to 9);
signal mult3_pipe_out	: array_slv6(0 to 9);
signal add3_pipe_out	: array_slv12(0 to 9);

-- VOUT flip-flops signals
signal vout_sig		: array_std_logic(0 to 10);
signal load_doutx_r	: std_logic;

-- reset signal, RST_n input negated
signal rst			: std_logic;

begin  -- beh
	-- inputs registers, we remove LSBs based on NB_APPROXIMATION
	DIN1_R : regN generic map(n => 13-NB_APPROXIMATION) port map(load => VIN, clk => CLK, rst => RST_n, pin => DIN1(12 downto NB_APPROXIMATION), pout => x1);
	DIN2_R : regN generic map(n => 13-NB_APPROXIMATION) port map(load => VIN, clk => CLK, rst => RST_n, pin => DIN2(12 downto NB_APPROXIMATION), pout => x2);
	DIN3_R : regN generic map(n => 13-NB_APPROXIMATION) port map(load => VIN, clk => CLK, rst => RST_n, pin => DIN3(12 downto NB_APPROXIMATION), pout => x3);
	
	-- outputs registers, we add LSBs based on NB_APPROXIMATION
	DOUT1_R : regN generic map(n => 13) port map(load => load_doutx_r, clk => CLK, rst => RST_n, pin(12 downto (2*NB_APPROXIMATION+1-13)) => addx1_res(10)(26-(2*NB_APPROXIMATION)-2 downto 0), pin((2*NB_APPROXIMATION-13) downto 0) => (others => '0'), pout => DOUT1);
	DOUT2_R : regN generic map(n => 13) port map(load => load_doutx_r, clk => CLK, rst => RST_n, pin(12 downto (2*NB_APPROXIMATION+1-13)) => addx2_res(10)(26-(2*NB_APPROXIMATION)-2 downto 0), pin((2*NB_APPROXIMATION-13) downto 0) => (others => '0'), pout => DOUT2);
	DOUT3_R : regN generic map(n => 13) port map(load => load_doutx_r, clk => CLK, rst => RST_n, pin(12 downto (2*NB_APPROXIMATION+1-13)) => addx3_res(10)(26-(2*NB_APPROXIMATION)-2 downto 0), pin((2*NB_APPROXIMATION-13) downto 0) => (others => '0'), pout => DOUT3);
	
	-- create rst starting from rst_n input
	rst <= NOT RST_n;
	
	-- BN registers, we use rst as clock for the BN registers, because in this way you can load BN registers only on reset
	B0_R	: regN generic map(n => 13-NB_APPROXIMATION) port map(load => '1', clk => rst, rst => '1', pin => B0(12 downto NB_APPROXIMATION), pout => bn_r_out(0));
	B1_R	: regN generic map(n => 13-NB_APPROXIMATION) port map(load => '1', clk => rst, rst => '1', pin => B1(12 downto NB_APPROXIMATION), pout => bn_r_out(1));
	B2_R	: regN generic map(n => 13-NB_APPROXIMATION) port map(load => '1', clk => rst, rst => '1', pin => B2(12 downto NB_APPROXIMATION), pout => bn_r_out(2));
	B3_R	: regN generic map(n => 13-NB_APPROXIMATION) port map(load => '1', clk => rst, rst => '1', pin => B3(12 downto NB_APPROXIMATION), pout => bn_r_out(3));
	B4_R	: regN generic map(n => 13-NB_APPROXIMATION) port map(load => '1', clk => rst, rst => '1', pin => B4(12 downto NB_APPROXIMATION), pout => bn_r_out(4));
	B5_R	: regN generic map(n => 13-NB_APPROXIMATION) port map(load => '1', clk => rst, rst => '1', pin => B5(12 downto NB_APPROXIMATION), pout => bn_r_out(5));

	-- first multiplier column, there is no adder and result are passed directly to addxx_res(0) signals
	FIRST_MULT1	: mult generic map(n => 13-NB_APPROXIMATION) port map (a => x1, b => bn_r_out(0), res => addx1_b(0));
	FIRST_MULT2	: mult generic map(n => 13-NB_APPROXIMATION) port map (a => x2, b => bn_r_out(0), res => addx2_b(0));
	FIRST_MULT3	: mult generic map(n => 13-NB_APPROXIMATION) port map (a => x3, b => bn_r_out(0), res => addx3_b(0));
	FIRST_mPIPE1: regN generic map(n => 12) port map(load => '1', clk => CLK, rst => RST_n, pin => addx1_b(0), pout => addx1_res(0));
	FIRST_mPIPE2: regN generic map(n => 12) port map(load => '1', clk => CLK, rst => RST_n, pin => addx2_b(0), pout => addx2_res(0));
	FIRST_mPIPE3: regN generic map(n => 12) port map(load => '1', clk => CLK, rst => RST_n, pin => addx3_b(0), pout => addx3_res(0));
	FIRST_REG	: regN generic map(n => 12) port map(load => '1', clk => CLK, rst => RST_n, pin => addx3_res(0), pout => reg_out(0));
	FIRST_PIPE1	: regN generic map(n => 6) port map(load => '1', clk => CLK, rst => RST_n, pin => x1, pout => mult1_pipe_out(0));
	FIRST_PIPE2	: regN generic map(n => 12) port map(load => '1', clk => CLK, rst => RST_n, pin => addx1_res(0), pout => add1_pipe_out(0));
	FIRST_PIPE3	: regN generic map(n => 6) port map(load => '1', clk => CLK, rst => RST_n, pin => x2, pout => mult2_pipe_out(0));
	FIRST_PIPE4	: regN generic map(n => 12) port map(load => '1', clk => CLK, rst => RST_n, pin => addx2_res(0), pout => add2_pipe_out(0));
	FIRST_PIPE5	: regN generic map(n => 6) port map(load => '1', clk => CLK, rst => RST_n, pin => x3, pout => mult3_pipe_out(0));
	FIRST_PIPE6	: regN generic map(n => 12) port map(load => '1', clk => CLK, rst => RST_n, pin => reg_out(0), pout => add3_pipe_out(0));
	
	-- first FFD to generate VOUT output starting from VIN
	FIRST_FFD	: ff_D port map(D => VIN, CLK => CLK, RST => RST_n, Q => vout_sig(0));
	
	-- generate columns
	GEN_COLUMNS: 
	for I in 1 to 10 generate
		MULTX1	: mult generic map(n => 13-NB_APPROXIMATION) port map (a => mult1_pipe_out(I-1), b => bn_r_out(bn_index(I)), res => multx1_res(I));
		mPIPE1	: regN generic map(n => 12) port map(load => '1', clk => CLK, rst => RST_n, pin => multx1_res(I), pout => addx1_b(I));
		ADDX1	: adder generic map(n => 12) port map (a => add3_pipe_out(I-1), b => addx1_b(I), res => addx1_res(I));
		
		MULTX2	: mult generic map(n => 13-NB_APPROXIMATION) port map (a => mult2_pipe_out(I-1), b => bn_r_out(bn_index(I)), res => multx2_res(I));
		mPIPE2	: regN generic map(n => 12) port map(load => '1', clk => CLK, rst => RST_n, pin => multx2_res(I), pout => addx2_b(I));
		ADDX2	: adder generic map(n => 12) port map (a => add1_pipe_out(I-1), b => addx2_b(I), res => addx2_res(I));
		
		MULTX3	: mult generic map(n => 13-NB_APPROXIMATION) port map (a => mult3_pipe_out(I-1), b => bn_r_out(bn_index(I)), res => multx3_res(I));
		mPIPE3	: regN generic map(n => 12) port map(load => '1', clk => CLK, rst => RST_n, pin => multx3_res(I), pout => addx3_b(I));
		ADDX3	: adder generic map(n => 12) port map (a => add2_pipe_out(I-1), b => addx3_b(I), res => addx3_res(I));
		
		-- generate a cascade of FFD to output VOUT with the correct timing
		FFDX	: ff_D port map(D => vout_sig(I-1), CLK => CLK, RST => RST_n, Q => vout_sig(I));
		
		GEN_REG:
		if I < 10 generate
			REGX	: regN generic map(n => 12) port map(load => '1', clk => CLK, rst => RST_n, pin => addx3_res(I), pout => reg_out(I));
			PIPEX1	: regN generic map(n => 6) port map(load => '1', clk => CLK, rst => RST_n, pin => mult1_pipe_out(I-1), pout => mult1_pipe_out(I));
			PIPEX2	: regN generic map(n => 12) port map(load => '1', clk => CLK, rst => RST_n, pin => addx1_res(I), pout => add1_pipe_out(I));
			PIPEX3	: regN generic map(n => 6) port map(load => '1', clk => CLK, rst => RST_n, pin => mult2_pipe_out(I-1), pout => mult2_pipe_out(I));
			PIPEX4	: regN generic map(n => 12) port map(load => '1', clk => CLK, rst => RST_n, pin => addx2_res(I), pout => add2_pipe_out(I));
			PIPEX5	: regN generic map(n => 6) port map(load => '1', clk => CLK, rst => RST_n, pin => mult3_pipe_out(I-1), pout => mult3_pipe_out(I));
			PIPEX6	: regN generic map(n => 12) port map(load => '1', clk => CLK, rst => RST_n, pin => reg_out(I), pout => add3_pipe_out(I));
		end generate GEN_REG;
	end generate GEN_COLUMNS;
	
	-- FFD to generate load_doutx_r signal
	LOAD_DOUTX  : ff_D port map(D => vout_sig(vout_sig'length-1), CLK => CLK, RST => RST_n, Q => load_doutx_r);
	
	-- last FFD to generate VOUT output
	LAST_FFD	: ff_D port map(D => load_doutx_r, CLK => CLK, RST => RST_n, Q => VOUT);
	
end beh;
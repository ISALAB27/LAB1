library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.array_type.all;

entity myfir is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
	VIN   : in std_logic;
    DIN   : in std_logic_vector(12 downto 0);
	VOUT  : out std_logic;
    DOUT  : out std_logic_vector(12 downto 0);
	B0    : in std_logic_vector(12 downto 0);
	B1    : in std_logic_vector(12 downto 0);
	B2    : in std_logic_vector(12 downto 0);
	B3    : in std_logic_vector(12 downto 0);
	B4    : in std_logic_vector(12 downto 0);
	B5    : in std_logic_vector(12 downto 0));
end myfir;

architecture beh of myfir is
constant NB_APPROXIMATION : integer := 7;	-- NB_APPROXIMATION > 6

	component regN is
		generic(N 		: integer);
		port(	load, clk, rst 		: in std_logic;
				pin 				: in std_logic_vector(N-1 downto 0 );
				pout 				: out std_logic_vector(N-1 downto 0 ));
	end component;
	
	component buffN is
		generic(N 		: integer);
		port(	load, clk, rst 		: in std_logic;
				sin 				: in std_logic_vector(lenght-1 downto 0 );
				pout 				: out array_slv(0 to N-1));
	end component;


signal bn_r_out		: array_slv(0 to 5);
signal x_out		: array_slv(0 to 10);
signal y			: std_logic_vector(26-(2*NB_APPROXIMATION)-2 downto 0);
--signal y_shift		: std_logic_vector(12 downto 0);
signal load_dout_r	: std_logic;
signal rst			: std_logic;

begin  -- beh
	DIN_BUFF: buffN generic map(n => 11) port map(load => VIN, clk => CLK, rst => RST_n, sin => DIN(12 downto NB_APPROXIMATION), pout => x_out);
	DOUT_R	: regN generic map(n => 13) port map(load => load_dout_r, clk => CLK, rst => RST_n, pin(12 downto (2*NB_APPROXIMATION+1-13)) => y, pin((2*NB_APPROXIMATION-13) downto 0) => (others => '0'), pout => DOUT);
	B0_R	: regN generic map(n => 13-NB_APPROXIMATION) port map(load => '1', clk => rst, rst => '1', pin => B0(12 downto NB_APPROXIMATION), pout => bn_r_out(0));
	B1_R	: regN generic map(n => 13-NB_APPROXIMATION) port map(load => '1', clk => rst, rst => '1', pin => B1(12 downto NB_APPROXIMATION), pout => bn_r_out(1));
	B2_R	: regN generic map(n => 13-NB_APPROXIMATION) port map(load => '1', clk => rst, rst => '1', pin => B2(12 downto NB_APPROXIMATION), pout => bn_r_out(2));
	B3_R	: regN generic map(n => 13-NB_APPROXIMATION) port map(load => '1', clk => rst, rst => '1', pin => B3(12 downto NB_APPROXIMATION), pout => bn_r_out(3));
	B4_R	: regN generic map(n => 13-NB_APPROXIMATION) port map(load => '1', clk => rst, rst => '1', pin => B4(12 downto NB_APPROXIMATION), pout => bn_r_out(4));
	B5_R	: regN generic map(n => 13-NB_APPROXIMATION) port map(load => '1', clk => rst, rst => '1', pin => B5(12 downto NB_APPROXIMATION), pout => bn_r_out(5));

	--y_shift(12 downto (2*NB_APPROXIMATION+1-13)) <= y;
	rst <= NOT RST_n;

	process (CLK, RST_n)
	variable y_var : integer := 0;
	variable bn_index : array_int(0 to 10) := (0, 1, 2, 3, 4, 5, 4, 3, 2, 1, 0);
	begin  -- process
		if RST_n = '0' then                 -- asynchronous reset (active low)
			VOUT <= '0';
		elsif CLK'event and CLK = '1' then  -- rising clock edge
			VOUT <= '0';
			if (load_dout_r = '1') then
				VOUT <= '1';
			end if;
			load_dout_r <= '0';
			if (VIN = '1') then
				load_dout_r <= '1';
			end if;
		end if;
		y_var := 0;
		fir_algorithm : for k in 0 to 10 loop
							y_var := y_var + (to_integer(signed(x_out(k)))*to_integer(signed(bn_r_out(bn_index(k)))));
						end loop fir_algorithm;
		y <= std_logic_vector(to_signed(y_var, y'length));
	end process;
end beh;
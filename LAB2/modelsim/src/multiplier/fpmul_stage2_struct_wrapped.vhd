library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity FPmul_stage2_wrapped is
   port( 
      A_EXP           : IN     std_logic_vector (7 DOWNTO 0);
      A_SIG           : IN     std_logic_vector (31 DOWNTO 0);
      B_EXP           : IN     std_logic_vector (7 DOWNTO 0);
      B_SIG           : IN     std_logic_vector (31 DOWNTO 0);
      SIGN_out_stage1 : IN     std_logic;
      clk             : IN     std_logic;
      isINF_stage1    : IN     std_logic;
      isNaN_stage1    : IN     std_logic;
      isZ_tab_stage1  : IN     std_logic;
      EXP_in          : OUT    std_logic_vector (7 DOWNTO 0);
      EXP_neg_stage2  : OUT    std_logic;
      EXP_pos_stage2  : OUT    std_logic;
      SIGN_out_stage2 : OUT    std_logic;
      SIG_in          : OUT    std_logic_vector (27 DOWNTO 0);
      isINF_stage2    : OUT    std_logic;
      isNaN_stage2    : OUT    std_logic;
      isZ_tab_stage2  : OUT    std_logic
   );
end FPmul_stage2_wrapped;

ARCHITECTURE struct OF FPmul_stage2_wrapped IS

	component FPmul_stage2 is
		port( 
			A_EXP           : IN     std_logic_vector (7 DOWNTO 0);
			A_SIG           : IN     std_logic_vector (31 DOWNTO 0);
			B_EXP           : IN     std_logic_vector (7 DOWNTO 0);
			B_SIG           : IN     std_logic_vector (31 DOWNTO 0);
			SIGN_out_stage1 : IN     std_logic;
			clk             : IN     std_logic;
			isINF_stage1    : IN     std_logic;
			isNaN_stage1    : IN     std_logic;
			isZ_tab_stage1  : IN     std_logic;
			EXP_in          : OUT    std_logic_vector (7 DOWNTO 0);
			EXP_neg_stage2  : OUT    std_logic;
			EXP_pos_stage2  : OUT    std_logic;
			SIGN_out_stage2 : OUT    std_logic;
			SIG_in          : OUT    std_logic_vector (27 DOWNTO 0);
			isINF_stage2    : OUT    std_logic;
			isNaN_stage2    : OUT    std_logic;
			isZ_tab_stage2  : OUT    std_logic
		);
	end component;

	component regN
		generic(N 		         : integer);
		port(	
            load, clk, rst 	: in std_logic;
		   	pin 				   : in std_logic_vector (N-1 downto 0 );
		   	pout 				   : out std_logic_vector (N-1 downto 0 )
        );
	end component;
	
	component ff_D
      port (D, CLK, RST	: in std_logic;
			Q 			: out std_logic);
	end component;
	
--signal A_EXP_sig           : std_logic_vector (7 DOWNTO 0);
--signal A_SIG_sig           : std_logic_vector (31 DOWNTO 0);
--signal B_EXP_sig           : std_logic_vector (7 DOWNTO 0);
--signal B_SIG_sig           : std_logic_vector (31 DOWNTO 0);
--signal SIGN_out_stage1_sig : std_logic;
--signal isINF_stage1_sig    : std_logic;
--signal isNaN_stage1_sig    : std_logic;
--signal isZ_tab_stage1_sig  : std_logic;
signal EXP_in_sig          : std_logic_vector (7 DOWNTO 0);
signal EXP_neg_stage2_sig  : std_logic;
signal EXP_pos_stage2_sig  : std_logic;
signal SIGN_out_stage2_sig : std_logic;
signal SIG_in_sig          : std_logic_vector (27 DOWNTO 0);
signal isINF_stage2_sig    : std_logic;
signal isNaN_stage2_sig    : std_logic;
signal isZ_tab_stage2_sig  : std_logic;

begin

	stage2: FPmul_stage2 port map(
			--A_EXP 				=> A_EXP_sig, 
			--A_SIG 				=> A_SIG_sig,
			--B_EXP 				=> B_EXP_sig,
			--B_SIG 				=> B_SIG_sig,
			--SIGN_out_stage1 	=> SIGN_out_stage1_sig,
			--clk 				=> clk,
			--isINF_stage1 		=> isINF_stage1_sig,
			--isNaN_stage1 		=> isNaN_stage1_sig,
			--isZ_tab_stage1 		=> isZ_tab_stage1_sig,
			A_EXP 				=> A_EXP, 
			A_SIG 				=> A_SIG,
			B_EXP 				=> B_EXP,
			B_SIG 				=> B_SIG,
			SIGN_out_stage1 	=> SIGN_out_stage1,
			clk 				=> clk,
			isINF_stage1 		=> isINF_stage1,
			isNaN_stage1 		=> isNaN_stage1,
			isZ_tab_stage1 		=> isZ_tab_stage1,
			EXP_in 				=> EXP_in_sig,
			EXP_neg_stage2 		=> EXP_neg_stage2_sig,
			EXP_pos_stage2 		=> EXP_pos_stage2_sig,
			SIGN_out_stage2 	=> SIGN_out_stage2_sig,
			SIG_in 				=> SIG_in_sig,
			isINF_stage2 		=> isINF_stage2_sig,
			isNaN_stage2 		=> isNaN_stage2_sig,
			isZ_tab_stage2 		=> isZ_tab_stage2_sig
			);
	
	--A_EXP_reg: regN generic map(N => 8) port map(load => '1', clk => clk, rst => '1', pin => A_EXP, pout => A_EXP_sig);
	--A_SIG_reg: regN generic map(N => 32) port map(load => '1', clk => clk, rst => '1', pin => A_SIG, pout => A_SIG_sig);
	--B_EXP_reg: regN generic map(N => 8) port map(load => '1', clk => clk, rst => '1', pin => B_EXP, pout => B_EXP_sig);
	--B_SIG_reg: regN generic map(N => 32) port map(load => '1', clk => clk, rst => '1', pin => B_SIG, pout => B_SIG_sig);
	--SIGN_out_stage1_ff: ff_D port map(D => SIGN_out_stage1, CLK => clk, RST => '1', Q => SIGN_out_stage1_sig)
	--isINF_stage1_ff: ff_D port map(D => isINF_stage1, CLK => clk, RST => '1', Q => isINF_stage1_sig)
	--isNaN_stage1_ff: ff_D port map(D => isNaN_stage1, CLK => clk, RST => '1', Q => isNaN_stage1_sig)
	--isZ_tab_stage1_ff: ff_D port map(D => isZ_tab_stage1, CLK => clk, RST => '1', Q => isZ_tab_stage1_sig)
	EXP_in_reg: regN generic map(N => 8) port map(load => '1', clk => clk, rst => '1', pin => EXP_in_sig, pout => EXP_in);
	EXP_neg_stage2_ff: ff_D port map(D => EXP_neg_stage2_sig, CLK => clk, RST => '1', Q => EXP_neg_stage2);
	EXP_pos_stage2_ff: ff_D port map(D => EXP_pos_stage2_sig, CLK => clk, RST => '1', Q => EXP_pos_stage2);
	SIGN_out_stage2_ff: ff_D port map(D => SIGN_out_stage2_sig, CLK => clk, RST => '1', Q => SIGN_out_stage2);
	SIG_in_reg: regN generic map(N => 28) port map(load => '1', clk => clk, rst => '1', pin => SIG_in_sig, pout => SIG_in);
	isINF_stage2_ff: ff_D port map(D => isINF_stage2_sig, CLK => clk, RST => '1', Q => isINF_stage2);
	isNaN_stage2_ff: ff_D port map(D => isNaN_stage2_sig, CLK => clk, RST => '1', Q => isNaN_stage2);
	isZ_tab_stage2_ff: ff_D port map(D => isZ_tab_stage2_sig, CLK => clk, RST => '1', Q => isZ_tab_stage2);

end struct;

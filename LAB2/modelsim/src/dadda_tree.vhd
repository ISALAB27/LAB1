library ieee;
use ieee.std_logic_1164.all;
use work.matrix_array_type.all;

entity dadda_tree is
	port(	S, S_neg	: in std_logic_vector(11 downto 0);
			PP0			: in std_logic_vector(24 downto 0);
			PP1			: in std_logic_vector(24 downto 0);
			PP2			: in std_logic_vector(24 downto 0);
			PP3			: in std_logic_vector(24 downto 0);
			PP4			: in std_logic_vector(24 downto 0);
			PP5			: in std_logic_vector(24 downto 0);
			PP6			: in std_logic_vector(24 downto 0);
			PP7			: in std_logic_vector(24 downto 0);
			PP8			: in std_logic_vector(24 downto 0);
			PP9			: in std_logic_vector(24 downto 0);
			PP10		: in std_logic_vector(24 downto 0);
			PP11		: in std_logic_vector(24 downto 0);
			PP12		: in std_logic_vector(23 downto 0);
			P 			: out std_logic_vector(47 downto 0));
end entity;

architecture beh of dadda_tree is

	component half_adder is
		port (	x, y 	: in std_logic;
				sum 	: out std_logic;
				cout 	: out std_logic);
	end component;
	
	component full_adder is
		port (	x, y, cin 	: in std_logic;
				sum 		: out std_logic;
				cout 		: out std_logic);
	end component;

-- ROWS signals
signal row_carry		: matrix_std_logic(0 to 12, 0 to 26);
signal row_sum 			: matrix_std_logic(0 to 12, 0 to 26);

-- ROW0 carry 26 temp
signal row0_carry_temp	: std_logic;

-- PP array
signal PP 				: array_slv_25(0 to 12);

begin
	
	PP <= ( PP0, PP1, PP2, PP3, PP4, PP5, PP6, PP7, PP8, PP9, PP10, PP11, '0' & PP12 );
	
	-- ROW0
	row_carry(0, 0) <= S(0);
	P(0) <= row_sum(0, 0);
	P(1) <= row_sum(0, 1);
	GEN_ROW0: for I in 0 to 24 generate
		HA0X : half_adder port map(x => PP(0)(I), y => row_carry(0, I), sum => row_sum(0, I), cout => row_carry(0, I+1));
	end generate GEN_ROW0;
	--FA025 : entity work.full_adder(low_power) port map(x => S_neg(0), y => '1', cin => row_carry(0, 25), sum => row_sum(0, 25), cout => row_carry(0, 26));
	HA025 : half_adder port map(x => S(0), y => row_carry(0, 25), sum => row_sum(0, 25), cout => row0_carry_temp);
	row_sum(0, 26) <= S_neg(0) nor row0_carry_temp;
	row_carry(0, 26) <= not row_sum(0, 26);
	
	-- ROW1 to ROW11
	GEN_ROW1to11: for I in 1 to 11 generate
		row_carry(I, 0) <= S(I);
		P(I*2) <= row_sum(I, 0);
		P((I*2)+1) <= row_sum(I, 1);
		GEN_ROWX: for J in 0 to 24 generate
			FAXX : full_adder port map(x => PP(I)(J), y => row_sum(I-1, J+2), cin => row_carry(I, J), sum => row_sum(I, J), cout => row_carry(I, J+1));
		end generate GEN_ROWX;
		FAX25 : full_adder port map(x => S_neg(I), y => row_carry(I-1, 26), cin => row_carry(I, 25), sum => row_sum(I, 25), cout => row_carry(I, 26));
		GEN_INVX: if I < 11 generate
			row_sum(I, 26) <= NOT row_carry(I, 26);
		end generate GEN_INVX;
	end generate GEN_ROW1to11;
	
	-- ROW12
	HA120 : half_adder port map(x => PP(12)(0), y => row_sum(11, 2), sum => row_sum(12, 0), cout => row_carry(12, 1));
	P(24) <= row_sum(12, 0);
	GEN_ROW12: for I in 1 to 23 generate
		FA12X : full_adder port map(x => PP(12)(I), y => row_sum(11, I+2), cin => row_carry(12, I), sum => row_sum(12, I), cout => row_carry(12, I+1));
		P(I+24) <= row_sum(12, I);
	end generate GEN_ROW12;
	--HA1225 : half_adder port map(x => row_carry(12, 25), y => row_sum(11, 26), sum => row_sum(12, 25), cout => row_carry(12, 26));
	
end architecture;

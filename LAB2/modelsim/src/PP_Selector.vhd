library ieee;
use ieee.std_logic_1164.all;
use work.matrix_array_type.all;

entity PP_Selector is
	port(	A 			: in std_logic_vector (23 downto 0);
			S 			: in std_logic_vector (11 downto 0);
			S_neg 		: in std_logic_vector (11 downto 0);
			Shift 		: in std_logic_vector (11 downto 0);
			Shift_neg 	: in std_logic_vector (11 downto 0);
			Zero 		: in std_logic_vector (12 downto 0);
			PP0 		: out std_logic_vector (24 downto 0);
			PP1 		: out std_logic_vector (24 downto 0);
			PP2 		: out std_logic_vector (24 downto 0);
			PP3 		: out std_logic_vector (24 downto 0);
			PP4 		: out std_logic_vector (24 downto 0);
			PP5 		: out std_logic_vector (24 downto 0);
			PP6 		: out std_logic_vector (24 downto 0);
			PP7			: out std_logic_vector (24 downto 0);
			PP8 		: out std_logic_vector (24 downto 0);
			PP9 		: out std_logic_vector (24 downto 0);
			PP10 		: out std_logic_vector (24 downto 0);
			PP11 		: out std_logic_vector (24 downto 0);
			PP12 		: out std_logic_vector (23 downto 0));
end entity;


architecture beh of PP_Selector is

-- A complemented
signal A_neg 		: std_logic_vector (23 downto 0);

-- Rows inputs
signal Ax_carry_neg : matrix_std_logic (0 to 12, 0 to 24);

-- PP array
signal PP 			: array_slv_25(0 to 12);

begin

	A_neg <= not A;
	
	-- ROWS FROM 0 TO 11
	--GEN_PP: for I in 0 to 11 generate
	--	Ax_carry(I, 0) <= S(I);
	--	-- LSB and INTERMEDIATE
	--	GEN_ROW: for J in 0 to 23 generate
	--		Ax_carry(I, J+1) <= (A(J) nor S(I)) nor (A_neg(J) nor S_neg(I));
	--		PP(I)(J) <= ((Ax_carry(I, J+1) nor Shift(I)) or (Shift_neg(I) nor Ax_carry(I, J))) nor Zero(I);
	--	end generate GEN_ROW;
	--	-- MSB
	--	PP(I)(24) <= ((S(I) nor Shift(I)) or (Shift_neg(I) nor Ax_carry(I, 24))) nor Zero(I);
	--end generate GEN_PP;

	-- ROWS FROM 0 TO 11
	GEN_PPX: for I in 0 to 11 generate
		-- LSB
		Ax_carry_neg(I, 0) <= S_neg(I);
		-- INTERMEDIATE
		GEN_ROWX: for J in 0 to 23 generate
			Ax_carry_neg(I, J+1) <= (A_neg(J) nor S(I)) nor (A(J) nor S_neg(I));
			PP(I)(J) <= ((Ax_carry_neg(I, J+1) nor Shift(I)) nor (Shift_neg(I) nor Ax_carry_neg(I, J))) nor Zero(I);
		end generate GEN_ROWX;
		-- MSB
		PP(I)(24) <= ((S_neg(I) nor Shift(I)) nor (Shift_neg(I) nor Ax_carry_neg(I, 24))) nor Zero(I);
	end generate GEN_PPX;
	-- PP12
	GEN_ROW12: for I in 0 to 23 generate
		PP(12)(I) <= A_neg(I) nor Zero(12);
	end generate GEN_ROW12;
	
	PP0  <= PP(0);
	PP1  <= PP(1);
	PP2  <= PP(2);
	PP3  <= PP(3);
	PP4  <= PP(4);
	PP5  <= PP(5);
	PP6  <= PP(6);
	PP7  <= PP(7);
	PP8  <= PP(8);
	PP9  <= PP(9);
	PP10 <= PP(10);
	PP11 <= PP(11);
	PP12 <= PP(12)(23 downto 0);

end architecture;

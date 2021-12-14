LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY wrapped IS
   PORT( 
      FP_A : IN     std_logic_vector (31 DOWNTO 0);
      FP_B : IN     std_logic_vector (31 DOWNTO 0);
      CLK  : IN     std_logic;
      RST  : IN     std_logic;
      FP_Z : OUT    std_logic_vector (31 DOWNTO 0)
   );

END wrapped ;

architecture beh of wrapped is
   component FPmul is
      PORT( 
         FP_A : IN     std_logic_vector (31 DOWNTO 0);
         FP_B : IN     std_logic_vector (31 DOWNTO 0);
         clk  : IN     std_logic;
         FP_Z : OUT    std_logic_vector (31 DOWNTO 0)
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

signal output_data_A, output_data_B : std_logic_vector(31 downto 0);

begin

REGN_A : regN generic map (N => 32) port map (load => '1', clk => CLK, rst => RST, pin => FP_A, pout => output_data_A);
REGN_B : regN generic map (N => 32) port map (load => '1', clk => CLK, rst => RST, pin => FP_B, pout => output_data_B);

mult: entity work.fpmul(pipeline)
   port map (
      FP_A => output_data_A,
      FP_B => output_data_B,
      clk => clk,
      FP_Z => FP_Z
   );

end architecture;
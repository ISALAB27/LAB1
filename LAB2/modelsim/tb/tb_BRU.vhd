LIBRARY ieee; 
USE ieee.std_logic_1164.all; 

ENTITY tb_BRU IS  
END ENTITY;

 
ARCHITECTURE tb_arch OF tb_BRU IS

  SIGNAL X        :  std_logic_vector(2 downto 0)  ; 
  SIGNAL S        : STD_LOGIC;
  SIGNAL SHIFT    : STD_LOGIC;
  SIGNAL S_neg        : STD_LOGIC;
  SIGNAL SHIFT_neg    : STD_LOGIC;
  SIGNAL Zero     : STD_LOGIC;

 COMPONENT BRU  
    port(
         X : in STD_LOGIC_VECTOR(2 downto 0);    
	 S : out STD_LOGIC;
         Shift : out STD_LOGIC;
         S_neg : out STD_LOGIC;
         Shift_neg : out STD_LOGIC;
         Zero : out STD_LOGIC
	 );	 
  END COMPONENT ; 
BEGIN
  DUT  : BRU  
    PORT MAP ( 
      X   => X  ,
      S   => S  ,
      SHIFT   => SHIFT ,
      S_neg   => S_neg  ,
      SHIFT_neg   => SHIFT_neg ,
      Zero   => Zero ) ; 

  Process
	Begin
	 X      <= "000"  ;
	wait for 10 ns ;
	 X      <= "001"  ;
	wait for 10 ns ;
         X      <= "010"  ;
	wait for 10 ns ;
         X      <= "011"  ;
	wait for 10 ns ;
         X      <= "100"  ;
	wait for 10 ns ;
         X      <= "101"  ;
	wait for 10 ns ;
         X      <= "110"  ;
	wait for 10 ns ;
         X      <= "111"  ;
	wait for 10 ns ;
	wait;
 End Process; 
 
END ARCHITECTURE;

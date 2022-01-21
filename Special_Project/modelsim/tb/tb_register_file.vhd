LIBRARY ieee; 
USE ieee.std_logic_1164.all; 

ENTITY tb_register_file IS  
generic (N: integer 	:= 32);
END ENTITY;

 
ARCHITECTURE tb_arch OF tb_register_file IS


  SIGNAL read_reg1 : std_logic_vector (4 downto 0);
  SIGNAL read_reg2 : std_logic_vector (4 downto 0);
  SIGNAL write_reg : std_logic;  --write_enable
  SIGNAL write_data: std_logic_vector (N-1 downto 0);
  SIGNAL reg_write : std_logic_vector (4 downto 0); --write address
  SIGNAL read_data1: std_logic_vector (N-1 downto 0);
  SIGNAL read_data2: std_logic_vector (N-1 downto 0);

 COMPONENT register_file is
	generic (N : integer);
	port(
	read_reg1 : in std_logic_vector (4 downto 0);
	read_reg2 : in std_logic_vector (4 downto 0);
	write_reg : in std_logic;  --write_enable
	write_data: in std_logic_vector (N-1 downto 0);
	reg_write : in std_logic_vector (4 downto 0); --write address
	read_data1: out std_logic_vector (N-1 downto 0);
	read_data2: out std_logic_vector (N-1 downto 0)
	); 
  END COMPONENT ; 

BEGIN
  DUT  : register_file generic map (N => N)
	PORT MAP ( 
	read_reg1  => read_reg1  ,
	read_reg2   => read_reg2  ,
	write_reg   => write_reg ,
	write_data   => write_data ,
	reg_write   => reg_write ,
	read_data1   => read_data1 ,
	read_data2   => read_data2
 ) ; 

  Process
	Begin
	-- write sequence
	read_reg1 <= "00000";
	read_reg2 <= "00001";
	write_data <= X"00000001";
	reg_write <= "00000";
	write_reg <= '1';
	wait for 10 ns;
	write_data <= X"00000010";
	reg_write <= "00001";
	write_reg <= '1';
	wait for 10 ns;
	-- read sequence
	-- read_reg1 <= "00000";
	-- read_reg2 <= "00001";
	write_reg <= '0';
	-- reg_write <= "00001";
	-- write_data <= X"ffffffff";
	-- read AND write
	wait for 10 ns;
	read_reg1 <= "10000";
	read_reg2 <= "01000";
	write_reg <= '1';
	reg_write <= "10000";
	write_data <= X"0f0f0f0f";
	wait for 10 ns;
	read_reg1 <= "10000";
	read_reg2 <= "01000";
	write_reg <= '1';
	reg_write <= "01000";
	write_data <= X"f0f0f0f0";
	wait for 10 ns;
	-- sensitivity list check
	-- only reg_write changes
	read_reg1 <= "00000";
	read_reg2 <= "10000";
	write_data <= X"f0f0f0f0";
	reg_write <= "00000";
	write_reg <= '0';
	-- only write_data changes
	wait for 10 ns;
	read_reg1 <= "00000";
	read_reg2 <= "10000";
	write_data <= X"f0000000";
	reg_write <= "00000";
	write_reg <= '0';
	wait;
 End Process; 
 
END ARCHITECTURE;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_maker is
  port (
    CLK  	: in  std_logic;
	RST_n	: in  std_logic;
	END_SIM : out std_logic;
    DATA 	: out std_logic_vector(31 downto 0));
end data_maker;

architecture beh of data_maker is

signal sEndSim : std_logic;
signal END_SIM_i : std_logic_vector(0 to 10);  

begin  -- beh

  process (CLK, RST_n)
    file fp : text open read_mode is "../fp_samples.hex";
    variable ptr : line;
    variable val : std_logic_vector(31 downto 0);
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      sEndSim <= '0';
      DATA <= (others => '0');
    else
	  if (not(endfile(fp))) then
      sEndSim <= '0';
	    if CLK'event and CLK = '1' then  -- rising clock edge
          readline(fp, ptr);
          hread(ptr, val);
		      DATA <= val;
	    end if; 
	  else
		  sEndSim <= '1';   
      end if;
    end if;
  end process;

  process (CLK, RST_n)
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      END_SIM_i <= (others => '0');
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      END_SIM_i(0) <= sEndSim;
      END_SIM_i(1 to 10) <= END_SIM_i(0 to 9);
    end if;
  end process;

  END_SIM <= END_SIM_i(10); 

end beh;

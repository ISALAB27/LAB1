library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_sink is
  port (
    CLK   : in std_logic;
	RST_n : in std_logic;
    DIN   : in std_logic_vector(31 downto 0));
end data_sink;

architecture beh of data_sink is

begin  -- beh

  process (CLK)
    file res_fp : text open WRITE_MODE is "../fp_prod.hex";
    variable line_out : line;    
  begin  -- process
	if RST_n = '0' then                 -- asynchronous reset (active low)
      null;
    elsif CLK'event and CLK = '0' then  -- falling clock edge
	  hwrite(line_out, DIN);
      writeline(res_fp, line_out);
    end if;
  end process;

end beh;

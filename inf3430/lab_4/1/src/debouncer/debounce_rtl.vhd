library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture debounce_rtl of debouncer is

  constant  GOAL_VAL  : integer := 2**(cwidth-1);
  signal    count     : integer range 0 to GOAL_VAL := 0;
  
begin

  DEBOUNCE: process(clk)
  begin
    if (rising_edge(clk)) then
      if (rst = '1') then
        debounced <= '0';
      else
        if (bounced = '1') then
          if (count = GOAL_VAL) then
            debounced <= '1';
            count <= 0;
          else
            debounced <= '0';
            count <= count + 1;
          end if;
        else
          debounced <= '0';
          count <= 0; 
        end if;
      end if;
    end if;
  end process;
  
end architecture debounce_rtl;

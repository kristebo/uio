library ieee;
use ieee.std_logic_1164.all;

architecture rtl of regctrl is
begin

  -- Feed input to correct register.
  FEED_REGISTERS: process(mclk)
  begin
    if (rising_edge(mclk)) then
      if (reset = '1') then
        reg0 <= "0000";
        reg1 <= "0000";
        reg2 <= "0000";
        reg3 <= "0000";
      elsif (load = '1') then
        case sel is
          when "00"   => reg0 <= inp;
          when "01"   => reg1 <= inp;
          when "10"   => reg2 <= inp;
          when "11"   => reg3 <= inp;
          when others => null;
        end case;
      end if;
    end if;
  end process FEED_REGISTERS;
  
end rtl;
          

  
  
  
  
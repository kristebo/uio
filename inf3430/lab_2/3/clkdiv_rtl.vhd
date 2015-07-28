library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of clkdiv is

  signal clk : std_logic := '0';

begin

  -- reduce the frequency of mclk from 50MHz to 400Hz
  REDUCE_FREQUENCY: process(mclk)
    variable count : integer range 1 to 62500 := 1;
  begin
    if (rising_edge(mclk)) then
      if (count = 62500) then
        count := 1;
        clk <= not clk;
      else
        count := count + 1;
      end if;
    end if;
  end process;
  
  rclk <= clk;
  
end rtl;  
  
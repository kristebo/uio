library ieee;
use ieee.std_logic_1164.all;

entity clkdiv is
  port (
    rst       : in  std_logic;  -- reset
    mclk      : in  std_logic;  -- master clock
    mclk_div  : out std_logic   -- master clock div. by 128
  );
end clkdiv;
library ieee;
use ieee.std_logic_1164.all;

entity rstsynch is
  port (
    arst      : in  std_logic;  -- asynch reset
    mclk      : in  std_logic;  -- master clock
    mclk_div  : in  std_logic;  -- master clock div. by 128
    rst       : out std_logic;  -- synch reset master clock
    rst_div   : out std_logic   -- synch reset div. by 128
  );
end rstsynch;
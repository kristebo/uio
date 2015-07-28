library ieee;
use ieee.std_logic_1164.all;

entity cru is
  port (
    arst      : in  std_logic;  -- asynch reset
    refclk    : in  std_logic;  -- reference clock
    rst       : out std_logic;  -- synchronized arst for mclk
    rst_div   : out std_logic;  -- synchronized arst for mclk_div
    mclk      : out std_logic;  -- master clock
    mclk_div  : out std_logic   -- master clock div. by 128
  );
end cru;

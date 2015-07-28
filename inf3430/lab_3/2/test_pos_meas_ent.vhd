library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_pos_meas is
  port (
    rst       : in  std_logic;
    clk       : in  std_logic;
    sync_rst  : in  std_logic;
    btn0      : in  std_logic;
    btn1      : in  std_logic;
    a         : in  std_logic;
    b         : in  std_logic;
    force_cw  : out std_logic;
    force_ccw : out std_logic;
    pos       : out signed(7 downto 0)
  );
end test_pos_meas;
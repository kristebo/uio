library ieee;
use ieee.std_logic_1164.all;

entity clock is
  port
  (
    mclk          : in  std_logic;
    reset         : in  std_logic;
    start         : in  std_logic;
    stop          : in  std_logic;
    abcdefgdec_n  : out std_logic_vector(7 downto 0);
    a_n           : out std_logic_vector(3 downto 0));
end clock;
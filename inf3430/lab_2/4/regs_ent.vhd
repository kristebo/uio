library ieee;
use ieee.std_logic_1164.all;

entity regs is
  port
  (
    bt0             : in  std_logic;
    bt1             : in  std_logic;
    mclk            : in  std_logic;
    sw              : in  std_logic_vector(3 downto 0);
    sw6             : in  std_logic;
    sw7             : in  std_logic;
    abcdefgdec_n    : out std_logic_vector(7 downto 0);
    a_n             : out std_logic_vector(3 downto 0));
end regs;
    
    
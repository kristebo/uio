library ieee;
use ieee.std_logic_1164.all;

entity regctrl is
  port
  (
    inp   : in  std_logic_vector(3 downto 0);
    load  : in  std_logic;
    mclk  : in  std_logic;
    reset : in  std_logic;
    sel   : in  std_logic_vector(1 downto 0);
    reg0  : out std_logic_vector(3 downto 0);
    reg1  : out std_logic_vector(3 downto 0);
    reg2  : out std_logic_vector(3 downto 0);
    reg3  : out std_logic_vector(3 downto 0)
  );
end regctrl;
    
    
    
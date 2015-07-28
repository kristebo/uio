library ieee;
use ieee.std_logic_1164.all;

entity seg7ctrl is
  port
  (
    mclk          : in  std_logic;                    -- 50MHz
    reset         : in  std_logic;                    -- asynchronous
    d3            : in  std_logic_vector(3 downto 0); -- disp 3
    d2            : in  std_logic_vector(3 downto 0); -- disp 2
    d1            : in  std_logic_vector(3 downto 0); -- disp 1
    d0            : in  std_logic_vector(3 downto 0); -- disp 0
    dec           : in  std_logic_vector(3 downto 0); -- decimal point
    abcdefgdec_n  : out std_logic_vector(7 downto 0); -- 7seg code
    a_n           : out std_logic_vector(3 downto 0)  -- anode control
  );
end entity seg7ctrl;
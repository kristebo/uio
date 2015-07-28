-- Implements the truth table as specified in task 2. The combinational
-- logic was simplified by Karnaugh maps. 

library IEEE;
use IEEE.std_logic_1164.all;

entity seg7decoder is 
  port
  (
    dec          : in  std_logic;
    hex          : in  std_logic_vector(3 downto 0);
    abcdefg_dec  : out std_logic_vector(7 downto 0)
  );
end seg7decoder;
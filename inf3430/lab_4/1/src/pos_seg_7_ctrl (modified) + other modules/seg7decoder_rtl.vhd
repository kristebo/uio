library ieee;
use ieee.std_logic_1164.all;

architecture rtl of seg7decoder is
begin

  -- a
  abcdefg_dec(7) <=     ((not hex(3)) and (not hex(2)) and (not hex(1))
                          and hex(0))
                    or  ((not hex(3)) and hex(2) and (not hex(1)) and
                         (not hex(0)))
                    or  (hex(3) and hex(2) and (not hex(1)) and hex(0))
                    or  (hex(3) and (not hex(2)) and hex(1) and hex(0));
                    
  -- b
  abcdefg_dec(6) <=     ((not hex(3)) and hex(2) and (not hex(1))
                          and hex(0))
                    or  (hex(3) and hex(1) and hex(0))
                    or  (hex(2) and hex(1) and (not hex(0)))
                    or  (hex(3) and hex(2) and (not hex(0)));
                 
  -- c
  abcdefg_dec(5) <=     ((not hex(3)) and (not hex(2)) and hex(1)
                          and (not hex(0)))
                    or  (hex(3) and hex(2) and hex(1))
                    or  (hex(3) and hex(2) and (not hex(0)));
                    
  -- d
  abcdefg_dec(4) <=     ((not hex(3)) and hex(2) and (not hex(1))
                          and (not hex(0)))
                    or  (hex(3) and (not hex(2)) and hex(1)
                         and (not hex(0)))
                    or  (hex(2) and hex(1) and hex(0))
                    or  ((not hex(2)) and (not hex(1)) and hex(0));
                    
  -- e
  abcdefg_dec(3) <=     ((not hex(3)) and hex(2) and (not hex(1)))
                    or  ((not hex(2)) and (not hex(1)) and hex(0))
                    or  ((not hex(3)) and hex(0));
                    
  -- f
  abcdefg_dec(2) <=     (hex(3) and hex(2) and (not hex(1)) and hex(0))
                    or  ((not hex(3)) and (not hex(2)) and hex(0))
                    or  ((not hex(3)) and (not hex(2)) and hex(1))
                    or  ((not hex(3)) and hex(1) and hex(0));
                    
  -- g
  abcdefg_dec(1) <=     ((not hex(3)) and hex(2) and hex(1) and hex(0))
                    or  (hex(3) and hex(2) and (not hex(1))
                         and (not hex(0)))
                    or  ((not hex(3)) and (not hex(2)) and (not hex(1)));
                    
  -- dec
  abcdefg_dec(0) <= not dec;
                    
  end architecture rtl;
                               
                      
    
  
  
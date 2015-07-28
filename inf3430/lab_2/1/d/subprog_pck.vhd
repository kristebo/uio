library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package subprog_pck is
  function comp_par(indata : std_logic_vector; parity : std_logic) return std_logic;
  function comp_par(indata : unsigned; parity : std_logic) return std_logic;
end subprog_pck;

package body subprog_pck is

  function comp_par(indata : std_logic_vector; parity : std_logic) return std_logic is
  	variable parity1  : std_logic := parity;
  begin
    for i in indata'range loop
      if indata(i) = '1' then
        parity1 := not parity1;
      end if;
    end loop;
    return parity1;
  end function comp_par;
 
  function comp_par(indata : unsigned; parity : std_logic) return std_logic is
  	variable parity1 : std_logic := parity;
  begin
    for j in indata'range loop
      parity1 := parity1 xor indata(j);
    end loop;
    return parity1;
  end function comp_par;
  
end package body;
  
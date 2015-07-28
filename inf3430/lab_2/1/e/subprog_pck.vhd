library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package subprog_pck is
  procedure comp_par (indata : in std_logic_vector(15 downto 0); variable parity : inout std_logic);
  procedure comp_par (indata : in unsigned(15 downto 0); variable parity : inout std_logic);
end subprog_pck;

package body subprog_pck is

  procedure comp_par (indata : in std_logic_vector(15 downto 0); variable parity : inout std_logic) is
  begin
    for i in indata'range loop
      if indata(i) = '1' then
        parity := not parity;
      end if;
    end loop;
  end procedure comp_par;
  
  procedure comp_par (indata : in unsigned(15 downto 0); variable parity : inout std_logic) is
  begin
    for j in indata'range loop
      parity := parity xor indata(j);
    end loop;
  end procedure comp_par;
  
end package body;
  
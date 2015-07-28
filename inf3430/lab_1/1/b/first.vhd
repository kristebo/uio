library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FIRST is 
  port
  (
    CLK        : in  std_logic; -- Klokke fra bryter CLK1/INP1
    RESET      : in  std_logic; -- Global Asynkron Reset
    LOAD       : in  std_logic; -- Synkron reset
    UP         : in  std_logic; -- Synkron telleretningsendrer
    INP        : in  std_logic_vector(3 downto 0); -- Startverdi
    COUNT      : out std_logic_vector(3 downto 0); -- Telleverdi
    MAX_COUNT  : out std_logic  -- Viser telleverdi 
  );
end FIRST;

--  Arkitekturen under beskriver en 4-bits opp-teller.  Når telleren når
--  maksimal verdi går signalet MAX_COUNT aktivt.

architecture MY_FIRST_ARCH of FIRST is 
  signal COUNT_I : unsigned(3 downto 0);
  
begin
  COUNTER :
  process (RESET,CLK)
  begin
    if(RESET  = '1') then
      COUNT_I <= "0000";
	  elsif rising_edge(CLK) then  
      -- Synkron reset
      if LOAD = '1' then
        COUNT_I <= unsigned(INP);
      elsif UP = '1' then   
        COUNT_I <= COUNT_I + 1;
      else
        COUNT_I <= COUNT_I - 1;
      end if; 
    end if; 
  end process COUNTER;

  COUNT <= std_logic_vector(COUNT_I);
  
  -- Concurrent signal assignment
  MAX_COUNT <= '1' when COUNT_I = "1111" else '0'; 

end MY_FIRST_ARCH;

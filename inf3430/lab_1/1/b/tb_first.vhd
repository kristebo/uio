Library IEEE;
use IEEE.Std_Logic_1164.all;

Entity TEST_FIRST is
  -- generic parameters
  -- port list
  -- Entiteten for en testbench er gjerne tom
end TEST_FIRST;

architecture TESTBENCH of TEST_FIRST is
  -- Område for deklarasjoner
  -- Komponent deklaration
  
  Component FIRST 
    port
    (
      CLK        : in  std_logic; -- Klokke fra bryter CLK1/INP1
      RESET      : in  std_logic; -- Global Asynkron Reset
      LOAD       : in  std_logic; -- Synkron reset
      UP         : in  std_logic; -- Synkron telleretningsendrer
      INP        : in  std_logic_vector(3 downto 0); -- Startverdi
      COUNT      : out std_logic_vector(3 downto 0); -- Telleverdi
      MAX_COUNT  : out std_logic -- Viser telleverdi 
    );
  end Component;
  
  signal  CLK        : std_logic := '0';
  signal  RESET      : std_logic := '0';
  signal  LOAD       : std_logic := '0';
  signal  UP		 : std_logic := '1';
  signal  INP        : std_logic_vector(3 downto 0) := "0000";
  signal  COUNT      : std_logic_vector(3 downto 0);
  signal  MAX_COUNT  : std_logic;
  
  constant Half_Period : time := 10 ns;  --50Mhz klokkefrekvens
  
begin
  --Concurrent statements
  
  --Instantierer "Unit Under Test"
  UUT : FIRST
  port map
  ( 
    CLK        =>  CLK,       
    RESET      =>  RESET,  
    LOAD       =>  LOAD,
    UP         =>  UP,      
    INP        =>  INP,       
    COUNT      =>  COUNT,     
    MAX_COUNT  =>  MAX_COUNT
  );
  
  -- Definerer klokken
  CLK <= not CLK after Half_Period;
  
  STIMULI :
  process
  begin
    UP <= '1', '0' after 50 ns;
    RESET <= '1', '0' after 100 ns;
    INP <= "1010" after Half_Period*12;
    wait for 2*Half_Period*16;
    LOAD <= '1', '0' after 2*Half_Period;
    wait;
  end process;           
  
end TESTBENCH;

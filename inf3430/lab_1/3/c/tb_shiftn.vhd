library ieee;
use ieee.std_logic_1164.all;

entity TB_SHIFTN is
  -- empty
end TB_SHIFTN;

architecture TESTBENCH of TB_SHIFTN is

  component SHIFTN is
    generic (size : integer := 4);                           -- customizable
    port (rst_n, mclk, din : in std_logic;
          dout : inout std_logic_vector((size-1) downto 0)
         );
  end component;
  
  -- signals
  signal rst_n   : std_logic;
  signal mclk    : std_logic := '0';
  signal din     : std_logic;
  signal dout    : std_logic_vector(3 downto 0) := (others => '0');
  
  -- constants
  constant half_period : time := 10 ns; -- 50 MHz clock
  
begin
  -- UUT instantiation
  UUT : SHIFTN
  port map
  (
    rst_n => rst_n, mclk => mclk,
    din => din, dout => dout);
    
  -- clock process
  mclk <= not mclk after half_period;
  
  process
  begin
    din <= '0';
    wait for 20 ns;
    din <= '1';
    wait for 20 ns;
    din <= '0';
    wait;
  end process;
  
end TESTBENCH;
  
  
  
  
  
  
      


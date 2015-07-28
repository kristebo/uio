library ieee;
use ieee.std_logic_1164.all;

entity tb_debounce is
  -- empty
end tb_debounce;

architecture beh of tb_debounce is

  component debouncer is
    port (rst :  in std_logic;
          clk :   in std_logic;
          bounced : in std_logic;
          debounced : in std_logic);
  end component debouncer;
          
  signal rst : std_logic;
  signal clk : std_logic := '0';
  signal bounced : std_logic;
  signal debounced : std_logic;
  
begin

  UUT : entity work.debouncer(debounce_rtl)
    generic map (2)
    port map (rst => rst,
              clk => clk,
              bounced => bounced,
              debounced => debounced);
              
  -- stimuli
  clk <= not clk after 10 ns;
  
  rst <= '0';
  bounced <= '0', '1' after 10 ns,
             '0' after 25 ns,
             '1' after 70 ns,
             '0' after 150 ns,
             '1' after 155 ns,
             '0' after 200 ns,
             '1' after 260 ns;
             
end beh;
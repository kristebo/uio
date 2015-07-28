library ieee;
use ieee.std_logic_1164.all;

entity tb_clock is
  -- empty
end tb_clock;

architecture beh of tb_clock is

  component clock is
    port  (mclk         : in  std_logic;
           reset        : in  std_logic;
           start        : in  std_logic;
           stop         : in  std_logic;
           abcdefgdec_n : out std_logic_vector(7 downto 0);
           a_n          : out std_logic_vector(3 downto 0));
  end component clock;
  
  component seg7model is
    port  (a_n          : in  std_logic_vector(3 downto 0);
           abcdefgdec_n : in  std_logic_vector(7 downto 0);
           disp3        : out  std_logic_vector(3 downto 0);
           disp2        : out  std_logic_vector(3 downto 0);
           disp1        : out  std_logic_vector(3 downto 0);
           disp0        : out  std_logic_vector(3 downto 0));
  end component seg7model;
  
  signal mclk         : std_logic;
  signal reset        : std_logic;
  signal start        : std_logic;
  signal stop         : std_logic;
  signal abcdefgdec_n : std_logic_vector(7 downto 0);
  signal a_n          : std_logic_vector(3 downto 0);
  signal disp3        : std_logic_vector(3 downto 0);
  signal disp2        : std_logic_vector(3 downto 0);
  signal disp1        : std_logic_vector(3 downto 0);
  signal disp0        : std_logic_vector(3 downto 0);
  
begin

  UUT : entity work.clock(rtl)
    port map  (mclk         => mclk,
               reset        => reset,
               start        => start,
               stop         => stop,
               abcdefgdec_n => abcdefgdec_n,
               a_n          => a_n);
               
  S7M : seg7model
    port map  (a_n          => a_n,
               abcdefgdec_n => abcdefgdec_n,
               disp3        => disp3,
               disp2        => disp2,
               disp1        => disp1,
               disp0        => disp0);
               
   -- clock stimuli (50MHz) 
  process
  begin
    mclk <= '0';
    wait for 10 ns;
    mclk <= '1';
    wait for 10 ns;
  end process;
  
  start <= '0', '1' after 2.5 ms, '0' after 5 ms, '1' after 35 sec;
  stop <= '0', '1' after 20 sec;
  reset <= '0', '1' after 30 sec;
  
end beh;
  
  
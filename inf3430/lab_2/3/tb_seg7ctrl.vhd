library ieee;
use ieee.std_logic_1164.all;

entity tb_seg7ctrl is
  -- empty
end tb_seg7ctrl;

architecture beh of tb_seg7ctrl is
 
  component seg7ctrl is
    port  (mclk         : in  std_logic;
           reset        : in  std_logic;
           d3           : in  std_logic_vector(3 downto 0);
           d2           : in  std_logic_vector(3 downto 0);
           d1           : in  std_logic_vector(3 downto 0);
           d0           : in  std_logic_vector(3 downto 0);
           dec          : in  std_logic_vector(3 downto 0);
           abcdefgdec_n : out std_logic_vector(7 downto 0);
           a_n          : out std_logic_vector(3 downto 0));
  end component seg7ctrl;
  
  component seg7model is
    port  (a_n          : in  std_logic_vector(3 downto 0);
           abcdefgdec_n : in  std_logic_vector(7 downto 0);
           disp3        : out  std_logic_vector(3 downto 0);
           disp2        : out  std_logic_vector(3 downto 0);
           disp1        : out  std_logic_vector(3 downto 0);
           disp0        : out  std_logic_vector(3 downto 0));
  end component seg7model;
           
  signal  mclk          : std_logic := '0';
  signal  reset         : std_logic;
  signal  d3            : std_logic_vector(3 downto 0);
  signal  d2            : std_logic_vector(3 downto 0);
  signal  d1            : std_logic_vector(3 downto 0);
  signal  d0            : std_logic_vector(3 downto 0);
  signal  disp3         : std_logic_vector(3 downto 0);
  signal  disp2         : std_logic_vector(3 downto 0);
  signal  disp1         : std_logic_vector(3 downto 0);
  signal  disp0         : std_logic_vector(3 downto 0);
  signal  dec           : std_logic_vector(3 downto 0);
  signal  abcdefgdec_n  : std_logic_vector(7 downto 0);
  signal  a_n           : std_logic_vector(3 downto 0);

begin

  UUT : entity work.seg7ctrl(Structure)
    port map  (mclk         => mclk,
               reset        => reset,
               d3           => d3,
               d2           => d2,
               d1           => d1,
               d0           => d0,
               dec          => dec,
               abcdefgdec_n => abcdefgdec_n,
               a_n          => a_n);
               
  S7M : seg7model
    port map  (a_n => a_n,
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
  
  dec   <= "0000", "0010" after 15 ms;
  
  reset <= '0', '1' after 17.5 ms, '0' after 21 ms;
  
  d3 <= "0001", "0010" after 2.5 ms, "0011" after 5 ms,
        "0100" after 7.5 ms, "0101" after 10 ms,
        "0110" after 12.5 ms, "0111" after 15 ms,
        "1000" after 17.5 ms, "1001" after 20 ms,
        "1010" after 22.5 ms, "1011" after 25 ms,
        "1100" after 27.5 ms, "1101" after 30 ms,
        "1110" after 32.5 ms, "1111" after 35 ms;
        
  d2 <= "0001", "0010" after 2.5 ms, "0011" after 5 ms,
        "0100" after 7.5 ms, "0101" after 10 ms,
        "0110" after 12.5 ms, "0111" after 15 ms,
        "1000" after 17.5 ms, "1001" after 20 ms,
        "1010" after 22.5 ms, "1011" after 25 ms,
        "1100" after 27.5 ms, "1101" after 30 ms,
        "1110" after 32.5 ms, "1111" after 35 ms;
        
  d1 <= "0001", "0010" after 2.5 ms, "0011" after 5 ms,
        "0100" after 7.5 ms, "0101" after 10 ms,
        "0110" after 12.5 ms, "0111" after 15 ms,
        "1000" after 17.5 ms, "1001" after 20 ms,
        "1010" after 22.5 ms, "1011" after 25 ms,
        "1100" after 27.5 ms, "1101" after 30 ms,
        "1110" after 32.5 ms, "1111" after 35 ms;
        
  d0 <= "0001", "0010" after 2.5 ms, "0011" after 5 ms,
        "0100" after 7.5 ms, "0101" after 10 ms,
        "0110" after 12.5 ms, "0111" after 15 ms,
        "1000" after 17.5 ms, "1001" after 20 ms,
        "1010" after 22.5 ms, "1011" after 25 ms,
        "1100" after 27.5 ms, "1101" after 30 ms,
        "1110" after 32.5 ms, "1111" after 35 ms;
  
end architecture beh;

library ieee;
use ieee.std_logic_1164.all;

entity tb_regs is
  -- empty
end tb_regs;

architecture beh of tb_regs is

  component regs is
    port  (bt0          : in  std_logic;
           bt1          : in  std_logic;
           mclk         : in  std_logic;
           sw           : in  std_logic_vector(3 downto 0);
           sw6          : in  std_logic;
           sw7          : in  std_logic;
           abcdefgdec_n : out std_logic_vector(7 downto 0);
           a_n          : out std_logic_vector(3 downto 0));
  end component regs;
  
  signal  bt0           : std_logic;
  signal  bt1           : std_logic;
  signal  mclk          : std_logic;
  signal  sw            : std_logic_vector(3 downto 0);
  signal  sw6           : std_logic;
  signal  sw7           : std_logic;
  signal  
  : std_logic_vector(7 downto 0);
  signal  a_n           : std_logic_vector(3 downto 0);
  
begin
  
  UUT : entity work.regs(str)
    port map  (bt0          =>  bt0,
               bt1          =>  bt1,
               mclk         =>  mclk,
               sw           =>  sw,
               sw6          =>  sw6,
               sw7          =>  sw7,
               abcdefgdec_n =>  abcdefgdec_n,
               a_n          =>  a_n);
               
  -- clock stimuli (50MHz)
  process
  begin
    mclk <= '0';
    wait for 10 ns;
    mclk <= '1';
    wait for 10 ns;
  end process;
  
  sw <= "0000", "0001" after 10 ns,
        "0010" after 30 ns, "0011" after 50 ns,
        "0100" after 70 ns;
        
  bt0 <= '0', '1' after 10 ns;
  bt1 <= '0', '1' after 20 ms;
  
  sw6 <= '1', '0' after 30 ns,
         '1' after 50 ns,
         '0' after 70 ns;
  sw7 <= '1', '0' after 50 ns;
        
end beh;
  
  
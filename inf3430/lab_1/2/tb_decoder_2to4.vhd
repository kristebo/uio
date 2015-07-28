library IEEE;
use IEEE.std_logic_1164.all;

entity TB_DECODER2TO4 is
  -- empty
end TB_DECODER2TO4;

architecture TESTBENCH of TB_DECODER2TO4 is
  
  component DECODER_2TO4 is
    port (en    : in  std_logic;
          inp   : in  std_logic_vector(1 downto 0);
          outp  : out std_logic_vector(3 downto 0)
          );
  end component;
  
  -- signals
  signal en   : std_logic;
  signal inp  : std_logic_vector(1 downto 0);
  signal outp : std_logic_vector(3 downto 0);
  
begin
  
  UUT : DECODER_2TO4
  port map (en, inp, outp);
  
  process
  begin
    en <= '1', '0' after 100 ns;
    inp <= "00", "01" after 200 ns, "10" after 300 ns, "11" after 400 ns;
    wait;
  end process;

end TESTBENCH;
    


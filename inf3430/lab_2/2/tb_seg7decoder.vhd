library IEEE;
use IEEE.std_logic_1164.all;

entity tb_seg7decoder is
  -- empty
end tb_seg7decoder;

architecture beh of tb_seg7decoder is
  
  component seg7decoder is
    port (dec          : in std_logic;
          hex          : in std_logic_vector(3 downto 0);
          abcdefg_dec  : out std_logic_vector(7 downto 0));
  end component seg7decoder;
  
  signal dec          : std_logic;
  signal hex          : std_logic_vector(3 downto 0);
  signal abcdefg_dec  : std_logic_vector(7 downto 0);
  
begin

  UUT : entity work.seg7decoder(rtl)
    port map (dec         => dec,
              hex         => hex,
              abcdefg_dec => abcdefg_dec);
              
  hex <="0000", 
        "0001" after 50 ns, "0010" after 100 ns,
        "0011" after 150 ns, "0100" after 200 ns,
        "0101" after 250 ns, "0110" after 300 ns,
        "0111" after 350 ns, "1000" after 400 ns,
        "1001" after 450 ns, "1010" after 500 ns,
        "1011" after 550 ns, "1100" after 600 ns,
        "1101" after 650 ns, "1110" after 700 ns,
        "1111" after 750 ns;
  
  dec <= '0',
         '1' after 400 ns;

end architecture beh;
    

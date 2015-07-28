library IEEE;
use IEEE.std_logic_1164.all;

entity tb_seg7model is
  -- empty
end tb_seg7model;

architecture beh of tb_seg7model is
  
  component seg7model is
    port (a_n           : in  std_logic_vector(3 downto 0);
          abcdefgdec_n  : in  std_logic_vector(7 downto 0);
          disp3         : out std_logic_vector(3 downto 0);
          disp2         : out std_logic_vector(3 downto 0);
          disp1         : out std_logic_vector(3 downto 0);
          disp0         : out std_logic_vector(3 downto 0));
  end component seg7model;
  
  signal a_n          : std_logic_vector(3 downto 0);
  signal abcdefgdec_n : std_logic_vector(7 downto 0);
  signal disp3        : std_logic_vector(3 downto 0);
  signal disp2        : std_logic_vector(3 downto 0);
  signal disp1        : std_logic_vector(3 downto 0);
  signal disp0        : std_logic_vector(3 downto 0);
  
begin

  UUT : entity work.seg7model(beh)
    port map (a_n           => a_n,
              abcdefgdec_n  => abcdefgdec_n,
              disp3         => disp3,
              disp2         => disp2,
              disp1         => disp1,
              disp0         => disp0);
              
  a_n <=  "1110", "1101" after 20 ns, "1011" after 40 ns,
          "0111" after 60 ns, "1111" after 80 ns,
          "0000" after 100 ns;
 
         
  abcdefgdec_n(0) <= '1';
  
  abcdefgdec_n(7 downto 1) <= "0000001", "1001111" after 20 ns,
                              "0010010" after 40 ns,
                              "0000110" after 60 ns,
                              "1001100" after 80 ns,
                              "0100100" after 100 ns,
                              "0100000" after 120 ns,
                              "0001111" after 140 ns,
                              "0000000" after 160 ns,
                              "0000100" after 180 ns,
                              "0001000" after 200 ns,
                              "1100000" after 220 ns,
                              "0110001" after 240 ns,
                              "1000010" after 260 ns,
                              "0110000" after 280 ns,
                              "0111000" after 300 ns;

end architecture beh;
    

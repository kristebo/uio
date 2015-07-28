library ieee;
use ieee.std_logic_1164.all;

entity SHIFT8 is
  port (
    rst_n     : in  std_logic;                     -- Reset
    mclk      : in  std_logic;                     -- Clock
    din       : in  std_logic;                     -- Data in
    dout      : inout std_logic_vector(7 downto 0) -- Data out
  );
end SHIFT8;

architecture STRUCTURAL of SHIFT8 is
  component DFF is
    port (rst_n, mclk : in std_logic;
          din : in std_logic;
          dout : out std_logic
         );
  end component;
  
begin

  -- component instantiation using named association
  D0: DFF port map
      (rst_n => rst_n, mclk => mclk,
       din => din, dout => dout(0));
  D1: DFF port map
      (rst_n => rst_n, mclk => mclk,
       din => dout(0), dout => dout(1));
  D2: DFF port map
      (rst_n => rst_n, mclk => mclk,
       din => dout(1), dout => dout(2));
  D3: DFF port map
      (rst_n => rst_n, mclk => mclk,
       din => dout(2), dout => dout(3));
  D4: DFF port map
      (rst_n => rst_n, mclk => mclk,
       din => dout(3), dout => dout(4));
  D5: DFF port map
      (rst_n => rst_n, mclk => mclk,
       din => dout(4), dout => dout(5));
  D6: DFF port map
      (rst_n => rst_n, mclk => mclk,
       din => dout(5), dout => dout(6));
  D7: DFF port map
      (rst_n => rst_n, mclk => mclk,
       din => dout(6), dout => dout(7));
      
end STRUCTURAL;
  
      


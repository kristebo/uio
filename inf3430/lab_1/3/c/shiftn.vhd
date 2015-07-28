library ieee;
use ieee.std_logic_1164.all;

entity SHIFTN is
  generic (
    size      : integer := 4                              -- Customizable
  );
  port (
    rst_n     : in  std_logic;                            -- Reset
    mclk      : in  std_logic;                            -- Clock
    din       : in  std_logic;                            -- Data in
    dout      : inout std_logic_vector((size-1) downto 0) -- Data out
  );
end SHIFTN;

architecture STRUCTURAL of SHIFTN is
  component DFF is
    port (rst_n, mclk : in std_logic;
          din : in std_logic;
          dout : out std_logic
         );
  end component;
  
begin

  -- component instantiation using named association
  GEN: for i in 0 to (size-1) generate
    FIRST: if i = 0 generate
            D0: DFF port map
               (rst_n => rst_n, mclk => mclk,
                din => din, dout => dout(i));
    end generate FIRST;
    
    REST: if i > 0 generate
            DX: DFF port map
                  (rst_n => rst_n, mclk => mclk,
                   din => dout(i-1), dout => dout(i));
    end generate REST;
  end generate GEN;
  
end STRUCTURAL;
  
      


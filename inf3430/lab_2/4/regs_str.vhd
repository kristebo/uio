library ieee;
use ieee.std_logic_1164.all;

architecture str of regs is
  
  -- component for handling user input appropriately
  component regctrl is
    port (inp   : in  std_logic_vector(3 downto 0);
          load  : in  std_logic;
          mclk  : in  std_logic;
          reset : in  std_logic;
          sel   : in  std_logic_vector(1 downto 0);
          reg0  : out std_logic_vector(3 downto 0);
          reg1  : out std_logic_vector(3 downto 0);
          reg2  : out std_logic_vector(3 downto 0);
          reg3  : out std_logic_vector(3 downto 0));
  end component regctrl;
  
  -- component for decoding input to 7seg format and
  -- outputting to the displays
  component seg7ctrl is
    port (mclk          : in  std_logic;
          reset         : in  std_logic;
          d3            : in  std_logic_vector(3 downto 0);
          d2            : in  std_logic_vector(3 downto 0);
          d1            : in  std_logic_vector(3 downto 0);
          d0            : in  std_logic_vector(3 downto 0);
          dec           : in  std_logic_vector(3 downto 0);
          abcdefgdec_n  : out std_logic_vector(7 downto 0);
          a_n           : out std_logic_vector(3 downto 0));
  end component seg7ctrl;
  
  -- signals for mapping
  signal  reg0          : std_logic_vector(3 downto 0);
  signal  reg1          : std_logic_vector(3 downto 0);
  signal  reg2          : std_logic_vector(3 downto 0);
  signal  reg3          : std_logic_vector(3 downto 0);   
  
begin

  -- connecting the components to meet the structural spec
  RC: regctrl
    port map (inp           =>  sw,
              load          =>  bt0,
              mclk          =>  mclk,
              reset         =>  bt1,
              sel(0)        =>  sw6,
              sel(1)        =>  sw7,
              reg0          =>  reg0,
              reg1          =>  reg1,
              reg2          =>  reg2,
              reg3          =>  reg3);  
              
  S7C: seg7ctrl
    port map (mclk          =>  mclk,
              reset         =>  bt1,
              d3            =>  reg3,
              d2            =>  reg2,
              d1            =>  reg1,
              d0            =>  reg0,
              dec           =>  "0000",
              abcdefgdec_n  =>  abcdefgdec_n,
              a_n           =>  a_n);

end str;
              
              
  
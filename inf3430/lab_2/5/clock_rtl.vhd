library ieee;
use ieee.std_logic_1164;
use ieee.numeric_std.all;

architecture rtl of clock is

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
 
  signal  rclk    : std_logic := '0';    
  signal  num0    : unsigned(3 downto 0) := "0000";
  signal  num1    : unsigned(3 downto 0) := "0000";
  signal  num2    : unsigned(3 downto 0) := "0000";
  signal  num3    : unsigned(3 downto 0) := "0000";
  signal  stopped : boolean := true;
  signal  res     : boolean := false;
  
begin

  S7C: seg7ctrl
    port map (mclk          =>  mclk,
              reset         =>  reset,
              d3            =>  std_logic_vector(num3),
              d2            =>  std_logic_vector(num2),
              d1            =>  std_logic_vector(num1),
              d0            =>  std_logic_vector(num0),
              dec           =>  "0000",
              abcdefgdec_n  =>  abcdefgdec_n,
              a_n           =>  a_n);

  -- Make 'rclk' a 1Hz clock and check for stops, starts and resets
  process(mclk)
    variable count : integer range 1 to 25000000 := 1;
  begin
    if (rising_edge(mclk)) then
      if (stop = '1') then
        stopped <= true;
        res <= false;
      elsif (start = '1') then
        stopped <= false;
        res <= false;
      elsif (reset = '1') then
        res <= true;
        stopped <= true;
      end if;
      if (count = 25000000) then
        count := 1;
        rclk <= not rclk;
      else
        count := count + 1;
      end if;
    end if;
  end process;
            
  -- Count from 0 to 9999 with a frequency of 1Hz
  process(rclk)
 
    variable  sum         : integer range 0 to 10000  := 0;
    variable  count0      : integer range 0 to 9  := 0;
    variable  count1      : integer range 0 to 9  := 0;
    variable  count2      : integer range 0 to 9  := 0;
    variable  count3      : integer range 0 to 9  := 0;
    
  begin
    -- increment numbers
    if (rising_edge(rclk)) then
    
      -- check if in reset
      if (res) then
        count0 := 0;
        count1 := 0;
        count2 := 0;
        count3 := 0;
      end if;
      
      -- update outputs to current values
      num0 <= to_unsigned(count0, 4);
      num1 <= to_unsigned(count1, 4);
      num2 <= to_unsigned(count2, 4);
      num3 <= to_unsigned(count3, 4);
      
      -- if start (btn0) has been pressed
      if (not stopped) then
        if (count0 = 9) then -- increment second display?
          count0 := 0;
          if (count1 = 9) then -- increment third display?
            count1 := 0;
            if (count2 = 9) then -- increment fourth display?
              count2 := 0;
              if (count3 = 9) then
                count3 := 0;
              else
                count3 := count3 + 1;
              end if;
            else
              count2 := count2 + 1;
            end if;
          else
            count1 := count1 + 1;
          end if;
        else
          count0 := count0 + 1;
        end if;
      end if;
    end if;
  end process;
        
end rtl;
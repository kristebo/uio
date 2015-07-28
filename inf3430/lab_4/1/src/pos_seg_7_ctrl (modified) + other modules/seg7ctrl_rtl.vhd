library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of seg7ctrl is

  -- Used for mapping current input to 7-seg compatible format.
  component seg7decoder is
    port (dec         : in  std_logic;
          hex         : in  std_logic_vector(3 downto 0);
          abcdefg_dec : out std_logic_vector(7 downto 0));
  end component seg7decoder;
  
  signal ag_dec : std_logic_vector(7 downto 0);
  signal disp   : std_logic_vector(3 downto 0);
  signal dp     : std_logic;
	signal Hz400  : std_logic;
   
begin

  -- Decode current input so it can be displayed on 7-seg.
  S7D: seg7decoder
    port map (dec         => dp,
              hex         => disp,
              abcdefg_dec => ag_dec);
              
  -- Time-Division Multiplexing of the displays.
  -- Each display has an update frequency of 100Hz.
  TDM: process(reset, mclk)
    variable count : integer range 1 to 4 := 1;
  begin
		if (reset = '1') then
		   a_n <= "1111";
        disp <= "0000";
        dp <= '0';
        count := 1;
		elsif (rising_edge(mclk) and (Hz400 = '1')) then   
      if (count = 1) then
        a_n <= "0111";
        disp <= d3;
        dp <= dec(3);
        count := 2;
      elsif (count = 2) then
        a_n <= "1011";
        disp <= d2;
        dp <= dec(2);
        count := 3;
      elsif (count = 3) then
        a_n <= "1101";
        disp <= d1;
        dp <= dec(1);
        count := 4;
      else
        a_n <= "1110";
        disp <= d0;
        dp <= dec(0);
        count := 1;
      end if;
    end if;
  end process TDM;
	
	process(mclk)
		variable count : integer range 1 to 125000;
	begin
		if (rising_edge(mclk)) then
			if (count = 125000) then
			  Hz400 <= '1';
				count := 1;
			else
				Hz400 <= '0';
				count := count + 1;
			end if;
		end if;
	end process;
			
   
  -- Output
  abcdefgdec_n <= ag_dec;
  
end rtl;
              
        
      
    
    
  
    
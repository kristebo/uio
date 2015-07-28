library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of pos_meas is
  
  type state_t is (START_UP, WAIT_A1, WAIT_A0, UP_DOWN, 
                 COUNT_UP, COUNT_DOWN);  

  constant  MAX_DEGREES : integer := 127;
  constant  MIN_DEGREES : integer := 0;   
                 
  signal  present_st    : state_t;
  signal  next_st       : state_t;
  signal  a_sync        : std_logic := '0';
  signal  b_sync        : std_logic := '0';
  signal  count_up_en   : std_logic;
  signal  count_down_en : std_logic;
  signal  count         : signed(7 downto 0);
 
begin
      
  -- update present state
  process(clk, rst)
  begin
    if (rst = '1') then
      present_st <= START_UP;
    elsif (rising_edge(clk)) then
      if (sync_rst = '1') then
        present_st <= START_UP;
      else
        a_sync <= a;
        b_sync <= b;
        present_st <= next_st;
      end if;
    end if;
  end process;
  
  -- update next state
  process(a_sync, b_sync, present_st)
  begin
    count_up_en   <= '0';
    count_down_en <= '0';
    case present_st is
      when START_UP =>
        if (a_sync = '0') then
          next_st <= WAIT_A1;
        else
          next_st <= WAIT_A0;
        end if;
      when WAIT_A1 =>
        if (a_sync = '0') then
          next_st <= WAIT_A1;
        else
          next_st <= WAIT_A0;
        end if;
      when WAIT_A0 =>
        if (a_sync = '0') then
          next_st <= UP_DOWN;
        else
          next_st <= WAIT_A0;
        end if;
      when UP_DOWN =>
        if (b_sync = '0') then
          next_st <= COUNT_UP;
        else
          next_st <= COUNT_DOWN;
        end if;
      when COUNT_UP =>
        count_up_en <= '1';
        next_st <= WAIT_A1;
      when COUNT_DOWN =>
        count_down_en <= '1';
        next_st <= WAIT_A1;
    end case;
  end process; 
  
  -- count up or down, if at all possible
  counter: process(clk, rst)
  begin
    if (rst = '1') then
      count <= (others => '0');
    elsif (rising_edge(clk)) then
			if (sync_rst = '1') then
				count <= (others => '0');
      elsif ((count_up_en = '1') and (count < MAX_DEGREES)) then
        count <= count + 1;
      elsif ((count_down_en = '1') and (count > MIN_DEGREES)) then
        count <= count - 1;
      end if;
    end if;
  end process counter;
  
  -- adjust position
  pos <= count;
      
end rtl;
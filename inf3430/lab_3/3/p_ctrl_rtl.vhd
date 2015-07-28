library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of p_ctrl is

  type    state_t is (IDLE, SAMPLE, MOTOR);
  
  signal  present_st  : state_t;
  signal  next_st     : state_t;
  signal  sp_sync     : signed(7 downto 0)  :=  (others => '0');
  signal  pos_sync    : signed(7 downto 0)  :=  (others => '0');
  signal  err         : signed(7 downto 0)  :=  (others => '0');
  signal  cw          : std_logic           :=  '0';
  signal  ccw         : std_logic           :=  '0';
  signal  err_next    : signed(7 downto 0)  :=  (others => '0');
  signal  cw_next     : std_logic           :=  '0';
  signal  ccw_next    : std_logic           :=  '0';

begin

  STATE_REG: process(clk, rst)
  begin
    if (rst = '1') then
      present_st  <= IDLE;
    elsif (rising_edge(clk)) then
      -- assign values attained during the previous
      -- clock cycle
      err         <= err_next;
      cw          <= cw_next;
      ccw         <= ccw_next;      
      -- sync inputs to clk domain
      sp_sync     <= sp;
      pos_sync    <= pos;
      -- change state
      present_st  <= next_st;    
    end if;
  end process STATE_REG;
  
  COMB: process(sp_sync, pos_sync, err, cw, ccw, present_st)
  begin
    err_next <= err;
    cw_next <= cw;
    ccw_next <= ccw;
    case present_st is
      when  IDLE  =>
        next_st <= SAMPLE;
      when  SAMPLE  =>
        next_st   <=  MOTOR;
        err_next  <=  sp_sync - pos_sync;
      when  MOTOR =>
        next_st <=  SAMPLE;
        if (err > 0) then
          cw_next   <=  '1';
          ccw_next  <=  '0';
        elsif (err < 0) then
          cw_next   <=  '0';
          ccw_next  <=  '1';
        else
          cw_next   <=  '0';
          ccw_next  <=  '0';
        end if;
    end case;     
  end process COMB;
  
  -- map internal signals to output ports
  motor_cw  <=  cw;
  motor_ccw <=  ccw;
 
end rtl;
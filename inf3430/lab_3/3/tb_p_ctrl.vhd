library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_p_ctrl is
  -- empty
end tb_p_ctrl;

architecture beh of tb_p_ctrl is
  
  component p_ctrl is
    port (rst       : in  std_logic;
          clk       : in  std_logic;
          sp        : in  signed(7 downto 0);
          pos       : in  signed(7 downto 0);
          motor_cw  : out std_logic;
          motor_ccw : out std_logic);
  end component p_ctrl;
  
  signal  rst       : std_logic := '1';
  signal  clk       : std_logic := '0';
  signal  sp        : signed(7 downto 0) := to_signed(75, 8);
  signal  pos       : signed(7 downto 0) := to_signed(0, 8);
  signal  motor_cw  : std_logic;
  signal  motor_ccw : std_logic;
 
begin

  UUT : entity work.p_ctrl(rtl)
    port map (rst       =>  rst,
              clk       =>  clk,
              sp        =>  sp,
              pos       =>  pos,
              motor_cw  =>  motor_cw,
              motor_ccw =>  motor_ccw);
              
  
  -- clock, reset and setpoint stimuli
  clk <= not clk after 10 ns;
  rst <= '0' after 40 ns;
  sp <= to_signed(30, 8) after 100 ns, to_signed(115, 8) after 160 ns;
              
  -- position stimulus
  process
  begin
    wait for 25 ns;
    for i in 1 to 10 loop
      pos <= pos + 10;
      wait for 20 ns;
    end loop;
    wait;
  end process;
  
end beh;

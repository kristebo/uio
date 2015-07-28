library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pos_meas is
  -- empty
end tb_pos_meas;

architecture beh of tb_pos_meas is

  component pos_meas is
    port (rst       : in  std_logic;
          clk       : in  std_logic;
          sync_rst  : in  std_logic;
          a         : in  std_logic;
          b         : in  std_logic;
          pos       : out signed(7 downto 0));
  end component pos_meas;
  
  component motor is
    port (motor_cw  : in  std_logic;
          motor_ccw : in  std_logic;
          a         : out std_logic;
          b         : out std_logic);
  end component motor;
  
  signal  motor_cw  : std_logic;
  signal  motor_ccw : std_logic;
  signal  a         : std_logic;
  signal  b         : std_logic;
  signal  rst       : std_logic;
  signal  clk       : std_logic := '0';
  signal  sync_rst  : std_logic;
  signal  pos       : signed(7 downto 0);

begin

  UUT : entity work.pos_meas(rtl)
    port map (rst      => rst,
              clk      => clk,
              sync_rst => sync_rst,
              a        => a,
              b        => b,
              pos      => pos);
              
  MOT : entity work.motor(motor_beh)
    port map (motor_cw  =>  motor_cw,
              motor_ccw =>  motor_ccw,
              a         => a,
              b         => b);
              
  -- stimuli
  clk <= not clk after 10 ns;
  
  motor_cw <= '0', '1' after 50 us, '0' after 2000 us;
  motor_ccw <= '0', '1' after 2100 us;
              
  rst <= '1', '0' after 100 us;
  sync_rst <= '0', '1' after 1500 us, '0' after 1550 us;

end beh;
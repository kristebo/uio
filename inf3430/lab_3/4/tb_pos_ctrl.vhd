library ieee;
use ieee.std_logic_1164.all;

entity tb_pos_ctrl is
  -- empty
end tb_pos_ctrl;

architecture beh of tb_pos_ctrl is

  component pos_ctrl is
    port (rst       : in  std_logic;
          rst_div   : in  std_logic;
          mclk      : in  std_logic;
          mclk_div  : in  std_logic;
          sync_rst  : in  std_logic;
          sp        : in  std_logic_vector(7 downto 0);
          a         : in  std_logic;
          b         : in  std_logic;
          force_cw  : in  std_logic;
          force_ccw : in  std_logic;
          pos       : out std_logic_vector(7 downto 0);
          motor_cw  : out std_logic;
          motor_ccw : out std_logic);
  end component pos_ctrl;
  
  component motor is
	port (motor_cw  : in std_logic;
		  motor_ccw : in std_logic;
		  a         : out std_logic;
		  b         : out std_logic);
  end component motor;
          
  signal  rst       : std_logic;
  signal  rst_div   : std_logic;
  signal  mclk      : std_logic := '0';
  signal  mclk_div  : std_logic := '0';
  signal  sync_rst  : std_logic := '0';
  signal  sp        : std_logic_vector(7 downto 0) := "00010000";
  signal  a         : std_logic;
  signal  b         : std_logic;
  signal  force_cw  : std_logic;
  signal  force_ccw : std_logic;
  signal  pos       : std_logic_vector(7 downto 0);
  signal  motor_cw  : std_logic;
  signal  motor_ccw : std_logic;
  
begin

  UUT : entity work.pos_ctrl(rtl)
    port map (rst       =>  rst,
              rst_div   =>  rst_div,
              mclk      =>  mclk,
              mclk_div  =>  mclk_div,
              sync_rst  =>  sync_rst,
              sp        =>  sp,
              a         =>  a,
              b         =>  b,
              force_cw  =>  force_cw,
              force_ccw =>  force_ccw,
              pos       =>  pos,
              motor_cw  =>  motor_cw,
              motor_ccw =>  motor_ccw);
			  
  M : entity work.motor(motor_beh)
    port map (motor_cw  => motor_cw,
							motor_ccw => motor_ccw,
							a         => a,
							b         => b);
              
  -- clock stimuli
  mclk      <= not mclk after 10 ns;
  mclk_div  <= not mclk_div after 1.28 us;
  
  rst <= '1', '0' after 40 ns;
  rst_div <=  '1', '0' after 60 us;
  sync_rst <= '0', '1' after 10 ms;
  
  force_cw <= '0', '1' after 4 ms, '0' after 6 ms;
  force_ccw <= '0', '1' after 8 ms;
  
  
  
  
   
end beh;
  
  
  
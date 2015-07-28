library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of pos_ctrl is

  component pos_meas is
    port (rst       : in  std_logic;
          clk       : in  std_logic;
          sync_rst  : in  std_logic;
          a         : in  std_logic;
          b         : in  std_logic;
          pos       : out signed(7 downto 0));
  end component pos_meas;
  
  component p_ctrl is
    port (rst       : in  std_logic;
          clk       : in  std_logic;
          sp        : in  signed(7 downto 0);
          pos       : in  signed(7 downto 0);
          motor_cw  : out std_logic;
          motor_ccw : out std_logic);
  end component p_ctrl;

  signal  cw	        : std_logic;
  signal  ccw		    : std_logic;
  signal  pos_pm        : signed(7 downto 0);
  signal  sp_pm         : signed(7 downto 0);
  
begin

  PM : entity work.pos_meas(rtl)
    port map (rst       =>  rst,
              clk       =>  mclk,
              sync_rst  =>  sync_rst,
              a         =>  a,
              b         =>  b,
              pos       =>  pos_pm);
  
  PC : entity work.p_ctrl(rtl)
    port map (rst       =>  rst_div,
              clk       =>  mclk_div,
              sp        =>  sp_pm,
              pos       =>  pos_pm,
              motor_cw  =>  cw,
              motor_ccw =>  ccw);
  
  -- update motor signals
  process(mclk_div, force_cw, force_ccw)
    variable sel : std_logic_vector(1 downto 0) := "00";
  begin
	if (rising_edge(mclk_div)) then
		sel := force_cw & force_ccw;
		case sel is
			when "01" =>
				motor_cw  <= '0';
				motor_ccw <= '1';
			when "10" =>
				motor_cw  <= '1';
				motor_ccw <= '0';
			when others =>
				motor_cw <= cw;
				motor_ccw <= ccw;
		end case;
	end if;
  end process;
  
  sp_pm <= signed('0' & sp(6 downto 0));
  pos <= std_logic_vector(pos_pm);
  
end rtl;
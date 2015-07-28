library ieee;
use ieee.std_logic_1164.all;

entity tb_pos_seg7_ctrl is
	-- empty
end tb_pos_seg7_ctrl;

architecture beh of tb_pos_seg7_ctrl is
	
	component pos_seg7_ctrl is
		port (arst 					:	in	std_logic;
					sync_rst			:	in	std_logic;
					refclk				:	in	std_logic;
					sp						:	in	std_logic_vector(7 downto 0);
					a							:	in	std_logic;
					b							:	in	std_logic;
					force_cw			:	in	std_logic;
					force_ccw			:	in	std_logic;
					motor_cw			:	out	std_logic;
					motor_ccw			:	out	std_logic;
					abcdefgdec_n	:	out	std_logic_vector(7 downto 0);
					a_n						:	out	std_logic_vector(3 downto 0));
	end component pos_seg7_ctrl;
					
	component motor is
		port (motor_cw  : in std_logic;
					motor_ccw : in std_logic;
					a         : out std_logic;
					b         : out std_logic);
  end component motor;
	
	component seg7model is
		port (a_n 					:	in	std_logic_vector(3 downto 0);
					abcdefgdec_n	:	in	std_logic_vector(7 downto 0);
					disp3					:	out	std_logic_vector(3 downto 0);
					disp2					:	out	std_logic_vector(3 downto 0);
					disp1         : out std_logic_vector(3 downto 0);
					disp0         : out std_logic_vector(3 downto 0));
	end component seg7model;
						
	signal	arst					:	std_logic;
	signal	sync_rst			:	std_logic;
	signal	refclk				:	std_logic := '0';
	signal	sp						:	std_logic_vector(7 downto 0);
	signal	a							:	std_logic;
	signal	b							:	std_logic;
	signal	force_cw			:	std_logic;
	signal	force_ccw			:	std_logic;
	signal	motor_cw			:	std_logic;
	signal	motor_ccw			:	std_logic;
	signal	abcdefgdec_n	:	std_logic_vector(7 downto 0);
	signal	a_n						:	std_logic_vector(3 downto 0);
	signal	disp3					:	std_logic_vector(3 downto 0);
	signal	disp2					:	std_logic_vector(3 downto 0);
	signal	disp1					:	std_logic_vector(3 downto 0);
	signal	disp0					:	std_logic_vector(3 downto 0);
	
begin

	UUT: pos_seg7_ctrl
		port map (arst 					=>	arst,
							sync_rst			=>	sync_rst,
							refclk				=>	refclk,
							sp						=>	sp,
							a							=>	a,
							b							=>	b,
							force_cw			=>	force_cw,
							force_ccw			=>	force_ccw,
							motor_cw			=>	motor_cw,
							motor_ccw			=>	motor_ccw,
							abcdefgdec_n	=>	abcdefgdec_n,
							a_n						=>	a_n);
							
	MOTOR_0 : entity work.motor(motor_beh)
    port map (motor_cw  => motor_cw,
							motor_ccw => motor_ccw,
							a         => a,
							b         => b);
					
	S7M_0 : entity work.seg7model(beh)
		port map (a_n						=>	a_n,
							abcdefgdec_n	=>	abcdefgdec_n,
							disp3					=>	disp3,
							disp2					=>	disp2,
							disp1					=>	disp1,
							disp0					=>	disp0);
							
	-- stimuli
	refclk <= not refclk after 10 ns;
	arst <= '1', '0' after 1 ms;
	sync_rst <= '0', '1' after 50 ms, '0' after 60 ms;
	sp <= "00100000";
	force_cw <= '0', '1' after 50 ms, '0' after 70 ms;
	force_ccw <= '0', '1' after 80 ms;
	
end beh;
	
	
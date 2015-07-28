library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture str of pos_seg7_ctrl is
	
	component pos_ctrl is
		port (rst				:	in	std_logic;
					rst_div		:	in	std_logic;
					mclk			:	in	std_logic;
					mclk_div	:	in	std_logic;
					sync_rst	:	in	std_logic;
					sp				:	in	std_logic_vector(7 downto 0);
					a					:	in	std_logic;
					b					:	in	std_logic;
					force_cw	:	in	std_logic;
					force_ccw	:	in	std_logic;
					pos				:	out	std_logic_vector(7 downto 0);
					motor_cw	:	out	std_logic;
					motor_ccw	:	out	std_logic);
	end component pos_ctrl;
					
	component seg7ctrl is
		port (mclk					:	in	std_logic;
					reset					:	in	std_logic;
					d3						:	in	std_logic_vector(3 downto 0);
					d2						:	in	std_logic_vector(3 downto 0);
					d1						:	in	std_logic_vector(3 downto 0);
					d0						:	in	std_logic_vector(3 downto 0);
					dec						:	in	std_logic_vector(3 downto 0);
					abcdefgdec_n	:	out	std_logic_vector(7 downto 0);
					a_n						:	out	std_logic_vector(3 downto 0));
	end component seg7ctrl;
	
	component cru is
		port (arst			:	in	std_logic;
					refclk		:	in	std_logic;
					rst				:	out	std_logic;
					rst_div		:	out	std_logic;
					mclk			:	out	std_logic;
					mclk_div	:	out	std_logic);
	end component cru;
	
	signal	rst				:	std_logic;
	signal	rst_div		:	std_logic;
	signal	mclk			:	std_logic;
	signal	mclk_div	:	std_logic;
	signal	sp_pc			:	std_logic_vector(7 downto 0);
	signal	pos				:	std_logic_vector(7 downto 0);
	
begin

	CRU_0: cru
		port map (arst 			=> 	arst,
							refclk		=>	refclk,
							rst				=>	rst,
							rst_div		=>	rst_div,
							mclk			=>	mclk,
							mclk_div	=>	mclk_div);
							
	POS_CTRL_0: pos_ctrl
		port map (rst				=>	rst,
							rst_div		=>	rst_div,
							mclk			=>	mclk,
							mclk_div	=>	mclk_div,
							sync_rst	=>	sync_rst,
							sp				=>	sp_pc,
							a					=>	a,
							b					=>	b,
							force_cw	=>	force_cw,
							force_ccw	=>	force_ccw,
							pos				=>	pos,	
							motor_cw	=>	motor_cw,	
							motor_ccw	=>	motor_ccw);
							
	S7C_0: seg7ctrl
		port map (mclk					=>	mclk,
							reset					=>	rst,
							d3						=>	sp_pc(7 downto 4),
							d2						=>	sp_pc(3 downto 0),
							d1						=>	pos(7 downto 4),
							d0						=>	pos(3 downto 0),
							dec						=>	"0000",
							abcdefgdec_n	=>	abcdefgdec_n,
							a_n						=>	a_n);
							
	-- concurrent assignments					
	sp_pc <= '0' & sp(6 downto 0);
	
end str;
							
	
							

	
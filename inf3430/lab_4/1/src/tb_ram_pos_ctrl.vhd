library ieee;
use ieee.std_logic_1164.all;

entity tb_ram_pos_ctrl is
  -- empty
end tb_ram_pos_ctrl;

architecture beh of tb_ram_pos_ctrl is

  component ram_pos_ctrl is
    port (refclk        : in    std_logic;                      -- Clock
          arst          : in    std_logic;                      -- Asynchronous reset
          sync_rst      : in    std_logic;                      -- Synchronous reset
          
          -- RAM interface
          adr           : out   std_logic_vector(17 downto 0);  -- Address
          dq            : inout std_logic_vector(15 downto 0);  -- Read/write data
          cs_ram_n      : out   std_logic;                      -- Chip Select
          we_ram_n      : out   std_logic;                      -- Write Enable
          oe_ram_n      : out   std_logic;                      -- Output Enable
          lb_ram_n      : out   std_logic;                      -- Select low byte (LSB)
          ub_ram_n      : out   std_logic;                      -- Select high byte (MSB)
          load_run_sp   : in    std_logic;                      -- From BTN2
          sw7           : in    std_logic_vector(7 downto 0);   -- From SW7->0
          
          -- Position measurement
          a             : in    std_logic;
          b             : in    std_logic;
          
          -- Motor control
          force_cw      : in    std_logic;
          force_ccw     : in    std_logic;
          motor_cw      : out   std_logic;
          motor_ccw     : out   std_logic;
          
          -- Interface to 7-segs
          abcdefgdec_n  : out   std_logic_vector(7 downto 0);
          a_n           : out   std_logic_vector(3 downto 0));
  end component ram_pos_ctrl;
  
  component motor is
    port (motor_cw  : in  std_logic;
          motor_ccw : in  std_logic;
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
  
  component async_256kx16 is
    generic (ADDR_BITS    : integer := 18;
             DATA_BITS    : integer := 16;
             depth        : integer := 256*1024;
             TimingInfo   : boolean := true;
             TimingChecks : std_logic := '1');
             
     port   (nCE          : in std_logic;                                                     -- Chip Enable
             nWE          : in std_logic;                                                     -- Write Enable
             nOE          : in std_logic;                                                     -- Output Enable 
             nUB          : in std_logic;                                                     -- Byte Enable High
             nLB          : in std_logic;                                                     -- Byte Enable Low
             A            : in std_logic_vector(ADDR_BITS-1 downto 0);                        -- Address Inputs A
             DQ           : inout std_logic_vector(DATA_BITS-1 downto 0) := (others => 'Z')); -- Read/write data
  end component async_256kx16;
  
  signal refclk       : std_logic := '0';
  signal arst         : std_logic;
  signal sync_rst     : std_logic;
  signal adr          : std_logic_vector(17 downto 0);
  signal dq           : std_logic_vector(15 downto 0);
  signal cs_ram_n     : std_logic;
  signal we_ram_n     : std_logic;
  signal oe_ram_n     : std_logic;
  signal lb_ram_n     : std_logic;
  signal ub_ram_n     : std_logic;
  signal load_run_sp  : std_logic;
  signal sw7          : std_logic_vector(7 downto 0);
  signal a            : std_logic;
  signal b            : std_logic;
  signal force_cw     : std_logic;
  signal force_ccw    : std_logic;
  signal motor_cw     : std_logic;
  signal motor_ccw    : std_logic;
  signal abcdefgdec_n : std_logic_vector(7 downto 0);
  signal a_n          : std_logic_vector(3 downto 0);
  signal disp3        : std_logic_vector(3 downto 0);
  signal disp2        : std_logic_vector(3 downto 0);
  signal disp1        : std_logic_vector(3 downto 0);
  signal disp0        : std_logic_vector(3 downto 0);
  
begin

  UUT: entity work.ram_pos_ctrl(ram_pos_ctrl_o4_rtl)
    port map (refclk        => refclk,
              arst          => arst,
              sync_rst      => sync_rst,
              adr           => adr,
              dq            => dq,
              cs_ram_n      => cs_ram_n,
              we_ram_n      => we_ram_n,
              oe_ram_n      => oe_ram_n,
              lb_ram_n      => lb_ram_n,
              ub_ram_n      => ub_ram_n,
              load_run_sp   => load_run_sp,
              sw7           => sw7,
              a             => a,
              b             => b,
              force_cw      => force_cw,
              force_ccw     => force_ccw,
              motor_cw      => motor_cw,
              motor_ccw     => motor_ccw,
              abcdefgdec_n  => abcdefgdec_n,
              a_n           => a_n);
              
  MOTOR_0: entity work.motor(motor_beh)
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
              
  A256_0: entity work.async_256kx16(behavorial)
    port map (nCE => cs_ram_n,
              nWE => we_ram_n,
              nOE => oe_ram_n,
              nUB => ub_ram_n,
              nLB => lb_ram_n,
              A   => adr,
              DQ  => dq);
              
  -- Clock and reset stimuli
  refclk <= not refclk after 10 ns;
  arst <= '1', '0' after 15 ns, '1' after 14 ms, '0' after 14.5 ms;
  
  sw7(7) <= '1', -- write to sram
            '0' after 15 ms; -- read from sram
            
  sw7(6 downto 0) <= "0000001", "0111111" after 10 ms;
  
  load_run_sp <= '0', 
                 '1' after 200 ns, '0' after 220 ns, -- bounce
                 '1' after 400 ns, '0' after 460 ns,
                 '1' after 11 ms, '0' after 11000060 ns,
                 '1' after 16 ms, '0' after 16000060 ns,
                 '1' after 25 ms, '0' after 25000060 ns;
              
end beh;
  
  
  
          
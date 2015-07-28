library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture ram_pos_ctrl_o4_rtl of ram_pos_ctrl is

  component ram_sp is
    port (clk             : in  std_logic;                      -- Clock
          rst             : in  std_logic;                      -- Asynchronous reset
          
          -- RAM interface
          adr             : out std_logic_vector(17 downto 0);  -- Address
          d_in            : in  std_logic_vector(15 downto 0);  -- Data from SRAM
          d_out           : out std_logic_vector(15 downto 0);  -- Data to SRAM
          cs_ram_n        : out std_logic;                      -- Chip Select
          we_ram_n        : out std_logic;                      -- Write Enable
          oe_ram_n        : out std_logic;                      -- Output Enable (enabler SRAMs tristate-utganger)
          lb_ram_n        : out std_logic;                      -- Select low byte (LSB)
          ub_ram_n        : out std_logic;                      -- Velger high byte (MSB)
          
          -- Load run sp interface
          load_run_sp     : in  std_logic;                      -- Signal from BTN2: for storing/playing a setpoint
          load_sp_mode    : in  std_logic;                      -- SW7 place state machine in load mode
          sp_in           : in  std_logic_vector(6 downto 0);   -- Setpoint in
          sp_out          : out std_logic_vector(7 downto 0);   -- Setpoint out
          chip_scope_out  : out std_logic_vector(31 downto 0)); -- For connecting Chip_scope ILA module (optional)
  end component ram_sp;
  
  component debouncer is
    port (rst :  in std_logic;
          clk :   in std_logic;
          bounced : in std_logic;
          debounced : in std_logic);
  end component debouncer;
  
  component cru is
    port (arst      : in  std_logic;  -- Asynchronous reset
          refclk    : in  std_logic;  -- Reference clock
          rst       : out std_logic;  -- Synchronized arst for mclk
          rst_div   : out std_logic;  -- Synchronized arst for mclk_div
          mclk      : out std_logic;  -- Master clock
          mclk_div  : out std_logic); -- Master clock div. by 128
  end component cru;
  
  component pos_seg7_ctrl is
    port (rst           : in  std_logic;                    -- Synchronized arst for mclk
          rst_div       : in  std_logic;                    -- Synchronized arst for mclk_div  
          mclk          : in  std_logic;                    -- Master clock
          mclk_div      : in  std_logic;                    -- Master clock div. by 128
          sync_rst      : in  std_logic;                    -- Synchronous reset
          sp            : in  std_logic_vector(7 downto 0); -- Setpoint
          a             : in  std_logic;                    -- From OSE
          b             : in  std_logic;                    -- From OSE
          force_cw      : in  std_logic;                    -- Force motor clockwise
          force_ccw     : in  std_logic;                    -- Force motor counter-clockwise
          motor_cw      : out std_logic;                    -- To motor
          motor_ccw     : out std_logic;                    -- To motor
          abcdefgdec_n  : out std_logic_vector(7 downto 0); -- To 7seg LEDS
          a_n           : out std_logic);                   -- To 7seg anodes
  end component pos_seg7_ctrl;
  
  -- CRU signals.
  signal rst            : std_logic;
  signal rst_div        : std_logic;
  signal mclk           : std_logic;
  signal mclk_div       : std_logic;

  -- Used to map the setpoint coming out of the ram_sp module to
  -- the pos_seg7_ctrl module
  signal sp_RSP_to_P7C  : std_logic_vector(7 downto 0);
  
  -- Used for tri-stating the bus connecting ram_sp and SRAM
  signal d_in           : std_logic_vector(15 downto 0);
  signal d_out          : std_logic_vector(15 downto 0);
  signal oe_ram_n_1     : std_logic;

begin

  CRU_0: entity work.cru(str)
    port map (arst      => arst,
              refclk    => refclk,
              rst       => rst,
              rst_div   => rst_div,
              mclk      => mclk,
              mclk_div  => mclk_div);
              
  P7C_0: entity work.pos_seg7_ctrl(str)
    port map (rst           => rst,           -- Internally mapped signal
              rst_div       => rst_div,       -- Internally mapped signal
              mclk          => mclk,          -- Internally mapped signal
              mclk_div      => mclk_div,      -- Internally mapped signal
              sync_rst      => sync_rst,
              sp            => sp_RSP_to_P7C, -- Internally mapped signal
              a             => a,
              b             => b,
              force_cw      => force_cw,
              force_ccw     => force_ccw,
              motor_cw      => motor_cw,
              motor_ccw     => motor_ccw,
              abcdefgdec_n  => abcdefgdec_n,
              a_n           => a_n);
              
  RSP_0: entity work.ram_sp(ram_sp_rtl)
    port map (clk             => mclk,         -- Internally mapped signal
              rst             => rst,          -- Internally mapped signal
              adr             => adr,
              d_in            => d_in,
              d_out           => d_out,
              cs_ram_n        => cs_ram_n,
              we_ram_n        => we_ram_n,
              oe_ram_n        => oe_ram_n_1,   -- Internally mapped signal
              lb_ram_n        => lb_ram_n,
              ub_ram_n        => ub_ram_n,
              load_run_sp     => load_run_sp,
              load_sp_mode    => sw7(7),
              sp_in           => sw7(6 downto 0),
              sp_out          => sp_RSP_to_P7C,
              chip_scope_out  => open);
  
  -- Tri-stating the bus
  d_in <= dq when (oe_ram_n_1 = '0') else (others => 'Z');
  dq <= d_out when (oe_ram_n_1 = '1') else (others => 'Z');
  
  -- 
  oe_ram_n <= oe_ram_n_1;
 
end ram_pos_ctrl_o4_rtl;


library IEEE;
use IEEE.std_logic_1164.all;

entity ram_pos_ctrl is
  port (
    refclk        : in std_logic;                         -- Clock
    arst          : in std_logic;                         -- Asynchronous reset
    sync_rst      : in std_logic := '0';                  -- Synchronous reset

    -- RAM interface
    adr           : out   std_logic_vector(17 downto 0);  -- Address
    dq            : inout std_logic_vector(15 downto 0);  -- Read/write data
    cs_ram_n      : out   std_logic;                      -- Chip Select
    we_ram_n      : out   std_logic;                      -- Write Enable
    oe_ram_n      : out   std_logic;                      -- Output Enable
    lb_ram_n      : out   std_logic;                      -- Select low byte (LSB)
    ub_ram_n      : out   std_logic;                      -- Velger high byte (MSB)
    load_run_sp   : in    std_logic;                      -- From BTN2
    sw7           : in    std_logic_vector(7 downto 0);   -- From SW7->0
    
    -- Position measurement
    a             : in std_logic;
    b             : in std_logic;

    -- Motor control
    force_cw      : in  std_logic;
    force_ccw     : in  std_logic;
    motor_cw      : out std_logic;
    motor_ccw     : out std_logic;
    

    -- Interface to seven segments
    abcdefgdec_n  : out std_logic_vector(7 downto 0);
    a_n           : out std_logic_vector(3 downto 0)
    );
end ram_pos_ctrl;


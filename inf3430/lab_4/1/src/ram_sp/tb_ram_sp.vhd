library ieee;
use ieee.std_logic_1164.all;

entity tb_ram_sp is
  -- empty
end tb_ram_sp;

architecture beh of tb_ram_sp is
  
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
  
  signal clk            : std_logic := '0';
  signal rst            : std_logic;
  signal adr            : std_logic_vector(17 downto 0);
  signal d_in           : std_logic_vector(15 downto 0);
  signal d_out			: std_logic_vector(15 downto 0);
  signal data_inout     : std_logic_vector(15 downto 0);
  signal cs_ram_n       : std_logic;
  signal we_ram_n       : std_logic;
  signal oe_ram_n       : std_logic;
  signal lb_ram_n       : std_logic;
  signal ub_ram_n       : std_logic;
  signal load_run_sp    : std_logic;
  signal load_sp_mode   : std_logic;  
  signal sp_in          : std_logic_vector(6 downto 0);
  signal sp_out         : std_logic_vector(7 downto 0);  
  signal chip_scope_out : std_logic_vector(31 downto 0);
  

begin

  UUT: entity work.ram_sp(ram_sp_rtl)
    port map (clk             => clk,
              rst             => rst,
              adr             => adr,
              d_in            => d_in,
              d_out           => d_out,
              cs_ram_n        => cs_ram_n,
              we_ram_n        => we_ram_n,
              oe_ram_n        => oe_ram_n,
              lb_ram_n        => lb_ram_n,
              ub_ram_n        => ub_ram_n,
              load_run_sp     => load_run_sp,
              load_sp_mode    => load_sp_mode,
              sp_in           => sp_in,
              sp_out          => sp_out,
              chip_scope_out  => chip_scope_out);
  
  A256: entity work.async_256kx16(behavorial)
    port map (nCE => cs_ram_n,
              nWE => we_ram_n,
              nOE => oe_ram_n,
              nUB => ub_ram_n,
              nLB => lb_ram_n,
              A   => adr,
              DQ  => data_inout);
              
  -- Clock and reset stimuli
  clk <= not clk after 10 ns;
  rst <= '1', '0' after 10 ns, '1' after 400 ns,
         '0' after 500 ns;
		 
  -- SW(6 downto 0) input
  sp_in <= "0000001", "1000000" after 300 ns;
  
  -- SW7 input
  load_sp_mode <= '1', '0' after 450 ns;
  
  -- BTN2 input 
  load_run_sp <= '0', '1' after 20 ns, '0' after 25 ns, -- bounce
                 '1' after 35 ns, '0' after 65 ns,      -- bounce
                 '1' after 100 ns, '0' after 200 ns,    -- holds value for > required time (with cwidth = 2)
				 '1' after 300 ns, '0' after 400 ns,
                 '1' after 800 ns, '0' after 860 ns,
				 '1' after 1000 ns;
				 
  -- Tristate bus
  data_inout <= d_out when (oe_ram_n = '1') else (others => 'Z');
  d_in <= data_inout;
  
end beh;
  
architecture str of test_pos_meas is

  component pos_meas is
    port (rst       : in  std_logic;
          clk       : in  std_logic;
          sync_rst  : in  std_logic;
          a         : in  std_logic;
          b         : in  std_logic;
          pos       : in  signed(7 downto 0));
  end component pos_meas; 
  
begin

  PM : entity work.pos_meas(rtl)
    port map (rst       =>  rst,
              clk       =>  clk,
              sync_rst  =>  sync_rst,
              a         =>  a,
              b         =>  b,
              pos       => pos);
              
  force_cw <= btn0;
  force_ccw <= btn1;
  
end str;
    
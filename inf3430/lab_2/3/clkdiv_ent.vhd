library ieee;
use ieee.std_logic_1164.all;

-- This entity and its associated process is used for dividing the
-- Spartan 3 onboard 50Mhz clock such it instead acts as a 400Hz
-- clock (so that each display gets updated at a rate of 400Hz/4=100Hz).
-- This frequency should be high enough for a continuous perception
-- of the (potentially) four digits shown.
entity clkdiv is
  port
  (
    mclk : in std_logic; -- 50MHz original clock
    rclk : out std_logic -- 400Hz reduced clock
  );
end entity clkdiv;
--------------------------------------------------------------------------------
-- Copyright (c) 1995-2010 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: M.81d
--  \   \         Application: netgen
--  /   /         Filename: seg7ctrl_synthesis.vhd
-- /___/   /\     Timestamp: Tue Oct 15 08:52:35 2013
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -intstyle ise -ar Structure -tm seg7ctrl -w -dir netgen/synthesis -ofmt vhdl -sim seg7ctrl.ngc seg7ctrl_synthesis.vhd 
-- Device	: xc3s200-5-ft256
-- Input file	: seg7ctrl.ngc
-- Output file	: C:\Users\Magnus Andersen\Desktop\laboppgave_2\3\xilinx\netgen\synthesis\seg7ctrl_synthesis.vhd
-- # of Entities	: 1
-- Design Name	: seg7ctrl
-- Xilinx	: C:\Xilinx\12.4\ISE_DS\ISE\
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Command Line Tools User Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
use UNISIM.VPKG.ALL;

entity seg7ctrl is
  port (
    reset : in STD_LOGIC := 'X'; 
    mclk : in STD_LOGIC := 'X'; 
    a_n : out STD_LOGIC_VECTOR ( 3 downto 0 ); 
    abcdefgdec_n : out STD_LOGIC_VECTOR ( 7 downto 0 ); 
    d0 : in STD_LOGIC_VECTOR ( 3 downto 0 ); 
    d1 : in STD_LOGIC_VECTOR ( 3 downto 0 ); 
    d2 : in STD_LOGIC_VECTOR ( 3 downto 0 ); 
    d3 : in STD_LOGIC_VECTOR ( 3 downto 0 ); 
    dec : in STD_LOGIC_VECTOR ( 3 downto 0 ) 
  );
end seg7ctrl;

architecture Structure of seg7ctrl is
  signal CD_Mcount_count_cy_10_rt_2 : STD_LOGIC; 
  signal CD_Mcount_count_cy_11_rt_4 : STD_LOGIC; 
  signal CD_Mcount_count_cy_12_rt_6 : STD_LOGIC; 
  signal CD_Mcount_count_cy_13_rt_8 : STD_LOGIC; 
  signal CD_Mcount_count_cy_14_rt_10 : STD_LOGIC; 
  signal CD_Mcount_count_cy_1_rt_12 : STD_LOGIC; 
  signal CD_Mcount_count_cy_2_rt_14 : STD_LOGIC; 
  signal CD_Mcount_count_cy_3_rt_16 : STD_LOGIC; 
  signal CD_Mcount_count_cy_4_rt_18 : STD_LOGIC; 
  signal CD_Mcount_count_cy_5_rt_20 : STD_LOGIC; 
  signal CD_Mcount_count_cy_6_rt_22 : STD_LOGIC; 
  signal CD_Mcount_count_cy_7_rt_24 : STD_LOGIC; 
  signal CD_Mcount_count_cy_8_rt_26 : STD_LOGIC; 
  signal CD_Mcount_count_cy_9_rt_28 : STD_LOGIC; 
  signal CD_Mcount_count_xor_15_rt_30 : STD_LOGIC; 
  signal CD_clk_31 : STD_LOGIC; 
  signal CD_clk_not0001 : STD_LOGIC; 
  signal CD_count_cmp_eq0000 : STD_LOGIC; 
  signal CD_count_cmp_eq000016_50 : STD_LOGIC; 
  signal CD_count_cmp_eq000037_51 : STD_LOGIC; 
  signal CD_count_cmp_eq00004_52 : STD_LOGIC; 
  signal CD_count_cmp_eq000049_53 : STD_LOGIC; 
  signal N0 : STD_LOGIC; 
  signal N1 : STD_LOGIC; 
  signal N14 : STD_LOGIC; 
  signal N16 : STD_LOGIC; 
  signal N18 : STD_LOGIC; 
  signal N20 : STD_LOGIC; 
  signal N22 : STD_LOGIC; 
  signal a_n_0_81 : STD_LOGIC; 
  signal a_n_1_82 : STD_LOGIC; 
  signal a_n_2_83 : STD_LOGIC; 
  signal a_n_3_84 : STD_LOGIC; 
  signal abcdefgdec_n_0_OBUF_93 : STD_LOGIC; 
  signal abcdefgdec_n_1_OBUF_94 : STD_LOGIC; 
  signal abcdefgdec_n_2_OBUF_95 : STD_LOGIC; 
  signal abcdefgdec_n_3_OBUF_96 : STD_LOGIC; 
  signal abcdefgdec_n_4_OBUF_97 : STD_LOGIC; 
  signal abcdefgdec_n_5_OBUF_98 : STD_LOGIC; 
  signal abcdefgdec_n_6_OBUF_99 : STD_LOGIC; 
  signal abcdefgdec_n_7_OBUF_100 : STD_LOGIC; 
  signal count_FSM_FFd1_101 : STD_LOGIC; 
  signal count_FSM_FFd2_102 : STD_LOGIC; 
  signal count_FSM_FFd3_103 : STD_LOGIC; 
  signal count_FSM_FFd4_104 : STD_LOGIC; 
  signal count_index0000 : STD_LOGIC; 
  signal count_index0001 : STD_LOGIC; 
  signal count_index0002 : STD_LOGIC; 
  signal count_index0003 : STD_LOGIC; 
  signal d0_0_IBUF_113 : STD_LOGIC; 
  signal d0_1_IBUF_114 : STD_LOGIC; 
  signal d0_2_IBUF_115 : STD_LOGIC; 
  signal d0_3_IBUF_116 : STD_LOGIC; 
  signal d1_0_IBUF_121 : STD_LOGIC; 
  signal d1_1_IBUF_122 : STD_LOGIC; 
  signal d1_2_IBUF_123 : STD_LOGIC; 
  signal d1_3_IBUF_124 : STD_LOGIC; 
  signal d2_0_IBUF_129 : STD_LOGIC; 
  signal d2_1_IBUF_130 : STD_LOGIC; 
  signal d2_2_IBUF_131 : STD_LOGIC; 
  signal d2_3_IBUF_132 : STD_LOGIC; 
  signal d3_0_IBUF_137 : STD_LOGIC; 
  signal d3_1_IBUF_138 : STD_LOGIC; 
  signal d3_2_IBUF_139 : STD_LOGIC; 
  signal d3_3_IBUF_140 : STD_LOGIC; 
  signal dec_0_IBUF_145 : STD_LOGIC; 
  signal dec_1_IBUF_146 : STD_LOGIC; 
  signal dec_2_IBUF_147 : STD_LOGIC; 
  signal dec_3_IBUF_148 : STD_LOGIC; 
  signal disp_mux0004_0_26 : STD_LOGIC; 
  signal disp_mux0004_0_4_154 : STD_LOGIC; 
  signal disp_mux0004_1_26 : STD_LOGIC; 
  signal disp_mux0004_1_4_156 : STD_LOGIC; 
  signal disp_mux0004_2_26 : STD_LOGIC; 
  signal disp_mux0004_2_4_158 : STD_LOGIC; 
  signal disp_mux0004_3_26 : STD_LOGIC; 
  signal disp_mux0004_3_4_160 : STD_LOGIC; 
  signal dp_161 : STD_LOGIC; 
  signal dp_mux000426 : STD_LOGIC; 
  signal dp_mux00044_163 : STD_LOGIC; 
  signal mclk_BUFGP_165 : STD_LOGIC; 
  signal reset_IBUF_167 : STD_LOGIC; 
  signal CD_Mcount_count_cy : STD_LOGIC_VECTOR ( 14 downto 0 ); 
  signal CD_Mcount_count_lut : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal CD_count : STD_LOGIC_VECTOR ( 15 downto 0 ); 
  signal Result : STD_LOGIC_VECTOR ( 15 downto 0 ); 
  signal disp : STD_LOGIC_VECTOR ( 3 downto 0 ); 
begin
  XST_GND : GND
    port map (
      G => N0
    );
  XST_VCC : VCC
    port map (
      P => N1
    );
  a_n_0 : FDS
    port map (
      C => CD_clk_31,
      D => count_index0003,
      S => reset_IBUF_167,
      Q => a_n_0_81
    );
  a_n_1 : FDS
    port map (
      C => CD_clk_31,
      D => count_index0002,
      S => reset_IBUF_167,
      Q => a_n_1_82
    );
  a_n_2 : FDS
    port map (
      C => CD_clk_31,
      D => count_index0001,
      S => reset_IBUF_167,
      Q => a_n_2_83
    );
  a_n_3 : FDS
    port map (
      C => CD_clk_31,
      D => count_index0000,
      S => reset_IBUF_167,
      Q => a_n_3_84
    );
  CD_clk : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      CE => CD_count_cmp_eq0000,
      D => CD_clk_not0001,
      Q => CD_clk_31
    );
  CD_count_0 : FDS
    generic map(
      INIT => '1'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(0),
      S => CD_count_cmp_eq0000,
      Q => CD_count(0)
    );
  CD_count_1 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(1),
      R => CD_count_cmp_eq0000,
      Q => CD_count(1)
    );
  CD_count_2 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(2),
      R => CD_count_cmp_eq0000,
      Q => CD_count(2)
    );
  CD_count_3 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(3),
      R => CD_count_cmp_eq0000,
      Q => CD_count(3)
    );
  CD_count_4 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(4),
      R => CD_count_cmp_eq0000,
      Q => CD_count(4)
    );
  CD_count_5 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(5),
      R => CD_count_cmp_eq0000,
      Q => CD_count(5)
    );
  CD_count_6 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(6),
      R => CD_count_cmp_eq0000,
      Q => CD_count(6)
    );
  CD_count_9 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(9),
      R => CD_count_cmp_eq0000,
      Q => CD_count(9)
    );
  CD_count_7 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(7),
      R => CD_count_cmp_eq0000,
      Q => CD_count(7)
    );
  CD_count_8 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(8),
      R => CD_count_cmp_eq0000,
      Q => CD_count(8)
    );
  CD_count_10 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(10),
      R => CD_count_cmp_eq0000,
      Q => CD_count(10)
    );
  CD_count_11 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(11),
      R => CD_count_cmp_eq0000,
      Q => CD_count(11)
    );
  CD_count_12 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(12),
      R => CD_count_cmp_eq0000,
      Q => CD_count(12)
    );
  CD_count_13 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(13),
      R => CD_count_cmp_eq0000,
      Q => CD_count(13)
    );
  CD_count_14 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(14),
      R => CD_count_cmp_eq0000,
      Q => CD_count(14)
    );
  CD_count_15 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => mclk_BUFGP_165,
      D => Result(15),
      R => CD_count_cmp_eq0000,
      Q => CD_count(15)
    );
  CD_Mcount_count_cy_0_Q : MUXCY
    port map (
      CI => N0,
      DI => N1,
      S => CD_Mcount_count_lut(0),
      O => CD_Mcount_count_cy(0)
    );
  CD_Mcount_count_xor_0_Q : XORCY
    port map (
      CI => N0,
      LI => CD_Mcount_count_lut(0),
      O => Result(0)
    );
  CD_Mcount_count_cy_1_Q : MUXCY
    port map (
      CI => CD_Mcount_count_cy(0),
      DI => N0,
      S => CD_Mcount_count_cy_1_rt_12,
      O => CD_Mcount_count_cy(1)
    );
  CD_Mcount_count_xor_1_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(0),
      LI => CD_Mcount_count_cy_1_rt_12,
      O => Result(1)
    );
  CD_Mcount_count_cy_2_Q : MUXCY
    port map (
      CI => CD_Mcount_count_cy(1),
      DI => N0,
      S => CD_Mcount_count_cy_2_rt_14,
      O => CD_Mcount_count_cy(2)
    );
  CD_Mcount_count_xor_2_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(1),
      LI => CD_Mcount_count_cy_2_rt_14,
      O => Result(2)
    );
  CD_Mcount_count_cy_3_Q : MUXCY
    port map (
      CI => CD_Mcount_count_cy(2),
      DI => N0,
      S => CD_Mcount_count_cy_3_rt_16,
      O => CD_Mcount_count_cy(3)
    );
  CD_Mcount_count_xor_3_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(2),
      LI => CD_Mcount_count_cy_3_rt_16,
      O => Result(3)
    );
  CD_Mcount_count_cy_4_Q : MUXCY
    port map (
      CI => CD_Mcount_count_cy(3),
      DI => N0,
      S => CD_Mcount_count_cy_4_rt_18,
      O => CD_Mcount_count_cy(4)
    );
  CD_Mcount_count_xor_4_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(3),
      LI => CD_Mcount_count_cy_4_rt_18,
      O => Result(4)
    );
  CD_Mcount_count_cy_5_Q : MUXCY
    port map (
      CI => CD_Mcount_count_cy(4),
      DI => N0,
      S => CD_Mcount_count_cy_5_rt_20,
      O => CD_Mcount_count_cy(5)
    );
  CD_Mcount_count_xor_5_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(4),
      LI => CD_Mcount_count_cy_5_rt_20,
      O => Result(5)
    );
  CD_Mcount_count_cy_6_Q : MUXCY
    port map (
      CI => CD_Mcount_count_cy(5),
      DI => N0,
      S => CD_Mcount_count_cy_6_rt_22,
      O => CD_Mcount_count_cy(6)
    );
  CD_Mcount_count_xor_6_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(5),
      LI => CD_Mcount_count_cy_6_rt_22,
      O => Result(6)
    );
  CD_Mcount_count_cy_7_Q : MUXCY
    port map (
      CI => CD_Mcount_count_cy(6),
      DI => N0,
      S => CD_Mcount_count_cy_7_rt_24,
      O => CD_Mcount_count_cy(7)
    );
  CD_Mcount_count_xor_7_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(6),
      LI => CD_Mcount_count_cy_7_rt_24,
      O => Result(7)
    );
  CD_Mcount_count_cy_8_Q : MUXCY
    port map (
      CI => CD_Mcount_count_cy(7),
      DI => N0,
      S => CD_Mcount_count_cy_8_rt_26,
      O => CD_Mcount_count_cy(8)
    );
  CD_Mcount_count_xor_8_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(7),
      LI => CD_Mcount_count_cy_8_rt_26,
      O => Result(8)
    );
  CD_Mcount_count_cy_9_Q : MUXCY
    port map (
      CI => CD_Mcount_count_cy(8),
      DI => N0,
      S => CD_Mcount_count_cy_9_rt_28,
      O => CD_Mcount_count_cy(9)
    );
  CD_Mcount_count_xor_9_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(8),
      LI => CD_Mcount_count_cy_9_rt_28,
      O => Result(9)
    );
  CD_Mcount_count_cy_10_Q : MUXCY
    port map (
      CI => CD_Mcount_count_cy(9),
      DI => N0,
      S => CD_Mcount_count_cy_10_rt_2,
      O => CD_Mcount_count_cy(10)
    );
  CD_Mcount_count_xor_10_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(9),
      LI => CD_Mcount_count_cy_10_rt_2,
      O => Result(10)
    );
  CD_Mcount_count_cy_11_Q : MUXCY
    port map (
      CI => CD_Mcount_count_cy(10),
      DI => N0,
      S => CD_Mcount_count_cy_11_rt_4,
      O => CD_Mcount_count_cy(11)
    );
  CD_Mcount_count_xor_11_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(10),
      LI => CD_Mcount_count_cy_11_rt_4,
      O => Result(11)
    );
  CD_Mcount_count_cy_12_Q : MUXCY
    port map (
      CI => CD_Mcount_count_cy(11),
      DI => N0,
      S => CD_Mcount_count_cy_12_rt_6,
      O => CD_Mcount_count_cy(12)
    );
  CD_Mcount_count_xor_12_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(11),
      LI => CD_Mcount_count_cy_12_rt_6,
      O => Result(12)
    );
  CD_Mcount_count_cy_13_Q : MUXCY
    port map (
      CI => CD_Mcount_count_cy(12),
      DI => N0,
      S => CD_Mcount_count_cy_13_rt_8,
      O => CD_Mcount_count_cy(13)
    );
  CD_Mcount_count_xor_13_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(12),
      LI => CD_Mcount_count_cy_13_rt_8,
      O => Result(13)
    );
  CD_Mcount_count_cy_14_Q : MUXCY
    port map (
      CI => CD_Mcount_count_cy(13),
      DI => N0,
      S => CD_Mcount_count_cy_14_rt_10,
      O => CD_Mcount_count_cy(14)
    );
  CD_Mcount_count_xor_14_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(13),
      LI => CD_Mcount_count_cy_14_rt_10,
      O => Result(14)
    );
  CD_Mcount_count_xor_15_Q : XORCY
    port map (
      CI => CD_Mcount_count_cy(14),
      LI => CD_Mcount_count_xor_15_rt_30,
      O => Result(15)
    );
  count_FSM_FFd4 : FDS
    generic map(
      INIT => '1'
    )
    port map (
      C => CD_clk_31,
      D => count_FSM_FFd1_101,
      S => reset_IBUF_167,
      Q => count_FSM_FFd4_104
    );
  count_FSM_FFd3 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => CD_clk_31,
      D => count_FSM_FFd4_104,
      R => reset_IBUF_167,
      Q => count_FSM_FFd3_103
    );
  count_FSM_FFd2 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => CD_clk_31,
      D => count_FSM_FFd3_103,
      R => reset_IBUF_167,
      Q => count_FSM_FFd2_102
    );
  count_FSM_FFd1 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => CD_clk_31,
      D => count_FSM_FFd2_102,
      R => reset_IBUF_167,
      Q => count_FSM_FFd1_101
    );
  S7D_abcdefg_dec_3_or00001 : LUT4
    generic map(
      INIT => X"445C"
    )
    port map (
      I0 => disp(3),
      I1 => disp(0),
      I2 => disp(2),
      I3 => disp(1),
      O => abcdefgdec_n_3_OBUF_96
    );
  S7D_abcdefg_dec_5_or00001 : LUT4
    generic map(
      INIT => X"80C2"
    )
    port map (
      I0 => disp(1),
      I1 => disp(2),
      I2 => disp(3),
      I3 => disp(0),
      O => abcdefgdec_n_5_OBUF_98
    );
  S7D_abcdefg_dec_6_or00001 : LUT4
    generic map(
      INIT => X"AC48"
    )
    port map (
      I0 => disp(3),
      I1 => disp(2),
      I2 => disp(0),
      I3 => disp(1),
      O => abcdefgdec_n_6_OBUF_99
    );
  S7D_abcdefg_dec_2_or00001 : LUT4
    generic map(
      INIT => X"6054"
    )
    port map (
      I0 => disp(3),
      I1 => disp(1),
      I2 => disp(0),
      I3 => disp(2),
      O => abcdefgdec_n_2_OBUF_95
    );
  S7D_abcdefg_dec_1_or00001 : LUT4
    generic map(
      INIT => X"2141"
    )
    port map (
      I0 => disp(1),
      I1 => disp(3),
      I2 => disp(2),
      I3 => disp(0),
      O => abcdefgdec_n_1_OBUF_94
    );
  S7D_abcdefg_dec_4_or00001 : LUT4
    generic map(
      INIT => X"8692"
    )
    port map (
      I0 => disp(0),
      I1 => disp(1),
      I2 => disp(2),
      I3 => disp(3),
      O => abcdefgdec_n_4_OBUF_97
    );
  S7D_abcdefg_dec_7_or00001 : LUT4
    generic map(
      INIT => X"4184"
    )
    port map (
      I0 => disp(1),
      I1 => disp(0),
      I2 => disp(3),
      I3 => disp(2),
      O => abcdefgdec_n_7_OBUF_100
    );
  dp_mux00044 : LUT4
    generic map(
      INIT => X"F888"
    )
    port map (
      I0 => count_FSM_FFd3_103,
      I1 => dec_2_IBUF_147,
      I2 => count_FSM_FFd2_102,
      I3 => dec_1_IBUF_146,
      O => dp_mux00044_163
    );
  disp_mux0004_3_4 : LUT4
    generic map(
      INIT => X"F888"
    )
    port map (
      I0 => count_FSM_FFd3_103,
      I1 => d2_3_IBUF_132,
      I2 => count_FSM_FFd2_102,
      I3 => d1_3_IBUF_124,
      O => disp_mux0004_3_4_160
    );
  disp_mux0004_2_4 : LUT4
    generic map(
      INIT => X"F888"
    )
    port map (
      I0 => count_FSM_FFd3_103,
      I1 => d2_2_IBUF_131,
      I2 => count_FSM_FFd2_102,
      I3 => d1_2_IBUF_123,
      O => disp_mux0004_2_4_158
    );
  disp_mux0004_1_4 : LUT4
    generic map(
      INIT => X"F888"
    )
    port map (
      I0 => count_FSM_FFd3_103,
      I1 => d2_1_IBUF_130,
      I2 => count_FSM_FFd2_102,
      I3 => d1_1_IBUF_122,
      O => disp_mux0004_1_4_156
    );
  disp_mux0004_0_4 : LUT4
    generic map(
      INIT => X"F888"
    )
    port map (
      I0 => count_FSM_FFd3_103,
      I1 => d2_0_IBUF_129,
      I2 => count_FSM_FFd2_102,
      I3 => d1_0_IBUF_121,
      O => disp_mux0004_0_4_154
    );
  CD_count_cmp_eq000016 : LUT4
    generic map(
      INIT => X"0002"
    )
    port map (
      I0 => CD_count(10),
      I1 => CD_count(11),
      I2 => CD_count(8),
      I3 => CD_count(9),
      O => CD_count_cmp_eq000016_50
    );
  CD_count_cmp_eq000037 : LUT4
    generic map(
      INIT => X"0002"
    )
    port map (
      I0 => CD_count(2),
      I1 => CD_count(3),
      I2 => CD_count(0),
      I3 => CD_count(1),
      O => CD_count_cmp_eq000037_51
    );
  CD_count_cmp_eq000049 : LUT4
    generic map(
      INIT => X"0002"
    )
    port map (
      I0 => CD_count(5),
      I1 => CD_count(4),
      I2 => CD_count(6),
      I3 => CD_count(7),
      O => CD_count_cmp_eq000049_53
    );
  CD_count_cmp_eq000063 : LUT4
    generic map(
      INIT => X"8000"
    )
    port map (
      I0 => CD_count_cmp_eq00004_52,
      I1 => CD_count_cmp_eq000016_50,
      I2 => CD_count_cmp_eq000037_51,
      I3 => CD_count_cmp_eq000049_53,
      O => CD_count_cmp_eq0000
    );
  reset_IBUF : IBUF
    port map (
      I => reset,
      O => reset_IBUF_167
    );
  d0_3_IBUF : IBUF
    port map (
      I => d0(3),
      O => d0_3_IBUF_116
    );
  d0_2_IBUF : IBUF
    port map (
      I => d0(2),
      O => d0_2_IBUF_115
    );
  d0_1_IBUF : IBUF
    port map (
      I => d0(1),
      O => d0_1_IBUF_114
    );
  d0_0_IBUF : IBUF
    port map (
      I => d0(0),
      O => d0_0_IBUF_113
    );
  d1_3_IBUF : IBUF
    port map (
      I => d1(3),
      O => d1_3_IBUF_124
    );
  d1_2_IBUF : IBUF
    port map (
      I => d1(2),
      O => d1_2_IBUF_123
    );
  d1_1_IBUF : IBUF
    port map (
      I => d1(1),
      O => d1_1_IBUF_122
    );
  d1_0_IBUF : IBUF
    port map (
      I => d1(0),
      O => d1_0_IBUF_121
    );
  d2_3_IBUF : IBUF
    port map (
      I => d2(3),
      O => d2_3_IBUF_132
    );
  d2_2_IBUF : IBUF
    port map (
      I => d2(2),
      O => d2_2_IBUF_131
    );
  d2_1_IBUF : IBUF
    port map (
      I => d2(1),
      O => d2_1_IBUF_130
    );
  d2_0_IBUF : IBUF
    port map (
      I => d2(0),
      O => d2_0_IBUF_129
    );
  d3_3_IBUF : IBUF
    port map (
      I => d3(3),
      O => d3_3_IBUF_140
    );
  d3_2_IBUF : IBUF
    port map (
      I => d3(2),
      O => d3_2_IBUF_139
    );
  d3_1_IBUF : IBUF
    port map (
      I => d3(1),
      O => d3_1_IBUF_138
    );
  d3_0_IBUF : IBUF
    port map (
      I => d3(0),
      O => d3_0_IBUF_137
    );
  dec_3_IBUF : IBUF
    port map (
      I => dec(3),
      O => dec_3_IBUF_148
    );
  dec_2_IBUF : IBUF
    port map (
      I => dec(2),
      O => dec_2_IBUF_147
    );
  dec_1_IBUF : IBUF
    port map (
      I => dec(1),
      O => dec_1_IBUF_146
    );
  dec_0_IBUF : IBUF
    port map (
      I => dec(0),
      O => dec_0_IBUF_145
    );
  a_n_3_OBUF : OBUF
    port map (
      I => a_n_3_84,
      O => a_n(3)
    );
  a_n_2_OBUF : OBUF
    port map (
      I => a_n_2_83,
      O => a_n(2)
    );
  a_n_1_OBUF : OBUF
    port map (
      I => a_n_1_82,
      O => a_n(1)
    );
  a_n_0_OBUF : OBUF
    port map (
      I => a_n_0_81,
      O => a_n(0)
    );
  abcdefgdec_n_7_OBUF : OBUF
    port map (
      I => abcdefgdec_n_7_OBUF_100,
      O => abcdefgdec_n(7)
    );
  abcdefgdec_n_6_OBUF : OBUF
    port map (
      I => abcdefgdec_n_6_OBUF_99,
      O => abcdefgdec_n(6)
    );
  abcdefgdec_n_5_OBUF : OBUF
    port map (
      I => abcdefgdec_n_5_OBUF_98,
      O => abcdefgdec_n(5)
    );
  abcdefgdec_n_4_OBUF : OBUF
    port map (
      I => abcdefgdec_n_4_OBUF_97,
      O => abcdefgdec_n(4)
    );
  abcdefgdec_n_3_OBUF : OBUF
    port map (
      I => abcdefgdec_n_3_OBUF_96,
      O => abcdefgdec_n(3)
    );
  abcdefgdec_n_2_OBUF : OBUF
    port map (
      I => abcdefgdec_n_2_OBUF_95,
      O => abcdefgdec_n(2)
    );
  abcdefgdec_n_1_OBUF : OBUF
    port map (
      I => abcdefgdec_n_1_OBUF_94,
      O => abcdefgdec_n(1)
    );
  abcdefgdec_n_0_OBUF : OBUF
    port map (
      I => abcdefgdec_n_0_OBUF_93,
      O => abcdefgdec_n(0)
    );
  disp_0 : FDRS
    port map (
      C => CD_clk_31,
      D => disp_mux0004_0_26,
      R => reset_IBUF_167,
      S => disp_mux0004_0_4_154,
      Q => disp(0)
    );
  disp_1 : FDRS
    port map (
      C => CD_clk_31,
      D => disp_mux0004_1_26,
      R => reset_IBUF_167,
      S => disp_mux0004_1_4_156,
      Q => disp(1)
    );
  disp_2 : FDRS
    port map (
      C => CD_clk_31,
      D => disp_mux0004_2_26,
      R => reset_IBUF_167,
      S => disp_mux0004_2_4_158,
      Q => disp(2)
    );
  disp_3 : FDRS
    port map (
      C => CD_clk_31,
      D => disp_mux0004_3_26,
      R => reset_IBUF_167,
      S => disp_mux0004_3_4_160,
      Q => disp(3)
    );
  dp : FDRS
    port map (
      C => CD_clk_31,
      D => dp_mux000426,
      R => reset_IBUF_167,
      S => dp_mux00044_163,
      Q => dp_161
    );
  CD_Mcount_count_cy_1_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(1),
      O => CD_Mcount_count_cy_1_rt_12
    );
  CD_Mcount_count_cy_2_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(2),
      O => CD_Mcount_count_cy_2_rt_14
    );
  CD_Mcount_count_cy_3_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(3),
      O => CD_Mcount_count_cy_3_rt_16
    );
  CD_Mcount_count_cy_4_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(4),
      O => CD_Mcount_count_cy_4_rt_18
    );
  CD_Mcount_count_cy_5_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(5),
      O => CD_Mcount_count_cy_5_rt_20
    );
  CD_Mcount_count_cy_6_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(6),
      O => CD_Mcount_count_cy_6_rt_22
    );
  CD_Mcount_count_cy_7_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(7),
      O => CD_Mcount_count_cy_7_rt_24
    );
  CD_Mcount_count_cy_8_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(8),
      O => CD_Mcount_count_cy_8_rt_26
    );
  CD_Mcount_count_cy_9_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(9),
      O => CD_Mcount_count_cy_9_rt_28
    );
  CD_Mcount_count_cy_10_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(10),
      O => CD_Mcount_count_cy_10_rt_2
    );
  CD_Mcount_count_cy_11_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(11),
      O => CD_Mcount_count_cy_11_rt_4
    );
  CD_Mcount_count_cy_12_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(12),
      O => CD_Mcount_count_cy_12_rt_6
    );
  CD_Mcount_count_cy_13_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(13),
      O => CD_Mcount_count_cy_13_rt_8
    );
  CD_Mcount_count_cy_14_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(14),
      O => CD_Mcount_count_cy_14_rt_10
    );
  CD_Mcount_count_xor_15_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => CD_count(15),
      O => CD_Mcount_count_xor_15_rt_30
    );
  disp_mux0004_0_261 : LUT4
    generic map(
      INIT => X"AB01"
    )
    port map (
      I0 => count_FSM_FFd4_104,
      I1 => count_FSM_FFd2_102,
      I2 => N14,
      I3 => d3_0_IBUF_137,
      O => disp_mux0004_0_26
    );
  disp_mux0004_1_261 : LUT4
    generic map(
      INIT => X"AB01"
    )
    port map (
      I0 => count_FSM_FFd4_104,
      I1 => count_FSM_FFd2_102,
      I2 => N16,
      I3 => d3_1_IBUF_138,
      O => disp_mux0004_1_26
    );
  disp_mux0004_2_261 : LUT4
    generic map(
      INIT => X"AB01"
    )
    port map (
      I0 => count_FSM_FFd4_104,
      I1 => count_FSM_FFd2_102,
      I2 => N18,
      I3 => d3_2_IBUF_139,
      O => disp_mux0004_2_26
    );
  disp_mux0004_3_261 : LUT4
    generic map(
      INIT => X"AB01"
    )
    port map (
      I0 => count_FSM_FFd4_104,
      I1 => count_FSM_FFd2_102,
      I2 => N20,
      I3 => d3_3_IBUF_140,
      O => disp_mux0004_3_26
    );
  dp_mux0004261 : LUT4
    generic map(
      INIT => X"AB01"
    )
    port map (
      I0 => count_FSM_FFd4_104,
      I1 => count_FSM_FFd2_102,
      I2 => N22,
      I3 => dec_3_IBUF_148,
      O => dp_mux000426
    );
  mclk_BUFGP : BUFGP
    port map (
      I => mclk,
      O => mclk_BUFGP_165
    );
  CD_Mcount_count_lut_0_INV_0 : INV
    port map (
      I => CD_count(0),
      O => CD_Mcount_count_lut(0)
    );
  S7D_abcdefg_dec_0_not00001_INV_0 : INV
    port map (
      I => dp_161,
      O => abcdefgdec_n_0_OBUF_93
    );
  count_FSM_Out61_INV_0 : INV
    port map (
      I => count_FSM_FFd1_101,
      O => count_index0003
    );
  count_FSM_Out51_INV_0 : INV
    port map (
      I => count_FSM_FFd2_102,
      O => count_index0002
    );
  count_FSM_Out41_INV_0 : INV
    port map (
      I => count_FSM_FFd3_103,
      O => count_index0001
    );
  count_FSM_Out31_INV_0 : INV
    port map (
      I => count_FSM_FFd4_104,
      O => count_index0000
    );
  CD_clk_not00011_INV_0 : INV
    port map (
      I => CD_clk_31,
      O => CD_clk_not0001
    );
  CD_count_cmp_eq00004 : LUT4_L
    generic map(
      INIT => X"8000"
    )
    port map (
      I0 => CD_count(12),
      I1 => CD_count(13),
      I2 => CD_count(14),
      I3 => CD_count(15),
      LO => CD_count_cmp_eq00004_52
    );
  disp_mux0004_0_261_SW0 : LUT2_L
    generic map(
      INIT => X"D"
    )
    port map (
      I0 => d0_0_IBUF_113,
      I1 => count_FSM_FFd3_103,
      LO => N14
    );
  disp_mux0004_1_261_SW0 : LUT2_L
    generic map(
      INIT => X"D"
    )
    port map (
      I0 => d0_1_IBUF_114,
      I1 => count_FSM_FFd3_103,
      LO => N16
    );
  disp_mux0004_2_261_SW0 : LUT2_L
    generic map(
      INIT => X"D"
    )
    port map (
      I0 => d0_2_IBUF_115,
      I1 => count_FSM_FFd3_103,
      LO => N18
    );
  disp_mux0004_3_261_SW0 : LUT2_L
    generic map(
      INIT => X"D"
    )
    port map (
      I0 => d0_3_IBUF_116,
      I1 => count_FSM_FFd3_103,
      LO => N20
    );
  dp_mux0004261_SW0 : LUT2_L
    generic map(
      INIT => X"D"
    )
    port map (
      I0 => dec_0_IBUF_145,
      I1 => count_FSM_FFd3_103,
      LO => N22
    );

end Structure;


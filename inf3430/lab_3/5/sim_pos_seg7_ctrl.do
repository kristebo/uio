# load testbench for simulation
vsim work.tb_pos_seg7_ctrl

# add signals to waveform
add wave sim:/tb_pos_seg7_ctrl/arst
add wave sim:/tb_pos_seg7_ctrl/sync_rst
add wave sim:/tb_pos_seg7_ctrl/sp
add wave sim:/tb_pos_seg7_ctrl/a
add wave sim:/tb_pos_seg7_ctrl/b
add wave sim:/tb_pos_seg7_ctrl/force_cw
add wave sim:/tb_pos_seg7_ctrl/force_ccw
add wave sim:/tb_pos_seg7_ctrl/motor_cw
add wave sim:/tb_pos_seg7_ctrl/motor_ccw
add wave sim:/tb_pos_seg7_ctrl/abcdefgdec_n
add wave sim:/tb_pos_seg7_ctrl/a_n
add wave sim:/tb_pos_seg7_ctrl/disp3
add wave sim:/tb_pos_seg7_ctrl/disp2
add wave sim:/tb_pos_seg7_ctrl/disp1
add wave sim:/tb_pos_seg7_ctrl/disp0
add wave sim:/tb_pos_seg7_ctrl/UUT/pos

# run simulation
run 100ms;



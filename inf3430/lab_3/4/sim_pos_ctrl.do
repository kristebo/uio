# load testbench for simulation
vsim work.tb_pos_ctrl

# add signals to waveform
add wave sim:/tb_pos_ctrl/sync_rst
add wave sim:/tb_pos_ctrl/sp
add wave sim:/tb_pos_ctrl/a
add wave sim:/tb_pos_ctrl/b
add wave sim:/tb_pos_ctrl/force_cw
add wave sim:/tb_pos_ctrl/force_ccw
add wave sim:/tb_pos_ctrl/pos
add wave sim:/tb_pos_ctrl/motor_cw
add wave sim:/tb_pos_ctrl/motor_ccw

# run simulation
run 12ms;
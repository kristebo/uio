# load testbench for simulation
vsim work.tb_p_ctrl

# add signals to waveform
add wave sim:/tb_p_ctrl/rst
add wave sim:/tb_p_ctrl/clk
add wave sim:/tb_p_ctrl/sp
add wave sim:/tb_p_ctrl/pos
add wave sim:/tb_p_ctrl/UUT/sp_sync
add wave sim:/tb_p_ctrl/UUT/pos_sync
add wave sim:/tb_p_ctrl/UUT/next_st
add wave sim:/tb_p_ctrl/UUT/present_st
add wave sim:/tb_p_ctrl/UUT/err_next
add wave sim:/tb_p_ctrl/UUT/err
add wave sim:/tb_p_ctrl/UUT/cw_next
add wave sim:/tb_p_ctrl/UUT/ccw_next
add wave sim:/tb_p_ctrl/motor_cw
add wave sim:/tb_p_ctrl/motor_ccw

# run simulation
run 250ns
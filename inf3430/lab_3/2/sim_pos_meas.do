# load testbench for simulation
vsim work.tb_pos_meas

# add signals to waveform
add wave sim:/tb_pos_meas/rst
add wave sim:/tb_pos_meas/sync_rst
add wave sim:/tb_pos_meas/MOT/motor_cw
add wave sim:/tb_pos_meas/MOT/motor_ccw
add wave sim:/tb_pos_meas/a
add wave sim:/tb_pos_meas/b
add wave sim:/tb_pos_meas/pos

# run simulation
run 3000us
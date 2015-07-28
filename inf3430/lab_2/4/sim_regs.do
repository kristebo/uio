# load testbench for simulation
vsim work.tb_regs

# add signals to waveform
add wave sim:/tb_regs/mclk
add wave sim:/tb_regs/sw
add wave sim:/tb_regs/sw7
add wave sim:/tb_regs/sw6
add wave sim:/tb_regs/bt0
add wave sim:/tb_regs/bt1
add wave sim:/tb_regs/abcdefgdec_n
add wave sim:/tb_regs/a_n

# run
run 30ms
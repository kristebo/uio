# load testbench for simulation
vsim work.tb_debounce

# add signals to waveform
add wave sim:/tb_debounce/clk
add wave sim:/tb_debounce/bounced
add wave -radix decimal sim:/tb_debounce/UUT/count
add wave sim:/tb_debounce/debounced

# run simulation
run 400ns
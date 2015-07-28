# load testbench for simulation
vsim work.tb_seg7decoder

# add signals to waveform
add wave sim:/tb_seg7decoder/dec
add wave sim:/tb_seg7decoder/hex
add wave sim:/tb_seg7decoder/abcdefg_dec

# run
run 900ns
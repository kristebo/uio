# load testbench for simulation
vsim work.tb_seg7model

# add signals to waveform
add wave sim:/tb_seg7model/a_n
add wave sim:/tb_seg7model/abcdefgdec_n
add wave sim:/tb_seg7model/disp3
add wave sim:/tb_seg7model/disp2
add wave sim:/tb_seg7model/disp1
add wave sim:/tb_seg7model/disp0

# run
run 350ns
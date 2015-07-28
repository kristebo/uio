# load testbench for simulation
vsim work.tb_seg7ctrl

# add signals to waveform
add wave sim:/tb_seg7ctrl/mclk
add wave sim:/tb_seg7ctrl/reset
add wave sim:/tb_seg7ctrl/d3
add wave sim:/tb_seg7ctrl/d2
add wave sim:/tb_seg7ctrl/d1
add wave sim:/tb_seg7ctrl/d0
add wave sim:/tb_seg7ctrl/disp3
add wave sim:/tb_seg7ctrl/disp2
add wave sim:/tb_seg7ctrl/disp1
add wave sim:/tb_seg7ctrl/disp0
add wave sim:/tb_seg7ctrl/dec
add wave sim:/tb_seg7ctrl/abcdefgdec_n
add wave sim:/tb_seg7ctrl/a_n

# run
run 40ms
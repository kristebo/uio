vcom -work work -93 -explicit decoder_2to4.vhd
vcom -work work -93 -explicit tb_decoder_2to4.vhd

vsim work.tb_decoder_2to4
add wave sim:/tb_decoder_2to4/en
add wave sim:/tb_decoder_2to4/inp
add wave sim:/tb_decoder_2to4/outp
run 600ns

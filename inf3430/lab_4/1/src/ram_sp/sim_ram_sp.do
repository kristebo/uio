# load testbench for simulation
vsim work.tb_ram_sp

# add signals to waveform
add wave sim:/tb_ram_sp/rst
add wave sim:/tb_ram_sp/clk
add wave sim:/tb_ram_sp/adr
add wave sim:/tb_ram_sp/d_in
add wave sim:/tb_ram_sp/d_out
add wave sim:/tb_ram_sp/data_inout
add wave sim:/tb_ram_sp/cs_ram_n
add wave sim:/tb_ram_sp/we_ram_n
add wave sim:/tb_ram_sp/oe_ram_n
add wave sim:/tb_ram_sp/load_run_sp
add wave sim:/tb_ram_sp/UUT/load_run_sp_i
add wave sim:/tb_ram_sp/load_sp_mode
add wave sim:/tb_ram_sp/sp_in
add wave sim:/tb_ram_sp/sp_out

# run simulation
run 1150ns
vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/blk_mem_gen_v8_4_4
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap blk_mem_gen_v8_4_4 activehdl/blk_mem_gen_v8_4_4
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 \
"E:/vivado/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/vivado/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"E:/vivado/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_4_4  -v2k5 \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../MiniMIPS32.srcs/sources_1/ip/data_rom/sim/data_rom.v" \

vlog -work xil_defaultlib \
"glbl.v"

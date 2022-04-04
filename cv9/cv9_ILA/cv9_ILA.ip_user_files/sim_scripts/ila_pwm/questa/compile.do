vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm -64 -sv "+incdir+../../../../../SOURCES/IP/ila_pwm/hdl/verilog" \
"C:/Appz/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Appz/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"C:/Appz/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../../SOURCES/IP/ila_pwm/sim/ila_pwm.vhd" \

vlog -work xil_defaultlib \
"glbl.v"


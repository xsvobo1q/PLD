-makelib ies_lib/xpm -sv \
  "C:/Appz/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Appz/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Appz/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../../SOURCES/IP/ila_pwm/sim/ila_pwm.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib


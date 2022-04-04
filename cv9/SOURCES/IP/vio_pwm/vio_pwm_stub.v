// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2.1 (win64) Build 2729669 Thu Dec  5 04:49:17 MST 2019
// Date        : Mon Apr  4 09:32:37 2022
// Host        : PC-095 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub d:/Documents/PLD/cv9/SOURCES/IP/vio_pwm/vio_pwm_stub.v
// Design      : vio_pwm
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2019.2.1" *)
module vio_pwm(clk, probe_in0, probe_in1, probe_out0, 
  probe_out1, probe_out2, probe_out3, probe_out4, probe_out5, probe_out6, probe_out7, probe_out8, 
  probe_out9, probe_out10, probe_out11)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[7:0],probe_in1[7:0],probe_out0[7:0],probe_out1[7:0],probe_out2[7:0],probe_out3[7:0],probe_out4[7:0],probe_out5[7:0],probe_out6[7:0],probe_out7[7:0],probe_out8[3:0],probe_out9[3:0],probe_out10[3:0],probe_out11[3:0]" */;
  input clk;
  input [7:0]probe_in0;
  input [7:0]probe_in1;
  output [7:0]probe_out0;
  output [7:0]probe_out1;
  output [7:0]probe_out2;
  output [7:0]probe_out3;
  output [7:0]probe_out4;
  output [7:0]probe_out5;
  output [7:0]probe_out6;
  output [7:0]probe_out7;
  output [3:0]probe_out8;
  output [3:0]probe_out9;
  output [3:0]probe_out10;
  output [3:0]probe_out11;
endmodule

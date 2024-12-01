// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Mon Oct 25 14:49:22 2021
// Host        : DESKTOP-98UFVIK running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               f:/coa/nscscc2021/func_test_v0.01/cpu132_gettrace/run_vivado/cpu132_gettrace/cpu132_gettrace.srcs/sources_1/ip/clk_pll0/clk_pll0_stub.v
// Design      : clk_pll0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_pll0(cpu_clk, timer_clk, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="cpu_clk,timer_clk,clk_in1" */;
  output cpu_clk;
  output timer_clk;
  input clk_in1;
endmodule

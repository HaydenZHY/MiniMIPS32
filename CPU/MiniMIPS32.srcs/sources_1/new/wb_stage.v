`include "defines.v"

module wb_stage (

    // 从访存阶段获得的信息
    input wire                   wb_mreg_i,
    input wire [      `BSEL_BUS] wb_dre_i,
    input wire [  `REG_ADDR_BUS] wb_wa_i,
    input wire                   wb_wreg_i,
    input wire [       `REG_BUS] wb_dreg_i,
    input wire                   wb_whilo_i,
    input wire [`DOUBLE_REG_BUS] wb_hilo_i,
    input wire                   wb_whi_i,
    input wire                   wb_wlo_i,
    input wire [ `INST_ADDR_BUS] wb_debug_wb_pc, // 供调试使用的PC值，上板测试时务必删除该信号

    input wire [`WORD_BUS] dm,

    // 写回目的寄存器的数据
    output wire [  `REG_ADDR_BUS] wb_wa_o,
    output wire                   wb_wreg_o,
    output wire [      `WORD_BUS] wb_wd_o,
    output wire                   wb_whilo_o,
    output wire [`DOUBLE_REG_BUS] wb_hilo_o,
    output wire                   wb_whi_o,
    output wire                   wb_wlo_o,

    //hilo寄存器数据相关
    output wire [          1 : 0] wb2exe_whilo,
    output wire [`DOUBLE_REG_BUS] wb2exe_hilo,

    //cp0
    input  wire                 wb_cp0_we_i,
    input  wire [`REG_ADDR_BUS] wb_cp0_wa_i,
    input  wire [     `REG_BUS] wb_cp0_wd_i,
    output wire                 wb_cp0_we_o,
    output wire [`REG_ADDR_BUS] wb_cp0_wa_o,
    output wire [     `REG_BUS] wb_cp0_wd_o,

    output wire [`INST_ADDR_BUS] debug_wb_pc,       // 供调试使用的PC值，上板测试时务必删除该信号
    output wire                  debug_wb_rf_wen,   // 供调试使用的PC值，上板测试时务必删除该信号
    output wire [ `REG_ADDR_BUS] debug_wb_rf_wnum,  // 供调试使用的PC值，上板测试时务必删除该信号
    output wire [     `WORD_BUS] debug_wb_rf_wdata  // 供调试使用的PC值，上板测试时务必删除该信号
);

  assign wb_cp0_we_o = wb_cp0_we_i;
  assign wb_cp0_wa_o = wb_cp0_wa_i;
  assign wb_cp0_wd_o = wb_cp0_wd_i;

  // 传至通用寄存器堆和HILO寄存器的信号
  assign wb_wa_o     = wb_wa_i;
  assign wb_wreg_o   = wb_wreg_i;
  assign wb_whilo_o  = wb_whilo_i;
  assign wb_hilo_o   = wb_hilo_i;
  assign wb_whi_o    = wb_whi_i;
  assign wb_wlo_o    = wb_wlo_i;

  // 根据读字节使能信号，从数据存储器读出的数据中选择对应的字节   
  wire[`WORD_BUS] data = (wb_dre_i == 4'b1111) ? {dm[7:0], dm[15:8], dm[23:16], dm[31:24]} :
                            (wb_dre_i == 4'b1000) ? {{24{dm[31]}}, dm[31:24]} :
                            (wb_dre_i == 4'b0100) ? {{24{dm[23]}}, dm[23:16]} :
                            (wb_dre_i == 4'b0010) ? {{24{dm[15]}}, dm[15:8]} :
                            (wb_dre_i == 4'b0001) ? {{24{dm[7]}}, dm[7:0]} :
                            (wb_dre_i == 4'b1100) ? {{16{dm[23]}}, dm[23:16], dm[31:24]} :
                            (wb_dre_i == 4'b0011) ? {{16{dm[7]}}, dm[7:0], dm[15:8]} : `ZERO_WORD;
  // 根据存储器到寄存器使能信号mreg，选择最终待写入通用寄存器的数据
  assign wb_wd_o           = (wb_mreg_i == `MREG_ENABLE) ? data : wb_dreg_i;

  assign debug_wb_pc       = wb_debug_wb_pc;  // 上板测试时务必删除该语句
  assign debug_wb_rf_wen   = wb_wreg_o;  // 上板测试时务必删除该语句 
  assign debug_wb_rf_wdata = wb_wd_o;  // 上板测试时务必删除该语句 
  assign debug_wb_rf_wnum  = wb_wa_o;  // 上板测试时务必删除该语句
  assign wb2exe_whilo      = {wb_whi_i, wb_wlo_i};
  assign wb2exe_hilo       = wb_hilo_i;

endmodule

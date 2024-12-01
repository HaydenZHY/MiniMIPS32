`include "defines.v"

module memwb_reg (
    input  wire                   cpu_clk_50M,
    input  wire                   cpu_rst_n,
    // 来自访存阶段的信息
    input  wire [     `ALUOP_BUS] mem_aluop,
    input  wire                   mem_whilo,
    input  wire [  `REG_ADDR_BUS] mem_wa,
    input  wire                   mem_wreg,
    input  wire [       `REG_BUS] mem_dreg,
    input  wire                   mem_mreg,
    input  wire [`DOUBLE_REG_BUS] mem_mulres,
    input  wire [       `REG_BUS] mem_dm,
    input  wire [      `BSEL_BUS] mem_dre,
    input  wire [ `INST_ADDR_BUS] mem_debug_wb_pc,  // 供调试使用的PC值，上板测试时务必删除该信号
    // 送至写回阶段的信息 
    output reg  [     `ALUOP_BUS] wb_aluop,
    output reg                    wb_whilo,
    output reg  [  `REG_ADDR_BUS] wb_wa,
    output reg                    wb_wreg,
    output reg  [       `REG_BUS] wb_dreg,
    output reg                    wb_mreg,
    output reg  [`DOUBLE_REG_BUS] wb_mulres,
    output wire [       `REG_BUS] wb_dm,
    output reg  [      `BSEL_BUS] wb_dre,
    output reg  [ `INST_ADDR_BUS] wb_debug_wb_pc,   // 供调试使用的PC值，上板测试时务必删除该信号
    //cp0
    input  wire                   flush,
    //cp02
    input  wire                   mem_cp0_we,
    input  wire [  `REG_ADDR_BUS] mem_cp0_wa,
    input  wire [       `REG_BUS] mem_cp0_wd,
    output reg                    wb_cp0_we,
    output reg  [  `REG_ADDR_BUS] wb_cp0_wa,
    output reg  [       `REG_BUS] wb_cp0_wd
);

  always @(posedge cpu_clk_50M) begin

    if (cpu_rst_n == `RST_ENABLE || flush) begin
      wb_aluop       <= `MINIMIPS32_SLL;
      wb_whilo       <= `WHILO_DISABLE;
      wb_wa          <= `REG_NOP;
      wb_wreg        <= `WRITE_DISABLE;
      wb_dreg        <= `ZERO_WORD;
      wb_mreg        <= `MREG_DISABLE;
      wb_mulres      <= `ZERO_DWORD;
      wb_dre         <= 4'b0000;
      wb_debug_wb_pc <= `PC_INIT;
      //cp02
      wb_cp0_we      <= 0;
      wb_cp0_wa      <= `REG_NOP;
      wb_cp0_wd      <= `ZERO_WORD;
    end else begin
      wb_aluop       <= mem_aluop;
      wb_whilo       <= mem_whilo;
      wb_wa          <= mem_wa;
      wb_wreg        <= mem_wreg;
      wb_dreg        <= mem_dreg;
      wb_mreg        <= mem_mreg;
      wb_mulres      <= mem_mulres;
      wb_dre         <= mem_dre;
      wb_debug_wb_pc <= mem_debug_wb_pc;
      //cp02
      wb_cp0_we      <= mem_cp0_we;
      wb_cp0_wa      <= mem_cp0_wa;
      wb_cp0_wd      <= mem_cp0_wd;
    end
  end
  assign wb_dm = mem_dm;
endmodule

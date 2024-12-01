`include "defines.v"

module exemem_reg (
    input wire cpu_clk_50M,
    input wire cpu_rst_n,

    // 来自执行阶段的信息
    input  wire [     `ALUOP_BUS] exe_aluop,
    input  wire                   exe_whilo,
    input  wire [  `REG_ADDR_BUS] exe_wa,
    input  wire                   exe_wreg,
    input  wire                   exe_mreg,
    input  wire [       `REG_BUS] exe_din,
    input  wire [       `REG_BUS] exe_wd,
    input  wire [`DOUBLE_REG_BUS] exe_mulres,
    input  wire [ `INST_ADDR_BUS] exe_debug_wb_pc,  // 供调试使用的PC值，上板测试时务必删除该信号
    input  wire [          3 : 0] stall,
    // 送到访存阶段的信息 
    output reg  [     `ALUOP_BUS] mem_aluop,
    output reg                    mem_whilo,
    output reg  [  `REG_ADDR_BUS] mem_wa,
    output reg                    mem_wreg,
    output reg                    mem_mreg,
    output reg  [       `REG_BUS] mem_wd,
    output reg  [`DOUBLE_REG_BUS] mem_mulres,
    output reg  [       `REG_BUS] mem_din,
    output reg  [ `INST_ADDR_BUS] mem_debug_wb_pc,  // 供调试使用的PC值，上板测试时务必删除该信号
    //cp0
    input  wire                   flush,
    input  wire                   exe_c_ds,
    input  wire [   `EXCTYPE_BUS] exe_exctype,
    input  wire [ `INST_ADDR_BUS] exe_cur_pc,
    output reg                    mem_c_ds,
    output reg  [   `EXCTYPE_BUS] mem_exctype,
    output reg  [ `INST_ADDR_BUS] mem_cur_pc,
    //cp02
    input  wire                   exe_cp0_we,
    input  wire [  `REG_ADDR_BUS] exe_cp0_wa,
    input  wire [       `REG_BUS] exe_cp0_wd,
    output reg                    mem_cp0_we,
    output reg  [  `REG_ADDR_BUS] mem_cp0_wa,
    output reg  [       `REG_BUS] mem_cp0_wd
);
  always @(posedge cpu_clk_50M) begin
    if (cpu_rst_n == `RST_ENABLE || flush == 1) begin
      mem_aluop       <= `MINIMIPS32_SLL;
      mem_whilo       <= `WHILO_DISABLE;
      mem_wa          <= `REG_NOP;
      mem_wreg        <= `WRITE_DISABLE;
      mem_mreg        <= `MREG_DISABLE;
      mem_wd          <= `ZERO_WORD;
      mem_mulres      <= `ZERO_DWORD;
      mem_din         <= `ZERO_WORD;
      mem_debug_wb_pc <= `PC_INIT;  // 上板测试时务必删除该语句
      //cp0
      mem_c_ds        <= 0;
      mem_exctype     <= `noexe;
      mem_cur_pc      <= `PC_INIT;
      //cp02
      mem_cp0_we      <= 0;
      mem_cp0_wa      <= `REG_NOP;
      mem_cp0_wd      <= `ZERO_WORD;
    end else begin
      if (stall[0] == `STOP_ENABLE) begin
        mem_aluop       <= `MINIMIPS32_SLL;
        mem_whilo       <= `WHILO_DISABLE;
        mem_wa          <= `REG_NOP;
        mem_wreg        <= `WRITE_DISABLE;
        mem_mreg        <= `MREG_DISABLE;
        mem_wd          <= `ZERO_WORD;
        mem_mulres      <= `ZERO_DWORD;
        mem_din         <= `ZERO_WORD;
        mem_debug_wb_pc <= `PC_INIT;
        //cp0
        mem_c_ds        <= 0;
        mem_exctype     <= `noexe;
        mem_cur_pc      <= `PC_INIT;
        //cp02
        mem_cp0_we      <= 0;
        mem_cp0_wa      <= `REG_NOP;
        mem_cp0_wd      <= `ZERO_WORD;
      end else begin
        mem_aluop       <= exe_aluop;
        mem_whilo       <= exe_whilo;
        mem_wa          <= exe_wa;
        mem_wreg        <= exe_wreg;
        mem_mreg        <= exe_mreg;
        mem_wd          <= exe_wd;
        mem_mulres      <= exe_mulres;
        mem_din         <= exe_din;
        mem_debug_wb_pc <= exe_debug_wb_pc;  // 上板测试时务必删除该语句
        //cp0
        mem_c_ds        <= exe_c_ds;
        mem_exctype     <= exe_exctype;
        mem_cur_pc      <= exe_cur_pc;
        //cp02
        mem_cp0_we      <= exe_cp0_we;
        mem_cp0_wa      <= exe_cp0_wa;
        mem_cp0_wd      <= exe_cp0_wd;
      end
    end
  end

endmodule

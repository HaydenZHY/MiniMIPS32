`include "defines.v"

module memwb_reg (
    input wire cpu_clk_50M,
    input wire cpu_rst_n,

    // 来自访存阶段的信息
    input wire                   mem_whilo,
    input wire [`DOUBLE_REG_BUS] mem_hilo,
    input wire [  `REG_ADDR_BUS] mem_wa,
    input wire                   mem_wreg,
    input wire [       `REG_BUS] mem_dreg,
    input wire                   mem_mreg,
    input wire [       `REG_BUS] mem_din,
    input wire [      `BSEL_BUS] mem_dre,

    input wire mem_whi,
    input wire mem_wlo,

    input wire [`INST_ADDR_BUS] mem_debug_wb_pc,  // 供调试使用的PC值，上板测试时务必删除该信号

    // 送至写回阶段的信息 
    output reg                   wb_whilo,
    output reg [`DOUBLE_REG_BUS] wb_hilo,
    output reg [  `REG_ADDR_BUS] wb_wa,
    output reg                   wb_wreg,
    output reg [       `REG_BUS] wb_dreg,
    output reg                   wb_mreg,
    output reg [       `REG_BUS] wb_din,
    output reg [      `BSEL_BUS] wb_dre,

    output reg wb_whi,
    output reg wb_wlo,

    output reg [`INST_ADDR_BUS] wb_debug_wb_pc,  // 供调试使用的PC值，上板测试时务必删除该信号

	  //cp0和cp2
    input  wire                      mem_cp0_we,
    input wire  [`REG_ADDR_BUS ]     mem_cp0_wa,
	  input  wire  [`REG_BUS      ]     mem_cp0_wd,
    output  reg                       wb_cp0_we,
    output  reg  [`REG_ADDR_BUS ]     wb_cp0_wa,
	  output  reg  [`REG_BUS      ]     wb_cp0_wd
);


  always @(posedge cpu_clk_50M) begin
    // 复位的时候将送至写回阶段的信息清0
    if (cpu_rst_n == `RST_ENABLE) begin
      wb_wa    <= `REG_NOP;
      wb_wreg  <= `WRITE_DISABLE;
      wb_dreg  <= `ZERO_WORD;
      wb_whilo <= `WRITE_DISABLE;
      wb_hilo  <= `ZERO_DWORD;
      wb_dre   <= 4'b0;
      wb_mreg  <= `WRITE_DISABLE;
      wb_whi   <= `WRITE_DISABLE;
      wb_wlo   <= `WRITE_DISABLE;
      //cp02
			wb_cp0_we             <= 0;
			wb_cp0_wa             <= `REG_NOP;
			wb_cp0_wd             <= `ZERO_WORD;
    end  // 将来自访存阶段的信息寄存并送至写回阶段
    else begin
      wb_wa          <= mem_wa;
      wb_wreg        <= mem_wreg;
      wb_dreg        <= mem_dreg;
      wb_whilo       <= mem_whilo;
      wb_hilo        <= mem_hilo;
      wb_mreg        <= mem_mreg;
      wb_dre         <= mem_dre;
      wb_whi         <= mem_whi;
      wb_wlo         <= mem_wlo;
      wb_debug_wb_pc <= mem_debug_wb_pc;
      //cp02
			wb_cp0_we             <= mem_cp0_we;
			wb_cp0_wa             <= mem_cp0_wa;
			wb_cp0_wd             <= mem_cp0_wd;
    end
  end

endmodule

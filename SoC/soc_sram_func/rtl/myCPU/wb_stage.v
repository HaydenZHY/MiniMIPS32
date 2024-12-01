`include "defines.v"

module wb_stage (
    input wire [     `ALUOP_BUS] wb_aluop_i,
    input wire                   wb_whilo_i,
    input wire [`DOUBLE_REG_BUS] wb_mulres_i,
    input wire [  `REG_ADDR_BUS] wb_wa_i,
    input wire                   wb_wreg_i,
    input wire [       `REG_BUS] wb_dreg_i,
    input wire                   wb_mreg_i,
    input wire [      `WORD_BUS] wb_dm_i,
    input wire [      `BSEL_BUS] wb_dre_i,
    input wire [ `INST_ADDR_BUS] wb_debug_wb_pc,

    output wire                 wb_whilo_o,
    output wire [`REG_ADDR_BUS] wb_wa_o,
    output wire                 wb_wreg_o,
    output wire [    `WORD_BUS] wb_wd_o,
    output reg  [    `WORD_BUS] wb_hi_o,
    output reg  [    `WORD_BUS] wb_lo_o,

    output wire [ `INST_ADDR_BUS] debug_wb_pc,
    output wire [            3:0] debug_wb_rf_wen,
    output wire [  `REG_ADDR_BUS] debug_wb_rf_wnum,
    output wire [      `WORD_BUS] debug_wb_rf_wdata,
    output wire [          1 : 0] wb2exe_whilo,
    output wire [`DOUBLE_REG_BUS] wb2exe_hilo,
    //cp02
    input  wire                   wb_cp0_we_i,
    input  wire [  `REG_ADDR_BUS] wb_cp0_wa_i,
    input  wire [       `REG_BUS] wb_cp0_wd_i,
    output wire                   wb_cp0_we_o,
    output wire [  `REG_ADDR_BUS] wb_cp0_wa_o,
    output wire [       `REG_BUS] wb_cp0_wd_o
);
  reg [`WORD_BUS] dm;
  always @(*) begin
    if (wb_whilo_i == `WHILO_ENABLE) begin
      case (wb_aluop_i)
        `MINIMIPS32_MTHI: begin
          wb_hi_o = wb_dreg_i;
        end
        `MINIMIPS32_MTLO: begin
          wb_lo_o = wb_dreg_i;
        end
        `MINIMIPS32_MULT: begin
          wb_lo_o = wb_mulres_i[31 : 0];
          wb_hi_o = wb_mulres_i[63 : 32];
        end
        `MINIMIPS32_MULTU: begin
          wb_lo_o = wb_mulres_i[31 : 0];
          wb_hi_o = wb_mulres_i[63 : 32];
        end
        `MINIMIPS32_DIV: begin
          wb_lo_o = wb_mulres_i[31 : 0];
          wb_hi_o = wb_mulres_i[63 : 32];
        end
        `MINIMIPS32_DIVU: begin
          wb_lo_o = wb_mulres_i[31 : 0];
          wb_hi_o = wb_mulres_i[63 : 32];
        end
        default: ;
      endcase
    end else;
  end
  always @(*) begin
    if (wb_aluop_i == `MINIMIPS32_LB || wb_aluop_i == `MINIMIPS32_LBU) begin
      if (wb_dre_i[3] == 1'b1) begin
        dm[7 : 0] = wb_dm_i[31 : 24];
      end else if (wb_dre_i[2] == 1'b1) begin
        dm[7 : 0] = wb_dm_i[23 : 16];
      end else if (wb_dre_i[1] == 1'b1) begin
        dm[7 : 0] = wb_dm_i[15 : 8];
      end else if (wb_dre_i[0] == 1'b1) begin
        dm[7 : 0] = wb_dm_i[7 : 0];
      end
      if (dm[7] == 1 && wb_aluop_i == `MINIMIPS32_LB) begin
        dm = {24'hFFFFFF, dm[7:0]};
      end else begin
        dm = {24'h000000, dm[7:0]};
      end
    end else if (wb_aluop_i == `MINIMIPS32_LH || wb_aluop_i == `MINIMIPS32_LHU) begin
      if (wb_dre_i == 4'b1100) begin
        dm[7 : 0]  = wb_dm_i[31 : 24];
        dm[15 : 8] = wb_dm_i[23 : 16];
      end else if (wb_dre_i == 4'b0011) begin

        dm[7 : 0]  = wb_dm_i[15 : 8];
        dm[15 : 8] = wb_dm_i[7 : 0];
      end
      if (dm[15] == 1 && wb_aluop_i == `MINIMIPS32_LH) begin
        dm = {16'hFFFF, dm[15:0]};
      end else begin
        dm = {16'h0000, dm[15:0]};
      end
    end else if (wb_aluop_i == `MINIMIPS32_LW) begin
      dm[7 : 0]   = (wb_dre_i[3] == 1'b1) ? wb_dm_i[31 : 24] : 8'b00000000;
      dm[15 : 8]  = (wb_dre_i[2] == 1'b1) ? wb_dm_i[23 : 16] : 8'b00000000;
      dm[23 : 16] = (wb_dre_i[1] == 1'b1) ? wb_dm_i[15 : 8] : 8'b00000000;
      dm[31 : 24] = (wb_dre_i[0] == 1'b1) ? wb_dm_i[7 : 0] : 8'b00000000;

    end
  end
  // 传至通用寄存器堆和HILO寄存器的信号
  assign wb_wa_o           = wb_wa_i;
  assign wb_wreg_o         = wb_wreg_i;
  assign wb_whilo_o        = wb_whilo_i;
  //cp02
  assign wb_cp0_we_o       = wb_cp0_we_i;
  assign wb_cp0_wa_o       = wb_cp0_wa_i;
  assign wb_cp0_wd_o       = wb_cp0_wd_i;

  assign wb_wd_o           = (wb_mreg_i == `MREG_ENABLE) ? dm : wb_dreg_i;
  assign debug_wb_pc       = wb_debug_wb_pc;
  assign debug_wb_rf_wen   = {wb_wreg_i, wb_wreg_i, wb_wreg_i, wb_wreg_i};
  assign debug_wb_rf_wnum  = wb_wa_i;
  assign debug_wb_rf_wdata = wb_wd_o;
  assign wb2exe_whilo      = (wb_aluop_i == `MINIMIPS32_MTHI) ? 2'b10 : (wb_aluop_i == `MINIMIPS32_MTLO) ? 2'b01 : {wb_whilo_i, wb_whilo_i};
  assign wb2exe_hilo       = (wb_aluop_i == `MINIMIPS32_MTHI) ? {wb_dreg_i, 32'h0000} : (wb_aluop_i == `MINIMIPS32_MTLO) ? {32'h0000, wb_dreg_i} : wb_mulres_i;
endmodule

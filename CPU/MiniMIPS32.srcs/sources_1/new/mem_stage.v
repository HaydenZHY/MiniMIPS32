`include "defines.v"

module mem_stage (

    // 从执行阶段获得的信息
    input  wire [     `ALUOP_BUS] mem_aluop_i,
    input  wire                   mem_whilo_i,
    input  wire [  `REG_ADDR_BUS] mem_wa_i,
    input  wire                   mem_wreg_i,
    input  wire [       `REG_BUS] mem_wd_i,
    input  wire [`DOUBLE_REG_BUS] mem_mulres_i,
    input  wire                   mem_mreg_i,
    input  wire [      `WORD_BUS] mem_din_i,
    input  wire [ `INST_ADDR_BUS] mem_debug_wb_pc_i,  // 供调试使用的PC值，上板测试时务必删除该信号
    //从数据存储器获取的信息
    input  wire [      `WORD_BUS] dm,
    // 送至写回阶段的信息
    output wire [     `ALUOP_BUS] mem_aluop_o,
    output wire                   mem_whilo_o,
    output wire [  `REG_ADDR_BUS] mem_wa_o,
    output wire                   mem_wreg_o,
    output wire [       `REG_BUS] mem_dreg_o,
    output wire                   mem_mreg_o,
    output wire [      `WORD_BUS] mem_dm_o,
    output wire [      `BSEL_BUS] dre,
    output wire [`DOUBLE_REG_BUS] mem_mulres_o,
    //送入数据存储器的信息
    output wire                   dce,
    output wire [         31 : 0] daddr,
    output wire [      `BSEL_BUS] we,
    output reg  [      `WORD_BUS] din,
    output wire [ `INST_ADDR_BUS] debug_wb_pc,        // 供调试使用的PC值，上板测试时务必删除该信号

    output wire [          1 : 0] mem2exe_whilo,
    output wire [`DOUBLE_REG_BUS] mem2exe_hilo,
    output wire [     `ALUOP_BUS] mem2exe_aluop,
    //back to idstage
    output wire [  `REG_ADDR_BUS] mem2id_wa,
    output wire                   mem2id_wreg,
    output wire [       `REG_BUS] mem2id_wd,
    output wire                   mem2id_mreg,
    //cp0
    input  wire                   mem_c_ds_i,
    input  wire [   `EXCTYPE_BUS] mem_exctype_i,
    input  wire [ `INST_ADDR_BUS] mem_cur_pc_i,
    output wire                   mem_c_ds_o,
    output reg  [   `EXCTYPE_BUS] mem_exctype_o,
    output wire [ `INST_ADDR_BUS] mem_cur_pc_o,
    output wire [       `REG_BUS] mem_badvaddr_o,
    //input from cp0
    input  wire [       `REG_BUS] in_Status,
    input  wire [       `REG_BUS] in_Cause,
    //cp02
    input  wire                   mem_cp0_we_i,
    input  wire [  `REG_ADDR_BUS] mem_cp0_wa_i,
    input  wire [       `REG_BUS] mem_cp0_wd_i,
    output wire                   mem_cp0_we_o,
    output wire [  `REG_ADDR_BUS] mem_cp0_wa_o,
    output wire [       `REG_BUS] mem_cp0_wd_o
);

  // 如果当前不是访存指令，则只需要把从执行阶段获得的信息直接输出
  assign mem_wa_o    = mem_wa_i;
  assign mem2id_wa   = mem_wa_i;
  assign mem_wreg_o  = mem_wreg_i;
  assign mem2id_wreg = mem_wreg_i;
  assign mem_dreg_o  = mem_wd_i;
  assign mem2id_wd   = mem_wd_i;
  assign mem_whilo_o = mem_whilo_i;
  assign mem_aluop_o = mem_aluop_i;
  assign mem_mreg_o  = mem_mreg_i;
  assign mem_dm_o    = dm;
  reg [3:0] wevalue;
  reg [3:0] drevalue;
  //cp02
  assign mem_cp0_we_o = mem_cp0_we_i;
  assign mem_cp0_wa_o = mem_cp0_wa_i;
  assign mem_cp0_wd_o = mem_cp0_wd_i;
  //cp0
  wire [`REG_BUS] Cause = (mem_cp0_we_i == `WRITE_ENABLE && mem_cp0_wa_i == `Cause_ID) ? mem_cp0_wd_i : in_Cause;
  wire [`REG_BUS] Status = (mem_cp0_we_i == `WRITE_ENABLE && mem_cp0_wa_i == `Status_ID) ? mem_cp0_wd_i : in_Status;
  //MCU
  reg                                                                                                                adel;
  reg                                                                                                                ades;
  always @(*) begin
    if (mem_aluop_o == `MINIMIPS32_SB) begin
      ades = 0;
      din  = {mem_din_i[7:0], mem_din_i[7:0], mem_din_i[7:0], mem_din_i[7:0]};
      case (mem_wd_i[1:0])
        2'b00: begin
          wevalue = 4'b1000;
        end
        2'b01: begin
          wevalue = 4'b0100;
        end
        2'b10: begin
          wevalue = 4'b0010;
        end
        2'b11: begin
          wevalue = 4'b0001;
        end
      endcase
    end else if (mem_aluop_o == `MINIMIPS32_SH) begin
      din = {mem_din_i[7:0], mem_din_i[15:8], mem_din_i[7:0], mem_din_i[15:8]};
      case (mem_wd_i[1:0])
        2'b00: begin
          wevalue = 4'b1100;
          ades    = 0;
        end
        2'b10: begin
          wevalue = 4'b0011;
          ades    = 0;
        end
        default: begin
          ades    = 1;
          din     = 32'h0000;
          wevalue = 4'b0000;
        end
      endcase
    end else if (mem_aluop_o == `MINIMIPS32_SW) begin
      if (mem_wd_i[1:0] == 2'b00) begin
        din     = {mem_din_i[7:0], mem_din_i[15:8], mem_din_i[23:16], mem_din_i[31:24]};
        wevalue = 4'b1111;
        ades    = 0;
      end else begin
        ades    = 1;
        din     = 32'h0000;
        wevalue = 4'b0000;
      end
    end else begin
      ades    = 0;
      din     = 32'h0000;
      wevalue = 4'b0000;
    end

    if (mem_aluop_o == `MINIMIPS32_LB || mem_aluop_o == `MINIMIPS32_LBU) begin
      adel = 0;
      case (mem_wd_i[1:0])
        2'b00: begin
          drevalue = 4'b1000;
        end
        2'b01: begin
          drevalue = 4'b0100;
        end
        2'b10: begin
          drevalue = 4'b0010;
        end
        2'b11: begin
          drevalue = 4'b0001;
        end
      endcase
    end else if (mem_aluop_o == `MINIMIPS32_LH || mem_aluop_o == `MINIMIPS32_LHU) begin
      case (mem_wd_i[1:0])
        2'b00: begin
          drevalue = 4'b1100;
          adel     = 0;
        end
        2'b10: begin
          drevalue = 4'b0011;
          adel     = 0;
        end
        default: begin
          adel     = 1;
          drevalue = 4'b0000;
        end
      endcase
    end else if (mem_aluop_o == `MINIMIPS32_LW) begin
      if (mem_wd_i[1:0] == 2'b00) begin
        drevalue = 4'b1111;
        adel     = 0;
      end else begin
        adel     = 1;
        drevalue = 4'b0000;
      end
    end else begin
      adel     = 0;
      drevalue = 4'b0000;
    end
  end
  assign dre            = drevalue;
  assign we             = wevalue;
  assign mem_mulres_o   = mem_mulres_i;
  //送入数据寄存器的值
  assign dce            = (mem_aluop_o == `MINIMIPS32_SW || mem_aluop_o == `MINIMIPS32_LB || mem_aluop_o == `MINIMIPS32_LBU || mem_aluop_o == `MINIMIPS32_LH || mem_aluop_o == `MINIMIPS32_LHU || mem_aluop_o == `MINIMIPS32_LW || mem_aluop_o == `MINIMIPS32_SB || mem_aluop_o == `MINIMIPS32_SH) ? 1 : 0;
  assign daddr          = {mem_wd_i};
  assign debug_wb_pc    = mem_debug_wb_pc_i;  // 上板测试时务必删除该语句 

  assign mem2exe_aluop  = mem_aluop_i;
  assign mem2exe_whilo  = (mem_aluop_i == `MINIMIPS32_MTHI) ? 2'b10 : (mem_aluop_i == `MINIMIPS32_MTLO) ? 2'b01 : {mem_whilo_i, mem_whilo_i};
  assign mem2exe_hilo   = (mem_aluop_i == `MINIMIPS32_MTHI) ? {mem_wd_i, 32'h0000} : (mem_aluop_i == `MINIMIPS32_MTLO) ? {32'h0000, mem_wd_i} : mem_mulres_i;
  assign mem2id_mreg    = mem_mreg_i;
  //cp0
  assign mem_cur_pc_o   = mem_cur_pc_i;
  assign mem_c_ds_o     = mem_c_ds_i;
  assign mem_badvaddr_o = (mem_cur_pc_i[1:0] != 2'b00) ? mem_cur_pc_i : mem_wd_i;
  always @(*) begin
    if ((Status[15:8] & Cause[15:8] != 8'h00) && Status[1] == 0 && Status[0] == 1) begin
      mem_exctype_o = `Int;
    end else if ((mem_aluop_o == `MINIMIPS32_SB || mem_aluop_o == `MINIMIPS32_SH || mem_aluop_o == `MINIMIPS32_SW) && ades == 1) begin
      mem_exctype_o = `ADES;
    end else if ((mem_aluop_o == `MINIMIPS32_LB || mem_aluop_o == `MINIMIPS32_LBU || mem_aluop_o == `MINIMIPS32_LH || mem_aluop_o == `MINIMIPS32_LHU || mem_aluop_o == `MINIMIPS32_LW) && adel == 1) begin
      mem_exctype_o = `ADEL;
    end else begin
      mem_exctype_o = mem_exctype_i;
    end
  end
endmodule

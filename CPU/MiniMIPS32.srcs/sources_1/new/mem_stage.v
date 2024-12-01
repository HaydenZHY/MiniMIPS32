`include "defines.v"

module mem_stage (

    // ��ִ�н׶λ�õ���Ϣ
    input wire [     `ALUOP_BUS] mem_aluop_i,
    input wire [  `REG_ADDR_BUS] mem_wa_i,
    input wire                   mem_wreg_i,
    input wire [       `REG_BUS] mem_wd_i,
    input wire                   mem_mreg_i,
    input wire [       `REG_BUS] mem_din_i,
    input wire                   mem_whilo_i,
    input wire [`DOUBLE_REG_BUS] mem_hilo_i,
    input wire                   mem_whi_i,
    input wire                   mem_wlo_i,

    input wire [`INST_ADDR_BUS] mem_debug_wb_pc,  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�

    // ����д�ؽ׶ε���Ϣ
    output wire [  `REG_ADDR_BUS] mem_wa_o,
    output wire                   mem_wreg_o,
    output wire [       `REG_BUS] mem_dreg_o,
    output wire                   mem_mreg_o,
    output wire                   mem_whilo_o,
    output wire [`DOUBLE_REG_BUS] mem_hilo_o,
    output wire                   mem_whi_o,
    output wire                   mem_wlo_o,
    output wire [      `BSEL_BUS] dre,

    output wire [`INST_ADDR_BUS] debug_wb_pc,  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�

    output wire                  dce,
    output wire [`INST_ADDR_BUS] daddr,
    output wire [     `BSEL_BUS] we,
    output wire [      `REG_BUS] din,

    //mem2id����ǰ��
    output wire [`REG_ADDR_BUS] mem2id_wa,
    output wire                 mem2id_wreg,
    output wire [     `REG_BUS] mem2id_wd,

    //hilo�Ĵ����������
    output wire [          1 : 0] mem2exe_whilo,
    output wire [`DOUBLE_REG_BUS] mem2exe_hilo,

    //cp0
    input  wire                  mem_c_ds_i,
    input  wire [  `EXCTYPE_BUS] mem_exctype_i,
    input  wire [`INST_ADDR_BUS] mem_cur_pc_i,
    output wire                  mem_c_ds_o,
    output reg  [  `EXCTYPE_BUS] mem_exctype_o,
    output wire [`INST_ADDR_BUS] mem_cur_pc_o,
    output wire [      `REG_BUS] mem_badvaddr_o,

    //cp02
    input  wire                 mem_cp0_we_i,
    input  wire [`REG_ADDR_BUS] mem_cp0_wa_i,
    input  wire [     `REG_BUS] mem_cp0_wd_i,
    output wire                 mem_cp0_we_o,
    output wire [`REG_ADDR_BUS] mem_cp0_wa_o,
    output wire [     `REG_BUS] mem_cp0_wd_o
);

  //cp0
  assign mem_cp0_we_o = mem_cp0_we_i;
  assign mem_cp0_wa_o = mem_cp0_wa_i;
  assign mem_cp0_wd_o = mem_cp0_wd_i;

  // �����ǰ���Ƿô�ָ���ֻ��Ҫ�Ѵ�ִ�н׶λ�õ���Ϣֱ�����
  assign mem_wa_o     = mem_wa_i;
  assign mem_wreg_o   = mem_wreg_i;
  assign mem_dreg_o   = mem_wd_i;
  assign mem_whilo_o  = mem_whilo_i;
  assign mem_hilo_o   = mem_hilo_i;
  assign mem_whi_o    = mem_whi_i;
  assign mem_wlo_o    = mem_wlo_i;
  assign mem_mreg_o   = mem_mreg_i;

  //ȷ����ǰ�ķô�ָ��
  wire inst_lb = (mem_aluop_i == `MINIMIPS32_LB);
  wire inst_lh = (mem_aluop_i == `MINIMIPS32_LH);
  wire inst_lw = (mem_aluop_i == `MINIMIPS32_LW);
  wire inst_lbu = (mem_aluop_i == `MINIMIPS32_LBU);
  wire inst_lhu = (mem_aluop_i == `MINIMIPS32_LHU);
  wire inst_sb = (mem_aluop_i == `MINIMIPS32_SB);
  wire inst_sh = (mem_aluop_i == `MINIMIPS32_SH);
  wire inst_sw = (mem_aluop_i == `MINIMIPS32_SW);

  //������ݴ洢���ķ��ʵ�ַ
  assign daddr  = mem_wd_i;

  //������ݴ洢�����ֽ�ʹ���ź�
  assign dre[3] = ((inst_lb & (daddr[1:0] == 2'b00)) | inst_lw | (inst_lbu & (daddr[1:0] == 2'b00)) | (inst_lh & (daddr[1:0] == 2'b00)) | (inst_lhu & (daddr[1:0] == 2'b00)));
  assign dre[2] = ((inst_lb & (daddr[1:0] == 2'b01)) | inst_lw | (inst_lbu & (daddr[1:0] == 2'b01)) | (inst_lh & (daddr[1:0] == 2'b00)) | (inst_lhu & (daddr[1:0] == 2'b00)));
  assign dre[1] = ((inst_lb & (daddr[1:0] == 2'b10)) | inst_lw | (inst_lbu & (daddr[1:0] == 2'b10)) | (inst_lh & (daddr[1:0] == 2'b10)) | (inst_lhu & (daddr[1:0] == 2'b10)));
  assign dre[0] = ((inst_lb & (daddr[1:0] == 2'b11)) | inst_lw | (inst_lbu & (daddr[1:0] == 2'b11)) | (inst_lh & (daddr[1:0] == 2'b10)) | (inst_lhu & (daddr[1:0] == 2'b10)));

  //������ݴ洢��ʹ���ź�
  assign dce    = (inst_lb | inst_lw | inst_sb | inst_sh | inst_sw | inst_lbu | inst_lh | inst_lhu);

  //������ݴ洢��д�ֽ�ʹ���ź�
  assign we[3]  = ((inst_sb & (daddr[1:0] == 2'b00)) | inst_sw | (inst_sh & (daddr[1:0] == 2'b00)));
  assign we[2]  = ((inst_sb & (daddr[1:0] == 2'b01)) | inst_sw | (inst_sh & (daddr[1:0] == 2'b00)));
  assign we[1]  = ((inst_sb & (daddr[1:0] == 2'b10)) | inst_sw | (inst_sh & (daddr[1:0] == 2'b10)));
  assign we[0]  = ((inst_sb & (daddr[1:0] == 2'b11)) | inst_sw | (inst_sh & (daddr[1:0] == 2'b10)));

  //ȷ����д��洢��������
  wire [`WORD_BUS] din_reverse = {mem_din_i[7:0], mem_din_i[15:8], mem_din_i[23:16], mem_din_i[31:24]};
  wire [`WORD_BUS] din_byte = {{24{1'b0}}, mem_din_i[7:0]};
  assign din            = (we == 4'b1111) ? din_reverse : (we == 4'b1000) ? din_byte : (we == 4'b0100) ? din_byte : (we == 4'b0010) ? din_byte : (we == 4'b0001) ? din_byte : (we == 4'b1100) ? {din_reverse[31:16], {16{1'b0}}} : (we == 4'b0011) ? {{16{1'b0}}, din_reverse[31:16]} : `ZERO_WORD;

  //mem2id����ǰ��
  assign mem2id_wa      = mem_wa_i;
  assign mem2id_wreg    = mem_wreg_i;
  assign mem2id_wd      = mem_wd_i;
  assign debug_wb_pc    = mem_debug_wb_pc;  // �ϰ����ʱ���ɾ������� 

  //hilo�Ĵ����������
  assign mem2exe_whilo  = (mem_aluop_i == `MINIMIPS32_MTHI) ? 2'b10 : (mem_aluop_i == `MINIMIPS32_MTLO) ? 2'b01 : {mem_whi_i, mem_wlo_i};
  assign mem2exe_hilo   = (mem_aluop_i == `MINIMIPS32_MTHI) ? {mem_wd_i, 32'h0000} : (mem_aluop_i == `MINIMIPS32_MTLO) ? {32'h0000, mem_wd_i} : mem_hilo_i;

  //cp0
  assign mem_cur_pc_o   = mem_cur_pc_i;
  assign mem_c_ds_o     = mem_c_ds_i;
  assign mem_badvaddr_o = (mem_cur_pc_i[1:0] != 2'b00) ? mem_cur_pc_i : mem_wd_i;
  always @(*) begin
    if ((mem_aluop_o == `MINIMIPS32_SB || mem_aluop_o == `MINIMIPS32_SH || mem_aluop_o == `MINIMIPS32_SW) && ades == 1) begin
      mem_exctype_o = `ADES;
    end else if ((mem_aluop_o == `MINIMIPS32_LB || mem_aluop_o == `MINIMIPS32_LBU || mem_aluop_o == `MINIMIPS32_LH || mem_aluop_o == `MINIMIPS32_LHU || mem_aluop_o == `MINIMIPS32_LW) && adel == 1) begin
      mem_exctype_o = `ADEL;
    end else begin
      mem_exctype_o = mem_exctype_i;
    end
  end

endmodule

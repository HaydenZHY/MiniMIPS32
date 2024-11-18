`include "defines.v"

module mem_stage (

    // 从执行阶段获得的信息
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

    input wire [`INST_ADDR_BUS] mem_debug_wb_pc,  // 供调试使用的PC值，上板测试时务必删除该信号

    // 送至写回阶段的信息
    output wire [  `REG_ADDR_BUS] mem_wa_o,
    output wire                   mem_wreg_o,
    output wire [       `REG_BUS] mem_dreg_o,
    output wire                   mem_mreg_o,
    output wire                   mem_whilo_o,
    output wire [`DOUBLE_REG_BUS] mem_hilo_o,
    output wire                   mem_whi_o,
    output wire                   mem_wlo_o,
    output wire [      `BSEL_BUS] dre,

    output wire [`INST_ADDR_BUS] debug_wb_pc,  // 供调试使用的PC值，上板测试时务必删除该信号

    output wire                  dce,
    output wire [`INST_ADDR_BUS] daddr,
    output wire [     `BSEL_BUS] we,
    output wire [      `REG_BUS] din,
    
    //mem2id数据前推
    output  wire [`REG_ADDR_BUS]     mem2id_wa,
    output  wire                     mem2id_wreg,
    output  wire [`REG_BUS      ]    mem2id_wd,
    
    //hilo寄存器数据相关
    output wire [1 : 0]                 mem2exe_whilo,
    output wire [`DOUBLE_REG_BUS]       mem2exe_hilo
);

  // 如果当前不是访存指令，则只需要把从执行阶段获得的信息直接输出
  assign mem_wa_o    = mem_wa_i;
  assign mem_wreg_o  = mem_wreg_i;
  assign mem_dreg_o  = mem_wd_i;
  assign mem_whilo_o = mem_whilo_i;
  assign mem_hilo_o  = mem_hilo_i;
  assign mem_whi_o   = mem_whi_i;
  assign mem_wlo_o   = mem_wlo_i;
  assign mem_mreg_o  = mem_mreg_i;

  //确定当前的访存指令
  wire inst_lb = (mem_aluop_i == `MINIMIPS32_LB);
  wire inst_lh = (mem_aluop_i == `MINIMIPS32_LH);
  wire inst_lw = (mem_aluop_i == `MINIMIPS32_LW);
  wire inst_lbu = (mem_aluop_i == `MINIMIPS32_LBU);
  wire inst_lhu = (mem_aluop_i == `MINIMIPS32_LHU);
  wire inst_sb = (mem_aluop_i == `MINIMIPS32_SB);
  wire inst_sh = (mem_aluop_i == `MINIMIPS32_SH);
  wire inst_sw = (mem_aluop_i == `MINIMIPS32_SW);

  //获得数据存储器的访问地址
  assign daddr  = mem_wd_i;

  //获得数据存储器读字节使能信号
  assign dre[3] = ((inst_lb & (daddr[1:0] == 2'b00)) | inst_lw | (inst_lbu & (daddr[1:0] == 2'b00)) | (inst_lh & (daddr[1:0] == 2'b00)) | (inst_lhu & (daddr[1:0] == 2'b00)));
  assign dre[2] = ((inst_lb & (daddr[1:0] == 2'b01)) | inst_lw | (inst_lbu & (daddr[1:0] == 2'b01)) | (inst_lh & (daddr[1:0] == 2'b00)) | (inst_lhu & (daddr[1:0] == 2'b00)));
  assign dre[1] = ((inst_lb & (daddr[1:0] == 2'b10)) | inst_lw | (inst_lbu & (daddr[1:0] == 2'b10)) | (inst_lh & (daddr[1:0] == 2'b10)) | (inst_lhu & (daddr[1:0] == 2'b10)));
  assign dre[0] = ((inst_lb & (daddr[1:0] == 2'b11)) | inst_lw | (inst_lbu & (daddr[1:0] == 2'b11)) | (inst_lh & (daddr[1:0] == 2'b10)) | (inst_lhu & (daddr[1:0] == 2'b10)));

  //获得数据存储器使能信号
  assign dce    = (inst_lb | inst_lw | inst_sb | inst_sh | inst_sw | inst_lbu | inst_lh | inst_lhu);

  //获得数据存储器写字节使能信号
  assign we[3]  = ((inst_sb & (daddr[1:0] == 2'b00)) | inst_sw | (inst_sh & (daddr[1:0] == 2'b00)));
  assign we[2]  = ((inst_sb & (daddr[1:0] == 2'b01)) | inst_sw | (inst_sh & (daddr[1:0] == 2'b00)));
  assign we[1]  = ((inst_sb & (daddr[1:0] == 2'b10)) | inst_sw | (inst_sh & (daddr[1:0] == 2'b10)));
  assign we[0]  = ((inst_sb & (daddr[1:0] == 2'b11)) | inst_sw | (inst_sh & (daddr[1:0] == 2'b10)));

  //确定待写入存储器的数据
  wire [`WORD_BUS] din_reverse = {mem_din_i[7:0], mem_din_i[15:8], mem_din_i[23:16], mem_din_i[31:24]};
  wire [`WORD_BUS] din_byte = {{24{1'b0}},mem_din_i[7:0]};
  assign din         = (we == 4'b1111) ? din_reverse : (we == 4'b1000) ? din_byte : (we == 4'b0100) ? din_byte : (we == 4'b0010) ? din_byte : (we == 4'b0001) ? din_byte : (we == 4'b1100) ? {din_reverse[31:16], {16{1'b0}}} : (we == 4'b0011) ? {{16{1'b0}}, din_reverse[31:16]} : `ZERO_WORD;

    //mem2id数据前推
    assign mem2id_wa    = mem_wa_i;
    assign mem2id_wreg  = mem_wreg_i;
    assign mem2id_wd    = mem_wd_i;
  assign debug_wb_pc = mem_debug_wb_pc;  // 上板测试时务必删除该语句 

endmodule

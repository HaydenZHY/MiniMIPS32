`include "defines.v"

module id_stage (
    input  wire [`INST_ADDR_BUS] id_pc_i,
    input  wire [`INST_ADDR_BUS] id_debug_wb_pc,
    output      [`INST_ADDR_BUS] debug_wb_pc,

    input wire [`INST_BUS] id_inst_i,

    input wire [`REG_BUS] rd1,
    input wire [`REG_BUS] rd2,

    // argu from exestage
    input wire [`REG_ADDR_BUS] exe2id_wa,
    input wire                 exe2id_wreg,
    input wire [     `REG_BUS] exe2id_wd,

    // argu from memstage
    input wire [`REG_ADDR_BUS] mem2id_wa,
    input wire                 mem2id_wreg,
    input wire [     `REG_BUS] mem2id_wd,
    input wire                 exe2id_mreg,
    input wire                 mem2id_mreg,

    // signal from cp0
    input  wire                  flush,
    input  wire                  c_ds_i,
    output wire                  c_ds_o,
    output reg  [  `EXCTYPE_BUS] exctype,
    output wire [`INST_ADDR_BUS] cur_pc,
    output wire                  n_ds,

    // cp02
    output wire [`REG_ADDR_BUS] cp0_rt,

    // to exestage
    output wire [ `ALUTYPE_BUS] id_alutype_o,
    output wire [   `ALUOP_BUS] id_aluop_o,
    output wire                 id_whilo_o,
    output wire [`REG_ADDR_BUS] id_wa_o,
    output wire                 id_we_o,
    output wire                 id_mreg_o,
    output wire [     `REG_BUS] id_din_o,

    output wire [`REG_BUS] id_src1_o,
    output wire [`REG_BUS] id_src2_o,

    // output to ifstage
    output wire [           1:0] jtsel,
    output wire [`INST_ADDR_BUS] jump_addr_1,
    output wire [`INST_ADDR_BUS] jump_addr_2,
    output wire [`INST_ADDR_BUS] jump_addr_3,

    // output to exestage
    output wire [`INST_ADDR_BUS] ret_addr,
    output wire                  stallreg_id,

    output wire [`REG_ADDR_BUS] ra1,
    output wire [`REG_ADDR_BUS] ra2
);

  wire                                                                                                                                              [       `INST_BUS] id_inst = {id_inst_i[7:0], id_inst_i[15:8], id_inst_i[23:16], id_inst_i[31:24]};
  wire                                                                                                                                              [         `op_len] op = id_inst[31:26];
  wire                                                                                                                                              [      `funct_len] func = id_inst[5 : 0];
  wire                                                                                                                                              [         `rd_len] rd = id_inst[15:11];
  wire                                                                                                                                              [         `rs_len] rs = id_inst[25:21];
  wire                                                                                                                                              [         `rt_len] rt = id_inst[20:16];
  wire                                                                                                                                              [         `sa_len] sa = id_inst[10:6];
  wire                                                                                                                                              [        `imm_len] imm = id_inst[15:0];
  wire                                                                                                                                              [`instr_index_len] instr_index = id_inst[25:0];
  /*-------------------- ????? --------------------*/
  // alu instruction
  wire inst_reg = ~|op;
  wire inst_add = inst_reg & func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
  wire inst_addi = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];
  wire inst_addu = inst_reg & func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & func[0];
  wire inst_addiu = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & op[0];
  wire inst_sub = inst_reg & func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & ~func[0];
  wire inst_subu = inst_reg & func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & func[0];
  wire inst_slt = inst_reg & func[5] & ~func[4] & func[3] & ~func[2] & func[1] & ~func[0];
  wire inst_slti = ~op[5] & ~op[4] & op[3] & ~op[2] & op[1] & ~op[0];
  wire inst_sltu = inst_reg & func[5] & ~func[4] & func[3] & ~func[2] & func[1] & func[0];
  wire inst_sltiu = ~op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0];
  wire inst_div = inst_reg & ~func[5] & func[4] & func[3] & ~func[2] & func[1] & ~func[0];
  wire inst_divu = inst_reg & ~func[5] & func[4] & func[3] & ~func[2] & func[1] & func[0];
  wire inst_mult = inst_reg & ~func[5] & func[4] & func[3] & ~func[2] & ~func[1] & ~func[0];
  wire inst_multu = inst_reg & ~func[5] & func[4] & func[3] & ~func[2] & ~func[1] & func[0];
  // logic instruction  
  wire inst_and = inst_reg & func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & ~func[0];
  wire inst_andi = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & ~op[0];
  wire inst_lui = ~op[5] & ~op[4] & op[3] & op[2] & op[1] & op[0];
  wire inst_nor = inst_reg & func[5] & ~func[4] & ~func[3] & func[2] & func[1] & func[0];
  wire inst_or = inst_reg & func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & func[0];
  wire inst_ori = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & op[0];
  wire inst_xor = inst_reg & func[5] & ~func[4] & ~func[3] & func[2] & func[1] & ~func[0];
  wire inst_xori = ~op[5] & ~op[4] & op[3] & op[2] & op[1] & ~op[0];
  // shift instruction
  wire inst_sllv = inst_reg & ~func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & ~func[0];
  wire inst_sll = inst_reg & ~func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
  wire inst_srav = inst_reg & ~func[5] & ~func[4] & ~func[3] & func[2] & func[1] & func[0];
  wire inst_sra = inst_reg & ~func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & func[0];
  wire inst_srlv = inst_reg & ~func[5] & ~func[4] & ~func[3] & func[2] & func[1] & ~func[0];
  wire inst_srl = inst_reg & ~func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & ~func[0];
  // hilo instruction
  wire inst_mfhi = inst_reg & ~func[5] & func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
  wire inst_mflo = inst_reg & ~func[5] & func[4] & ~func[3] & ~func[2] & func[1] & ~func[0];
  wire inst_mthi = inst_reg & ~func[5] & func[4] & ~func[3] & ~func[2] & ~func[1] & func[0];
  wire inst_mtlo = inst_reg & ~func[5] & func[4] & ~func[3] & ~func[2] & func[1] & func[0];
  // memory instruction
  wire inst_lb = op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];
  wire inst_lbu = op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0];
  wire inst_lh = op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & op[0];
  wire inst_lhu = op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & op[0];
  wire inst_lw = op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];
  wire inst_sb = op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];
  wire inst_sh = op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & op[0];
  wire inst_sw = op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0];
  // jump instruction
  wire inst_beq = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0];
  wire inst_bne = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & op[0];
  wire inst_bgez = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & op[0] & rt[0] & ~rt[4];
  wire inst_bgtz = ~op[5] & ~op[4] & ~op[3] & op[2] & op[1] & op[0];
  wire inst_blez = ~op[5] & ~op[4] & ~op[3] & op[2] & op[1] & ~op[0];
  wire inst_bltz = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & op[0] & ~rt[0] & ~rt[4];
  wire inst_bltzal = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & op[0] & ~rt[0] & rt[4];
  wire inst_bgezal = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & op[0] & rt[0] & rt[4];
  wire inst_j = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & ~op[0];
  wire inst_jal = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];
  wire inst_jr = inst_reg & ~func[5] & ~func[4] & func[3] & ~func[2] & ~func[1] & ~func[0];
  wire inst_jalr = inst_reg & ~func[5] & ~func[4] & func[3] & ~func[2] & ~func[1] & func[0];
  //CP0 instruction
  wire inst_mfc0 = (~op[5] & op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0]) & ~id_inst[25] & ~id_inst[24] & ~id_inst[23] & ~id_inst[22] & ~id_inst[21];
  wire inst_mtc0 = ~op[5] & op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0] & ~id_inst[25] & ~id_inst[24] & id_inst[23] & ~id_inst[22] & ~id_inst[21];
  //privileged instruction
  wire inst_syscall = inst_reg & ~func[5] & ~func[4] & func[3] & func[2] & ~func[1] & ~func[0];
  wire inst_break = inst_reg & ~func[5] & ~func[4] & func[3] & func[2] & ~func[1] & func[0];
  wire inst_eret = (~op[5] & op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0]) & id_inst[25] & ~id_inst[24] & ~id_inst[23] & ~id_inst[22] & ~id_inst[21];
  /*------------------------------------------------------------------------------*/

  /*-------------------- 第二级译码逻辑：生成具体控制信号 --------------------*/
  // 操作类型alutype
  assign id_alutype_o[2] = inst_sllv | inst_sll | inst_srav | inst_sra | inst_srlv | inst_srl | inst_beq | inst_bne | inst_bgez | inst_bgtz | inst_blez | inst_bltz | inst_bltzal | inst_bgezal | inst_j | inst_jal | inst_jr | inst_jalr | inst_mfc0 | inst_mtc0 | inst_syscall | inst_break | inst_eret;
  assign id_alutype_o[1] = inst_and|inst_andi|inst_lui|inst_nor|inst_or|inst_ori|inst_xor|
                             inst_xori|inst_mfhi|inst_mflo|inst_mthi|inst_mtlo|inst_beq|
                             inst_bne|inst_bgez|inst_bgtz|inst_blez|inst_bltz|inst_bltzal|
                             inst_bgezal|inst_j|inst_jal|inst_jr|inst_jalr|inst_mfc0|inst_mtc0|
                             inst_syscall|inst_break|inst_eret;
  assign id_alutype_o[0] = inst_add|inst_addi|inst_addu|inst_addiu|inst_sub|inst_subu|inst_slt|
                             inst_slti|inst_sltu|inst_sltiu|inst_mult|inst_multu|inst_mfhi|inst_mflo|
                             inst_mthi|inst_mtlo|inst_lb|inst_lbu|inst_lh|inst_lhu|inst_lw|inst_sb|
                             inst_sh|inst_sw|inst_div|inst_divu|inst_mfc0|inst_mtc0|inst_syscall|inst_break|inst_eret;

  // 内部操作码aluop
  assign id_aluop_o[7] = 1'b0;
  assign id_aluop_o[6] = inst_jr | inst_jalr | inst_div | inst_divu | inst_mfc0 | inst_mtc0 | inst_syscall | inst_break | inst_eret;
  assign id_aluop_o[5]   = inst_or|inst_ori|inst_xor|inst_xori|inst_sll|inst_sllv|inst_sra|inst_srav|inst_srl|inst_srlv|
                             inst_mfhi|inst_mflo|inst_mthi|inst_mtlo|inst_lb|inst_lbu|inst_lh|inst_lhu|inst_lw|inst_sb|
                             inst_sh|inst_sw|inst_beq|inst_bne|inst_bgez|inst_bgtz|inst_blez|inst_bltz|inst_bltzal|inst_bgezal|inst_j|inst_jal;
  assign id_aluop_o[4]   = inst_add|inst_addi|inst_addu|inst_addiu|inst_sub|inst_subu|inst_slt|inst_slti|inst_sltu|inst_sltiu|inst_mult|inst_multu|
                             inst_and|inst_andi|inst_lui|inst_nor|inst_lh|inst_lhu|inst_lw|inst_sb|inst_sh|inst_sw|inst_beq|inst_bne|inst_bgez|inst_bgtz|
                             inst_blez|inst_bltz|inst_bltzal|inst_bgezal|inst_j|inst_jal;
  assign id_aluop_o[3]   = inst_sltu|inst_sltiu|inst_mult|inst_multu|inst_and|inst_andi|inst_lui|inst_nor|inst_srl|inst_srlv|inst_mfhi|inst_mflo|inst_mthi|
                             inst_mtlo|inst_lb|inst_lbu|inst_bgez|inst_bgtz|inst_blez|inst_bltz|inst_bltzal|inst_bgezal|inst_j|inst_jal|inst_eret;
  assign id_aluop_o[2]   = inst_sub|inst_subu|inst_slt|inst_slti|inst_and|inst_andi|inst_lui|inst_nor|inst_sll|inst_sllv|inst_sra|inst_srav|
                             inst_mthi|inst_mtlo|inst_lb|inst_lbu|inst_sh|inst_sw|inst_beq|inst_bne|inst_bltzal|inst_bgezal|inst_j|inst_jal|
                             inst_mfc0|inst_mtc0|inst_syscall|inst_break;
  assign id_aluop_o[1]   = inst_addu|inst_addiu|inst_slt|inst_slti|inst_mult|inst_multu|inst_lui|inst_nor|inst_xor|inst_xori|inst_sra|
                             inst_srav|inst_mfhi|inst_mflo|inst_lb|inst_lbu|inst_lw|inst_sb|inst_beq|inst_bne|inst_blez|inst_bltz|inst_j|
                             inst_jal|inst_div|inst_divu|inst_syscall|inst_break;
  assign id_aluop_o[0]   = inst_addi|inst_addiu|inst_subu|inst_slti|inst_sltiu|inst_multu|inst_andi|inst_nor|inst_ori|inst_xori|inst_sllv|
                             inst_srav|inst_srlv|inst_mflo|inst_mtlo|inst_lbu|inst_lhu|inst_sb|inst_sw|inst_bne|inst_bgtz|inst_bltz|inst_bgezal|
                             inst_jal|inst_jalr|inst_divu|inst_mtc0|inst_break;

  // ??????
  wire rtsel = inst_addi | inst_addiu | inst_slti | inst_sltiu | inst_andi | inst_lui | inst_ori | inst_xori | inst_lb | inst_lbu | inst_lh | inst_lhu | inst_lw | inst_sb | inst_sh | inst_sw;
  wire shift = inst_sll | inst_sra | inst_srl;
  assign id_whilo_o = inst_mult | inst_multu | inst_mthi | inst_mtlo | inst_div | inst_divu;
  wire immsel = inst_addi | inst_addiu | inst_slti | inst_sltiu | inst_andi | inst_lui | inst_ori | inst_xori | inst_lb | inst_lbu | inst_lh | inst_lhu | inst_lw | inst_sb | inst_sh | inst_sw;
  wire sext = inst_addi | inst_addiu | inst_slti | inst_sltiu | inst_lb | inst_lbu | inst_lh | inst_lhu | inst_lw | inst_sb | inst_sh | inst_sw;
  wire upper = inst_lui;
  assign id_mreg_o = inst_lb | inst_lbu | inst_lh | inst_lhu | inst_lw;
  assign id_we_o = inst_add|inst_addi|inst_addu|inst_addiu|inst_sub|inst_subu|inst_slt|inst_slti|inst_sltu|inst_sltiu|inst_and|inst_andi|inst_lui|inst_nor|inst_or|inst_ori|inst_xor|inst_xori|inst_sll|inst_sllv|inst_sra|inst_srav|inst_srl|inst_srlv|inst_mfhi|inst_mflo|inst_lb|inst_lbu|inst_lh|inst_lhu|inst_lw|
    inst_bltzal|inst_bgezal|inst_jal|inst_jalr|inst_mfc0;
  // new controlsignal
  wire jal = inst_bltzal | inst_bgezal | inst_jal;
  /*------------------------------------------------------------------------------*/

  // 读通用寄存器堆端口1的地址为rs字段，读端口2的地址为rt字段
  assign ra1     = rs;
  assign ra2     = rt;
  // 获得待写入目的寄存器的地址（rt或rd）
  assign id_wa_o = (rtsel == `RT_ENABLE) ? rt : (inst_bltzal || inst_bgezal || inst_jal) ? 31 : rd;

  reg [31:0] immvalue;
  reg [31:0] immleft;

  always @(*) begin
    immleft = {imm[15:0], 16'b0000000000000000};
    if (upper == 1) begin
      immvalue = immleft;
    end else if (sext == 0 || imm[15] == 0) begin
      immvalue = {16'b0000000000000000, imm[15:0]};
    end else begin
      immvalue = {16'b1111111111111111, imm[15:0]};
    end
  end


  //前推信号
  reg [     1:0 ] fwrd1;
  reg [     1:0 ] fwrd2;
  reg [`REG_BUS]  din;
  always @(*) begin
    if (exe2id_wreg == `WRITE_ENABLE && exe2id_wa == rs) begin
      fwrd1 = 2'b01;
    end else if (mem2id_wreg == `WRITE_ENABLE && mem2id_wa == rs) begin
      fwrd1 = 2'b10;
    end else begin
      fwrd1 = 2'b00;
    end
    if (exe2id_wreg == `WRITE_ENABLE && exe2id_wa == rt) begin
      fwrd2 = 2'b01;
    end else if (mem2id_wreg == `WRITE_ENABLE && mem2id_wa == rt) begin
      fwrd2 = 2'b10;
    end else begin
      fwrd2 = 2'b00;
    end
  end
  reg [`REG_BUS] src1;
  reg [`REG_BUS] src2;
  always @(*) begin
    if (fwrd2 == 2'b00) begin
      din = rd2;
    end else if (fwrd2 == 2'b01) begin
      din = exe2id_wd;
    end else if (fwrd2 == 2'b10) begin
      din = mem2id_wd;
    end
    if (shift == `SHIFT_ENABLE) begin
      src1 = sa;
    end else if (fwrd1 == 2'b00) begin
      src1 = rd1;
    end else if (fwrd1 == 2'b01) begin
      src1 = exe2id_wd;
    end else if (fwrd1 == 2'b10) begin
      src1 = mem2id_wd;
    end
    if (immsel == `IMM_ENABLE) begin
      src2 = immvalue;
    end else if (fwrd2 == 2'b00) begin
      src2 = rd2;
    end else if (fwrd2 == 2'b01) begin
      src2 = exe2id_wd;
    end else if (fwrd2 == 2'b10) begin
      src2 = mem2id_wd;
    end
  end
  assign id_src1_o = src1;
  assign id_src2_o = src2;
  assign id_din_o  = din;

  //跳转相关
  assign ret_addr  = id_pc_i + 8;
  wire [`INST_ADDR_BUS] pcadd4 = id_pc_i + 4;
  wire [`INST_ADDR_BUS] offsetleft = {{14{imm[15]}}, imm, 2'b00};
  assign jump_addr_1 = {pcadd4[31:28], instr_index, 2'b00};
  assign jump_addr_2 = id_src1_o;
  assign jump_addr_3 = offsetleft + pcadd4;

  // jumpe为1跳转，jumpe为0不跳转
  reg jumpe;
  always @(*) begin
    if (inst_beq && id_src1_o == id_src2_o) jumpe = 1;
    else if (inst_bne && id_src1_o != id_src2_o) jumpe = 1;
    else if (inst_bgez && id_src1_o[31] == 0) jumpe = 1;
    else if (inst_bgtz && id_src1_o[31] == 0 && id_src1_o > 0) jumpe = 1;
    else if (inst_blez && (id_src1_o == 0 || id_src1_o[31] == 1)) jumpe = 1;
    else if (inst_bltz && id_src1_o[31] == 1) jumpe = 1;
    else if (inst_bgezal && id_src1_o[31] == 0) jumpe = 1;
    else if (inst_bltzal && id_src1_o[31] == 1) jumpe = 1;
    else if (inst_j || inst_jal || inst_jr || inst_jalr) jumpe = 1;
    else jumpe = 0;
  end

  assign jtsel[0]    = (flush == 1) ? 0 : jumpe & (inst_bgez | inst_bgtz | inst_blez | inst_bltz | inst_bltzal | inst_bgezal | inst_j | inst_jal | inst_beq | inst_bne);
  assign jtsel[1]    = (flush == 1) ? 0 : jumpe & (inst_bgez | inst_bgtz | inst_blez | inst_bltz | inst_bltzal | inst_bgezal | inst_jr | inst_jalr | inst_beq | inst_bne);
  assign debug_wb_pc = id_debug_wb_pc;

  //暂停机制相关 蓝线
  assign stallreg_id = (exe2id_mreg == 1'b1 && exe2id_wreg == 1'b1 && (rs == exe2id_wa || rt == exe2id_wa)) || (mem2id_mreg == 1'b1 && mem2id_wreg == 1'b1 && (rs == mem2id_wa || rt == mem2id_wa)) ? 1'b1 : 1'b0;

  //exp part
  assign c_ds_o      = c_ds_i;
  assign cur_pc      = id_pc_i;
  assign n_ds        = (inst_beq || inst_bne || inst_bgez || inst_bgtz || inst_blez || inst_bltz || inst_bgezal || inst_bltzal || inst_j || inst_jal || inst_jalr || inst_jr) ? 1 : 0;
  always @(*) begin
    if (inst_syscall) exctype = `Sys;
    else if (inst_break) exctype = `BP;
    else if (inst_eret) exctype = `Eret;
    else if ((id_aluop_o < 8'h10 || id_aluop_o > 8'h48) && id_pc_i != 32'hBFC00000) exctype = `RI;
    else if (id_pc_i[1:0] != 2'b00) exctype = `ADEL;
    else exctype = `noexe;
  end
  //cp02
  assign cp0_rt = rt;

endmodule

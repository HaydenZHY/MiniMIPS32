`include "defines.v"

module exe_stage (
    input wire                 cpu_rst_n,
    // 从译码阶段获得的信息
    input wire [ `ALUTYPE_BUS] exe_alutype_i,
    input wire [   `ALUOP_BUS] exe_aluop_i,
    input wire [     `REG_BUS] exe_src1_i,
    input wire [     `REG_BUS] exe_src2_i,
    input wire [`REG_ADDR_BUS] exe_wa_i,
    input wire                 exe_wreg_i,
    input wire                 exe_whilo_i,
    input wire                 exe_mreg_i,
    input wire [     `REG_BUS] exe_din_i,

    input wire exe_whi_i,
    input wire exe_wlo_i,


    // 从hilo寄存器获得的数据       
    input wire [`REG_BUS] hi_i,
    input wire [`REG_BUS] lo_i,

    input  wire [ `INST_ADDR_BUS] exe_debug_wb_pc,  // 供调试使用的PC值，上板测试时务必删除该信号
    // 送至执行阶段的信息
    output wire [     `ALUOP_BUS] exe_aluop_o,
    output wire [  `REG_ADDR_BUS] exe_wa_o,
    output wire                   exe_wreg_o,
    output wire [       `REG_BUS] exe_wd_o,
    output wire                   exe_whilo_o,
    output wire [`DOUBLE_REG_BUS] exe_hilo_o,
    output wire                   exe_mreg_o,
    output wire [       `REG_BUS] exe_din_o,

    output wire                  exe_whi_o,
    output wire                  exe_wlo_o,
    output wire [          31:0] debug_info,
    output wire [`INST_ADDR_BUS] debug_wb_pc,  // 供调试使用的PC值，上板测试时务必删除该信号
    
    //exe2id数据前推
    output wire [`REG_ADDR_BUS]     exe2id_wa,
    output  wire                    exe2id_wreg,
    output  wire [`REG_BUS      ]   exe2id_wd
);

  // 直接传到下一阶段
  assign exe_aluop_o = exe_aluop_i;
  assign exe_whilo_o = exe_whilo_i;
  assign exe_mreg_o  = exe_mreg_i;
  assign exe_din_o   = exe_din_i;

  assign exe_whi_o   = exe_whi_i;
  assign exe_wlo_o   = exe_wlo_i;


  wire [       `REG_BUS] logicres;
  wire [`DOUBLE_REG_BUS] sign_mulres;
  wire [`DOUBLE_REG_BUS] unsign_mulres;
  wire [       `REG_BUS] hi_t;
  wire [       `REG_BUS] lo_t;
  wire [       `REG_BUS] moveres;
  wire [       `REG_BUS] shiftres;
  wire [       `REG_BUS] arithres;


  assign logicres = (exe_aluop_i == `MINIMIPS32_AND )  ? (exe_src1_i & exe_src2_i) : 
                      (exe_aluop_i == `MINIMIPS32_ORI) ? (exe_src1_i | exe_src2_i) :
                      (exe_aluop_i == `MINIMIPS32_LUI) ? exe_src2_i : 
                      (exe_aluop_i == `MINIMIPS32_ANDI) ? (exe_src1_i & exe_src2_i) :
                      (exe_aluop_i == `MINIMIPS32_NOR) ? (~(exe_src1_i | exe_src2_i)) :
                      (exe_aluop_i == `MINIMIPS32_OR) ? (exe_src1_i | exe_src2_i) : 
                      (exe_aluop_i == `MINIMIPS32_XOR) ? (exe_src1_i ^ exe_src2_i) :
                      (exe_aluop_i == `MINIMIPS32_XORI) ? (exe_src1_i ^ exe_src2_i) : `ZERO_WORD;

  assign arithres = (exe_aluop_i == `MINIMIPS32_ADD) ? (exe_src1_i + exe_src2_i) : (exe_aluop_i == `MINIMIPS32_SUBU) ? (exe_src1_i + (~exe_src2_i) + 1) : (exe_aluop_i == `MINIMIPS32_SLT) ? ($signed(
      exe_src1_i
  ) < $signed(
      exe_src2_i
  ) ? 32'b1 : 32'b0) : (exe_aluop_i == `MINIMIPS32_ADDIU) ? (exe_src1_i + exe_src2_i) : (exe_aluop_i == `MINIMIPS32_SLTIU) ?
      ((exe_src1_i < exe_src2_i) ? 32'b1 : 32'b0) : (exe_aluop_i == `MINIMIPS32_LB) ? (exe_src1_i + exe_src2_i) : (exe_aluop_i == `MINIMIPS32_LW) ? (exe_src1_i + exe_src2_i) : (exe_aluop_i == `MINIMIPS32_SB) ? (exe_src1_i + exe_src2_i) : (exe_aluop_i == `MINIMIPS32_SW) ?
      (exe_src1_i + exe_src2_i) : (exe_aluop_i == `MINIMIPS32_ADDI) ? (exe_src1_i + exe_src2_i) : (exe_aluop_i == `MINIMIPS32_ADDU) ? (exe_src1_i + exe_src2_i) : (exe_aluop_i == `MINIMIPS32_SUB) ? (exe_src1_i + (~exe_src2_i) + 1) : (exe_aluop_i == `MINIMIPS32_SLTI) ? ($signed(
      exe_src1_i
  ) < $signed(
      exe_src2_i
  ) ? 32'b1 : 32'b0) : (exe_aluop_i == `MINIMIPS32_SLTU) ? ((exe_src1_i < exe_src2_i) ? 32'b1 : 32'b0) : (exe_aluop_i == `MINIMIPS32_LBU) ?
      (exe_src1_i + exe_src2_i) : (exe_aluop_i == `MINIMIPS32_LH) ? (exe_src1_i + exe_src2_i) : (exe_aluop_i == `MINIMIPS32_LHU) ? (exe_src1_i + exe_src2_i) : (exe_aluop_i == `MINIMIPS32_SH) ? (exe_src1_i + exe_src2_i) : `ZERO_WORD;


  assign hi_t = hi_i;

  assign lo_t = lo_i;

  assign moveres = (exe_aluop_i == `MINIMIPS32_MFHI) ? hi_t : (exe_aluop_i == `MINIMIPS32_MFLO) ? lo_t : `ZERO_WORD;

  wire signed [31:0] arith_shiftres;
  wire signed [31:0] arith_shiftres_v;
  assign arith_shiftres = $signed(exe_src2_i) >>> exe_src1_i;
  assign arith_shiftres_v = $signed(exe_src2_i) >>> exe_src1_i[`REG_ADDR_BUS];

  assign shiftres = (exe_aluop_i == `MINIMIPS32_SLL) ? (exe_src2_i << exe_src1_i) : 
                      (exe_aluop_i == `MINIMIPS32_SLLV) ? (exe_src2_i << exe_src1_i[`REG_ADDR_BUS]) : 
                      (exe_aluop_i == `MINIMIPS32_SRA) ? arith_shiftres :
                      (exe_aluop_i == `MINIMIPS32_SRL) ? (exe_src2_i >> exe_src1_i) :
                      (exe_aluop_i == `MINIMIPS32_SRAV) ? arith_shiftres_v :
                      (exe_aluop_i == `MINIMIPS32_SRLV) ? (exe_src2_i >> exe_src1_i[`REG_ADDR_BUS]) : `ZERO_WORD;

  wire                                                                                                                       [31 : 0] exe_src2_t = (exe_aluop_i == `MINIMIPS32_SUB) ? (~exe_src2_i) + 1 : exe_src2_i;
  wire                                                                                                                       [31 : 0] arith_tmp = exe_src1_i + exe_src2_t;
  wire ov = ((!exe_src1_i[31] && !exe_src2_t[31] && arith_tmp[31]) || (exe_src1_i[31] && exe_src2_t[31] && !arith_tmp[31]));
  wire inst_ov = (exe_aluop_i == `MINIMIPS32_ADD || exe_aluop_i == `MINIMIPS32_ADDI || exe_aluop_i == `MINIMIPS32_SUB);


  assign sign_mulres   = ($signed(exe_src1_i) * $signed(exe_src2_i));
  assign unsign_mulres = ($unsigned({1'b0, exe_src1_i}) * $unsigned({1'b0, exe_src2_i}));
  assign exe_hilo_o    = (exe_aluop_i == `MINIMIPS32_MULT) ? sign_mulres : (exe_aluop_i == `MINIMIPS32_MULTU) ? unsign_mulres : (exe_aluop_i == `MINIMIPS32_MTHI) ? {exe_src1_i, lo_t} : (exe_aluop_i == `MINIMIPS32_MTLO) ? {hi_t, exe_src1_i} : `ZERO_DWORD;



  assign exe_wa_o      = exe_wa_i;
  assign exe_wreg_o    = exe_wreg_i;

  assign exe_wd_o      = (exe_alutype_i == `LOGIC) ? logicres : (exe_alutype_i == `MOVE) ? moveres : (exe_alutype_i == `SHIFT) ? shiftres : (exe_alutype_i == `ARITH) ? arithres : `ZERO_WORD;

  assign debug_wb_pc   = exe_debug_wb_pc;  // 上板测试时务必删除该语句
  assign debug_info    = exe_src1_i;
  
  //exe2id数据前推
  assign exe2id_wa = exe_wa_i; 
  assign exe2id_wd = exe_wd_o;
  assign exe2id_wreg = exe_wreg_i;
endmodule

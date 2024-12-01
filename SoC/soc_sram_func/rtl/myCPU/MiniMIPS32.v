`include "defines.v"

module MiniMIPS32 (
    input wire cpu_clk_50M,
    input wire cpu_rst_n,


    output wire [`INST_ADDR_BUS] iaddr,
    output wire                  ice,
    input  wire [     `INST_BUS] inst,

    output wire                  dce,
    output wire [`INST_ADDR_BUS] daddr,
    output wire [     `BSEL_BUS] we,
    output wire [     `INST_BUS] din,
    input  wire [     `INST_BUS] dm,
    input  wire [      `INT_LEN] int,
    output wire [`INST_ADDR_BUS] debug_wb_pc,
    output wire [     `BSEL_BUS] debug_wb_rf_wen,
    output wire [ `REG_ADDR_BUS] debug_wb_rf_wnum,
    output wire [     `WORD_BUS] debug_wb_rf_wdata


);

  wire [      `WORD_BUS]  pc;
  wire [       `REG_BUS]  o_Cause;
  wire [       `REG_BUS]  o_Status;
  wire                    flush;
  wire [ `INST_ADDR_BUS]  excaddr;
  wire                    id_c_ds_i;
  wire                    id_c_ds_o;
  wire [   `EXCTYPE_BUS]  id_exctype_o;
  wire [ `INST_ADDR_BUS]  id_cur_pc_o;
  wire                    id_n_ds_o;
  wire [  `REG_ADDR_BUS]  id_cp0_rt_o;
  wire                    exe_c_ds_i;
  wire [   `EXCTYPE_BUS]  exe_exctype_i;
  wire [ `INST_ADDR_BUS]  exe_cur_pc_i;
  wire                    exe_c_ds_o;
  wire [   `EXCTYPE_BUS]  exe_exctype_o;
  wire [ `INST_ADDR_BUS]  exe_cur_pc_o;
  wire [  `REG_ADDR_BUS]  exe_cp0_rt_i;
  wire [       `REG_BUS]  cp0_din;
  wire                    exe_cp0_we_o;
  wire [  `REG_ADDR_BUS]  exe_cp0_ra_o;
  wire [  `REG_ADDR_BUS]  exe_cp0_wa_o;
  wire [       `REG_BUS]  exe_cp0_wd_o;
  wire                    mem_c_ds_i;
  wire [   `EXCTYPE_BUS]  mem_exctype_i;
  wire [ `INST_ADDR_BUS]  mem_cur_pc_i;
  wire                    mem_cp0_we_i;
  wire [  `REG_ADDR_BUS]  mem_cp0_wa_i;
  wire [       `REG_BUS]  mem_cp0_wd_i;
  wire                    mem_c_ds_o;
  wire [   `EXCTYPE_BUS]  mem_exctype_o;
  wire [ `INST_ADDR_BUS]  mem_cur_pc_o;
  wire [       `REG_BUS]  mem_badvaddr_o;
  wire                    mem_cp0_we_o;
  wire [  `REG_ADDR_BUS]  mem_cp0_wa_o;
  wire [       `REG_BUS]  mem_cp0_wd_o;
  wire                    wb_cp0_we_i;
  wire [  `REG_ADDR_BUS]  wb_cp0_wa_i;
  wire [       `REG_BUS]  wb_cp0_wd_i;
  wire                    wb_cp0_we_o;
  wire [  `REG_ADDR_BUS]  wb_cp0_wa_o;
  wire [       `REG_BUS]  wb_cp0_wd_o;
  wire [      `WORD_BUS]  id_pc_i;

  /*跳转信号*/
  wire [            1:0 ] jtsel;
  wire [ `INST_ADDR_BUS]  jump_addr_1;
  wire [ `INST_ADDR_BUS]  jump_addr_2;
  wire [ `INST_ADDR_BUS]  jump_addr_3;
  wire [ `INST_ADDR_BUS]  ret_addr;

  wire                    re1;
  wire [  `REG_ADDR_BUS]  ra1;
  wire [       `REG_BUS]  rd1;
  wire                    re2;
  wire [  `REG_ADDR_BUS]  ra2;
  wire [       `REG_BUS]  rd2;

  wire [     `ALUOP_BUS]  id_aluop_o;
  wire [   `ALUTYPE_BUS]  id_alutype_o;
  wire [       `REG_BUS]  id_src1_o;
  wire [       `REG_BUS]  id_src2_o;
  wire                    id_wreg_o;
  wire                    id_we_o;
  wire                    id_mreg_o;
  wire [      `WORD_BUS]  id_din_o;
  wire                    id_whilo_o;
  wire [  `REG_ADDR_BUS]  id_wa_o;
  wire [ `INST_ADDR_BUS]  id_ret_addr;
  wire [     `ALUOP_BUS]  exe_aluop_i;
  wire [   `ALUTYPE_BUS]  exe_alutype_i;
  wire [       `REG_BUS]  exe_src1_i;
  wire [       `REG_BUS]  exe_src2_i;
  wire                    exe_wreg_i;
  wire                    exe_mreg_i;
  wire [`DOUBLE_REG_BUS]  exe_mulres_i;
  wire                    exe_whilo_i;
  wire [  `REG_ADDR_BUS]  exe_wa_i;
  wire [       `REG_BUS]  exe_din_i;


  wire [       `REG_BUS]  exe_hi_i;
  wire [       `REG_BUS]  exe_lo_i;
  wire [       `REG_BUS]  exe_hi_o;
  wire [       `REG_BUS]  exe_lo_o;

  wire [     `ALUOP_BUS]  exe_aluop_o;
  wire                    exe_wreg_o;
  wire                    exe_mreg_o;
  wire                    exe_whilo_o;
  wire [  `REG_ADDR_BUS]  exe_wa_o;
  wire [       `REG_BUS]  exe_wd_o;
  wire [`DOUBLE_REG_BUS]  exe_mulres_o;
  wire [       `REG_BUS]  exe_din_o;
  wire [ `INST_ADDR_BUS]  exe_ret_addr;

  wire [     `ALUOP_BUS]  mem_aluop_i;
  wire                    mem_wreg_i;
  wire                    mem_mreg_i;
  wire [      `WORD_BUS]  mem_din_i;
  wire                    mem_whilo_i;
  wire [  `REG_ADDR_BUS]  mem_wa_i;
  wire [       `REG_BUS]  mem_wd_i;
  wire [`DOUBLE_REG_BUS]  mem_mulres_i;

  wire [     `ALUOP_BUS]  mem_aluop_o;
  wire                    mem_wreg_o;
  wire                    mem_mreg_o;
  wire                    mem_whilo_o;
  wire [  `REG_ADDR_BUS]  mem_wa_o;
  wire [       `REG_BUS]  mem_dreg_o;
  wire [`DOUBLE_REG_BUS]  mem_mulres_o;
  wire [      `WORD_BUS]  mem_dm_o;
  wire [      `BSEL_BUS]  mem_dre_o;

  wire [     `ALUOP_BUS]  wb_aluop_i;
  wire                    wb_whilo_i;
  wire                    wb_wreg_i;
  wire                    wb_mreg_i;
  wire [  `REG_ADDR_BUS]  wb_wa_i;
  wire [       `REG_BUS]  wb_dreg_i;
  wire [`DOUBLE_REG_BUS]  wb_mulres_i;
  wire [      `WORD_BUS]  wb_dm_i;
  wire [      `BSEL_BUS]  wb_dre_i;

  wire                    wb_wreg_o;
  wire                    wb_whilo_o;
  wire [  `REG_ADDR_BUS]  wb_wa_o;
  wire [       `REG_BUS]  wb_wd_o;

  /*-----前推信号-----*/
  wire                    stallreg_id;
  wire [          1 : 0 ] mem2exe_whilo;
  wire [`DOUBLE_REG_BUS]  mem2exe_hilo;
  wire [     `ALUOP_BUS]  mem2exe_aluop;
  wire [          1 : 0 ] wb2exe_whilo;
  wire [`DOUBLE_REG_BUS]  wb2exe_hilo;
  wire [  `REG_ADDR_BUS]  exe2id_wa;
  wire                    exe2id_wreg;
  wire [       `REG_BUS]  exe2id_wd;
  wire                    exe2id_mreg;
  wire                    stallreg_exe;
  wire [  `REG_ADDR_BUS]  mem2id_wa;
  wire                    mem2id_wreg;
  wire [       `REG_BUS]  mem2id_wd;
  wire                    mem2id_mreg;

  wire [ `INST_ADDR_BUS]  if_debug_wb_pc;
  wire [ `INST_ADDR_BUS]  id_debug_wb_pc_i;
  wire [ `INST_ADDR_BUS]  id_debug_wb_pc_o;
  wire [ `INST_ADDR_BUS]  exe_debug_wb_pc_i;
  wire [ `INST_ADDR_BUS]  exe_debug_wb_pc_o;
  wire [ `INST_ADDR_BUS]  mem_debug_wb_pc_i;
  wire [ `INST_ADDR_BUS]  mem_debug_wb_pc_o;
  wire [ `INST_ADDR_BUS]  wb_debug_wb_pc_i;

  reg  [          3 : 0 ] stall;


  always @(*) begin
    if (!flush && stallreg_exe == `STOP_ENABLE) begin
      stall = 4'b1111;
    end else if (!flush && stallreg_id == `STOP_ENABLE) begin
      stall = 4'b1110;
    end else stall = 4'b0000;
  end

  if_stage if_stage0 (
      .cpu_clk_50M(cpu_clk_50M),
      .cpu_rst_n  (cpu_rst_n),
      .pc         (pc),
      .ice        (ice),
      .iaddr      (iaddr),
      .debug_wb_pc(if_debug_wb_pc),
      .jtsel      (jtsel),
      .jump_addr_1(jump_addr_1),
      .jump_addr_2(jump_addr_2),
      .jump_addr_3(jump_addr_3),
      .stall      (stall),
      .flush      (flush),
      .excaddr    (excaddr)
  );

  ifid_reg ifid_reg0 (
      .cpu_clk_50M   (cpu_clk_50M),
      .cpu_rst_n     (cpu_rst_n),
      .if_pc         (pc),
      .if_debug_wb_pc(if_debug_wb_pc),
      .stall         (stall),
      .id_pc         (id_pc_i),
      .id_debug_wb_pc(id_debug_wb_pc_i),
      //cp0
      .flush         (flush)
  );

  id_stage id_stage0 (
      .id_pc_i       (id_pc_i),
      .id_inst_i     (inst),
      .id_debug_wb_pc(id_debug_wb_pc_i),
      .rd1           (rd1),
      .rd2           (rd2),
      .exe2id_wa     (exe2id_wa),
      .exe2id_wreg   (exe2id_wreg),
      .exe2id_wd     (exe2id_wd),
      .mem2id_wa     (mem2id_wa),
      .mem2id_wreg   (mem2id_wreg),
      .mem2id_wd     (mem2id_wd),
      .exe2id_mreg   (exe2id_mreg),
      .mem2id_mreg   (mem2id_mreg),
      .ra1           (ra1),
      .ra2           (ra2),
      .id_aluop_o    (id_aluop_o),
      .id_alutype_o  (id_alutype_o),
      .id_src1_o     (id_src1_o),
      .id_src2_o     (id_src2_o),
      .id_wa_o       (id_wa_o),
      .id_we_o       (id_wreg_o),
      .id_whilo_o    (id_whilo_o),
      .id_mreg_o     (id_mreg_o),
      .id_din_o      (id_din_o),
      .jtsel         (jtsel),
      .jump_addr_1   (jump_addr_1),
      .jump_addr_2   (jump_addr_2),
      .jump_addr_3   (jump_addr_3),
      .ret_addr      (id_ret_addr),
      .stallreg_id   (stallreg_id),
      .debug_wb_pc   (id_debug_wb_pc_o),
      //cp0
      .flush         (flush),
      .c_ds_i        (id_c_ds_i),
      .c_ds_o        (id_c_ds_o),
      .exctype       (id_exctype_o),
      .cur_pc        (id_cur_pc_o),
      .n_ds          (id_n_ds_o),
      //cp02
      .cp0_rt        (id_cp0_rt_o)
  );

  regfile regfile0 (
      .cpu_clk_50M(cpu_clk_50M),
      .cpu_rst_n  (cpu_rst_n),
      .we         (wb_wreg_o),
      .wa         (wb_wa_o),
      .wd         (wb_wd_o),
      .ra1        (ra1),
      .rd1        (rd1),
      .ra2        (ra2),
      .rd2        (rd2)
  );

  idexe_reg idexe_reg0 (
      .cpu_clk_50M    (cpu_clk_50M),
      .cpu_rst_n      (cpu_rst_n),
      .id_alutype     (id_alutype_o),
      .id_aluop       (id_aluop_o),
      .id_src1        (id_src1_o),
      .id_src2        (id_src2_o),
      .id_wa          (id_wa_o),
      .id_wreg        (id_wreg_o),
      .id_mreg        (id_mreg_o),
      .id_din         (id_din_o),
      .id_whilo       (id_whilo_o),
      .id_ret_addr    (id_ret_addr),
      .id_debug_wb_pc (id_debug_wb_pc_o),
      .stall          (stall),
      .exe_alutype    (exe_alutype_i),
      .exe_aluop      (exe_aluop_i),
      .exe_src1       (exe_src1_i),
      .exe_src2       (exe_src2_i),
      .exe_wa         (exe_wa_i),
      .exe_wreg       (exe_wreg_i),
      .exe_whilo      (exe_whilo_i),
      .exe_mreg       (exe_mreg_i),
      .exe_din        (exe_din_i),
      .exe_ret_addr   (exe_ret_addr),
      .exe_debug_wb_pc(exe_debug_wb_pc_i),
      //cp0
      .flush          (flush),
      .id_c_ds        (id_c_ds_o),
      .id_exctype     (id_exctype_o),
      .id_cur_pc      (id_cur_pc_o),
      .id_n_ds        (id_n_ds_o),
      .exe_c_ds       (exe_c_ds_i),
      .exe_exctype    (exe_exctype_i),
      .exe_cur_pc     (exe_cur_pc_i),
      .exe_n_ds       (id_c_ds_i),
      //cp02
      .id_cp0_rt      (id_cp0_rt_o),
      .exe_cp0_rt     (exe_cp0_rt_i)
  );


  exe_stage exe_stage0 (
      .cpu_clk_50M    (cpu_clk_50M),
      .cpu_rst_n      (cpu_rst_n),
      .exe_alutype_i  (exe_alutype_i),
      .exe_aluop_i    (exe_aluop_i),
      .exe_whilo_i    (exe_whilo_i),
      .exe_wa_i       (exe_wa_i),
      .exe_wreg_i     (exe_wreg_i),
      .exe_mreg_i     (exe_mreg_i),
      .exe_src1_i     (exe_src1_i),
      .exe_src2_i     (exe_src2_i),
      .exe_din_i      (exe_din_i),
      .exe_ret_addr   (exe_ret_addr),
      .exe_debug_wb_pc(exe_debug_wb_pc_i),
      .hi_i           (exe_hi_o),
      .lo_i           (exe_lo_o),
      .mem2exe_whilo  (mem2exe_whilo),
      .mem2exe_hilo   (mem2exe_hilo),
      .wb2exe_whilo   (wb2exe_whilo),
      .wb2exe_hilo    (wb2exe_hilo),
      .exe_aluop_o    (exe_aluop_o),
      .exe_whilo_o    (exe_whilo_o),
      .exe_wa_o       (exe_wa_o),
      .exe_wreg_o     (exe_wreg_o),
      .exe_mreg_o     (exe_mreg_o),
      .exe_din_o      (exe_din_o),
      .exe_wd_o       (exe_wd_o),
      .exe_mulres_o   (exe_mulres_o),
      .debug_wb_pc    (exe_debug_wb_pc_o),
      .exe2id_wa      (exe2id_wa),
      .exe2id_wreg    (exe2id_wreg),
      .exe2id_wd      (exe2id_wd),
      .exe2id_mreg    (exe2id_mreg),
      .stallreg_exe   (stallreg_exe),
      //cp0
      .exe_c_ds_i     (exe_c_ds_i),
      .exe_exctype_i  (exe_exctype_i),
      .exe_cur_pc_i   (exe_cur_pc_i),
      .exe_c_ds_o     (exe_c_ds_o),
      .exe_exctype_o  (exe_exctype_o),
      .exe_cur_pc_o   (exe_cur_pc_o),
      //cp02
      .exe_cp0_rt     (exe_cp0_rt_i),
      .cp0_din        (cp0_din),
      .exe_cp0_we_o   (exe_cp0_we_o),
      .exe_cp0_ra_o   (exe_cp0_ra_o),
      .exe_cp0_wa_o   (exe_cp0_wa_o),
      .exe_cp0_wd_o   (exe_cp0_wd_o),
      //cp0 datarel
      .mem_cp0_we_o   (mem_cp0_we_o),
      .mem_cp0_wa_o   (mem_cp0_wa_o),
      .mem_cp0_wd_o   (mem_cp0_wd_o),
      .wb_cp0_we_o    (wb_cp0_we_o),
      .wb_cp0_wa_o    (wb_cp0_wa_o),
      .wb_cp0_wd_o    (wb_cp0_wd_o)
  );

  hilo hilo0 (
      .cpu_clk_50M(cpu_clk_50M),
      .cpu_rst_n  (cpu_rst_n),
      .we         (wb_whilo_o),
      .hi_i       (exe_hi_i),
      .lo_i       (exe_lo_i),
      .hi_o       (exe_hi_o),
      .lo_o       (exe_lo_o)
  );

  exemem_reg exemem_reg0 (
      .cpu_clk_50M    (cpu_clk_50M),
      .cpu_rst_n      (cpu_rst_n),
      .exe_aluop      (exe_aluop_o),
      .exe_whilo      (exe_whilo_o),
      .exe_wa         (exe_wa_o),
      .exe_wreg       (exe_wreg_o),
      .exe_mreg       (exe_mreg_o),
      .exe_din        (exe_din_o),
      .exe_wd         (exe_wd_o),
      .exe_mulres     (exe_mulres_o),
      .exe_debug_wb_pc(exe_debug_wb_pc_o),
      .stall          (stall),
      .mem_aluop      (mem_aluop_i),
      .mem_whilo      (mem_whilo_i),
      .mem_wa         (mem_wa_i),
      .mem_wreg       (mem_wreg_i),
      .mem_mreg       (mem_mreg_i),
      .mem_wd         (mem_wd_i),
      .mem_mulres     (mem_mulres_i),
      .mem_din        (mem_din_i),
      .mem_debug_wb_pc(mem_debug_wb_pc_i),
      //cp0
      .flush          (flush),
      .exe_c_ds       (exe_c_ds_o),
      .exe_exctype    (exe_exctype_o),
      .exe_cur_pc     (exe_cur_pc_o),
      .mem_c_ds       (mem_c_ds_i),
      .mem_exctype    (mem_exctype_i),
      .mem_cur_pc     (mem_cur_pc_i),
      //cp02
      .exe_cp0_we     (exe_cp0_we_o),
      .exe_cp0_wa     (exe_cp0_wa_o),
      .exe_cp0_wd     (exe_cp0_wd_o),
      .mem_cp0_we     (mem_cp0_we_i),
      .mem_cp0_wa     (mem_cp0_wa_i),
      .mem_cp0_wd     (mem_cp0_wd_i)
  );

  mem_stage mem_stage0 (
      .mem_aluop_i      (mem_aluop_i),
      .mem_whilo_i      (mem_whilo_i),
      .mem_wa_i         (mem_wa_i),
      .mem_wreg_i       (mem_wreg_i),
      .mem_wd_i         (mem_wd_i),
      .mem_mreg_i       (mem_mreg_i),
      .mem_mulres_i     (mem_mulres_i),
      .mem_din_i        (mem_din_i),
      .dm               (dm),
      .mem_debug_wb_pc_i(mem_debug_wb_pc_i),
      .mem_aluop_o      (mem_aluop_o),
      .mem_whilo_o      (mem_whilo_o),
      .mem_wa_o         (mem_wa_o),
      .mem_wreg_o       (mem_wreg_o),
      .mem_dreg_o       (mem_dreg_o),
      .mem_mreg_o       (mem_mreg_o),
      .mem_mulres_o     (mem_mulres_o),
      .mem_dm_o         (mem_dm_o),
      .dre              (mem_dre_o),
      .dce              (dce),
      .daddr            (daddr),
      .we               (we),
      .din              (din),
      .debug_wb_pc      (mem_debug_wb_pc_o),
      .mem2exe_whilo    (mem2exe_whilo),
      .mem2exe_hilo     (mem2exe_hilo),
      .mem2exe_aluop    (mem2exe_aluop),
      .mem2id_wa        (mem2id_wa),
      .mem2id_wreg      (mem2id_wreg),
      .mem2id_wd        (mem2id_wd),
      .mem2id_mreg      (mem2id_mreg),
      //cp0
      .mem_c_ds_i       (mem_c_ds_i),
      .mem_exctype_i    (mem_exctype_i),
      .mem_cur_pc_i     (mem_cur_pc_i),
      .mem_c_ds_o       (mem_c_ds_o),
      .mem_exctype_o    (mem_exctype_o),
      .mem_cur_pc_o     (mem_cur_pc_o),
      .mem_badvaddr_o   (mem_badvaddr_o),
      .in_Cause         (o_Cause),
      .in_Status        (o_Status),
      //cp02
      .mem_cp0_we_i     (mem_cp0_we_i),
      .mem_cp0_wa_i     (mem_cp0_wa_i),
      .mem_cp0_wd_i     (mem_cp0_wd_i),
      .mem_cp0_we_o     (mem_cp0_we_o),
      .mem_cp0_wa_o     (mem_cp0_wa_o),
      .mem_cp0_wd_o     (mem_cp0_wd_o)
  );

  memwb_reg memwb_reg0 (
      .cpu_clk_50M    (cpu_clk_50M),
      .cpu_rst_n      (cpu_rst_n),
      .mem_aluop      (mem_aluop_o),
      .mem_whilo      (mem_whilo_o),
      .mem_wa         (mem_wa_o),
      .mem_wreg       (mem_wreg_o),
      .mem_dreg       (mem_dreg_o),
      .mem_mreg       (mem_mreg_o),
      .mem_mulres     (mem_mulres_o),
      .mem_dm         (mem_dm_o),
      .mem_dre        (mem_dre_o),
      .mem_debug_wb_pc(mem_debug_wb_pc_o),
      .wb_aluop       (wb_aluop_i),
      .wb_whilo       (wb_whilo_i),
      .wb_wa          (wb_wa_i),
      .wb_wreg        (wb_wreg_i),
      .wb_dreg        (wb_dreg_i),
      .wb_mreg        (wb_mreg_i),
      .wb_mulres      (wb_mulres_i),
      .wb_dm          (wb_dm_i),
      .wb_dre         (wb_dre_i),
      .wb_debug_wb_pc (wb_debug_wb_pc_i),
      //cp0
      .flush          (flush),
      //cp02
      .mem_cp0_we     (mem_cp0_we_o),
      .mem_cp0_wa     (mem_cp0_wa_o),
      .mem_cp0_wd     (mem_cp0_wd_o),
      .wb_cp0_we      (wb_cp0_we_i),
      .wb_cp0_wa      (wb_cp0_wa_i),
      .wb_cp0_wd      (wb_cp0_wd_i)
  );

  wb_stage wb_stage0 (
      .wb_aluop_i       (wb_aluop_i),
      .wb_whilo_i       (wb_whilo_i),
      .wb_mulres_i      (wb_mulres_i),
      .wb_wa_i          (wb_wa_i),
      .wb_wreg_i        (wb_wreg_i),
      .wb_mreg_i        (wb_mreg_i),
      .wb_dreg_i        (wb_dreg_i),
      .wb_dm_i          (wb_dm_i),
      .wb_dre_i         (wb_dre_i),
      .wb_debug_wb_pc   (wb_debug_wb_pc_i),
      .wb_whilo_o       (wb_whilo_o),
      .wb_wa_o          (wb_wa_o),
      .wb_wreg_o        (wb_wreg_o),
      .wb_wd_o          (wb_wd_o),
      .wb_hi_o          (exe_hi_i),
      .wb_lo_o          (exe_lo_i),
      .debug_wb_pc      (debug_wb_pc),
      .debug_wb_rf_wen  (debug_wb_rf_wen),
      .debug_wb_rf_wnum (debug_wb_rf_wnum),
      .debug_wb_rf_wdata(debug_wb_rf_wdata),
      .wb2exe_whilo     (wb2exe_whilo),
      .wb2exe_hilo      (wb2exe_hilo),
      //cp02
      .wb_cp0_we_i      (wb_cp0_we_i),
      .wb_cp0_wa_i      (wb_cp0_wa_i),
      .wb_cp0_wd_i      (wb_cp0_wd_i),
      .wb_cp0_we_o      (wb_cp0_we_o),
      .wb_cp0_wa_o      (wb_cp0_wa_o),
      .wb_cp0_wd_o      (wb_cp0_wd_o)
  );

  cp0 cp00 (
      .cpu_clk_50M(cpu_clk_50M),
      .cpu_rst_n  (cpu_rst_n),
      .we         (wb_cp0_we_o),
      .ra         (exe_cp0_ra_o),
      .wa         (wb_cp0_wa_o),
      .wd         (wb_cp0_wd_o),
      .exctype    (mem_exctype_o),
      .cur_pc     (mem_cur_pc_o),
      .c_ds       (mem_c_ds_o),
      .badvaddr_i (mem_badvaddr_o),
      .rd         (cp0_din),
      .flush      (flush),
      .excaddr    (excaddr),
      .o_Cause    (o_Cause),
      .o_Status   (o_Status),
      .int        (int)
  );
endmodule

`include "defines.v"

module exe_stage (
    input wire cpu_rst_n,
    input wire cpu_clk_50M,

    input wire [  `ALUTYPE_BUS] exe_alutype_i,
    input wire [    `ALUOP_BUS] exe_aluop_i,
    input wire                  exe_whilo_i,
    input wire [ `REG_ADDR_BUS] exe_wa_i,
    input wire                  exe_wreg_i,
    input wire                  exe_mreg_i,
    input wire [      `REG_BUS] exe_din_i,
    input wire [      `REG_BUS] exe_src1_i,
    input wire [      `REG_BUS] exe_src2_i,
    input wire [`INST_ADDR_BUS] exe_ret_addr,
    input wire [`INST_ADDR_BUS] exe_debug_wb_pc,

    input wire [`REG_BUS] hi_i,
    input wire [`REG_BUS] lo_i,

    input wire [          1 : 0] mem2exe_whilo,
    input wire [`DOUBLE_REG_BUS] mem2exe_hilo,
    input wire [          1 : 0] wb2exe_whilo,
    input wire [`DOUBLE_REG_BUS] wb2exe_hilo,

    output wire [     `ALUOP_BUS] exe_aluop_o,
    output wire                   exe_whilo_o,
    output wire [  `REG_ADDR_BUS] exe_wa_o,
    output wire                   exe_wreg_o,
    output wire                   exe_mreg_o,
    output wire [       `REG_BUS] exe_din_o,
    output wire [       `REG_BUS] exe_wd_o,
    output wire [`DOUBLE_REG_BUS] exe_mulres_o,
    output wire [ `INST_ADDR_BUS] debug_wb_pc,

    //back to idstage
    output wire [ `REG_ADDR_BUS] exe2id_wa,
    output wire                  exe2id_wreg,
    output wire [      `REG_BUS] exe2id_wd,
    output wire [      `REG_BUS] exe2id_mreg,
    output wire                  stallreg_exe,
    //cp0
    input  wire                  exe_c_ds_i,
    input  wire [  `EXCTYPE_BUS] exe_exctype_i,
    input  wire [`INST_ADDR_BUS] exe_cur_pc_i,
    output wire                  exe_c_ds_o,
    output reg  [  `EXCTYPE_BUS] exe_exctype_o,
    output wire [`INST_ADDR_BUS] exe_cur_pc_o,
    //cp02
    input  wire [ `REG_ADDR_BUS] exe_cp0_rt,
    input  wire [      `REG_BUS] cp0_din,
    output wire                  exe_cp0_we_o,
    output wire [ `REG_ADDR_BUS] exe_cp0_ra_o,
    output wire [ `REG_ADDR_BUS] exe_cp0_wa_o,
    output wire [      `REG_BUS] exe_cp0_wd_o,
    //cp0 datarel
    input  wire                  mem_cp0_we_o,
    input  wire [ `REG_ADDR_BUS] mem_cp0_wa_o,
    input  wire [      `REG_BUS] mem_cp0_wd_o,
    input  wire                  wb_cp0_we_o,
    input  wire [ `REG_ADDR_BUS] wb_cp0_wa_o,
    input  wire [      `REG_BUS] wb_cp0_wd_o
);


  assign exe_aluop_o = exe_aluop_i;
  reg                    ov;
  reg  [       `REG_BUS] arithres;
  reg  [       `REG_BUS] logicres;
  reg  [`DOUBLE_REG_BUS] mulres;
  reg  [       `REG_BUS] shiftres;
  reg  [       `REG_BUS] moveres;
  reg  [       `REG_BUS] jumpres;
  reg  [`DOUBLE_REG_BUS] divres;

  reg                    div_rd;
  wire                   div_start;

  assign stallreg_exe = ((exe_aluop_i == `MINIMIPS32_DIV || exe_aluop_i == `MINIMIPS32_DIVU) && div_rd == `DIV_NOT_READY) ? `STOP : `START;
  assign div_start    = ((exe_aluop_i == `MINIMIPS32_DIV || exe_aluop_i == `MINIMIPS32_DIVU) && div_rd == `DIV_NOT_READY) ? `DIV_START : `DIV_STOP;

  reg  [`REG_BUS]  div_data1;
  reg  [`REG_BUS]  div_data2;
  wire [    34:0 ] div_temp1;
  wire [    34:0 ] div_temp2;
  wire [    34:0 ] div_temp3;
  wire [    34:0 ] div_temp;
  reg  [    33:0 ] divisor1;
  wire [    33:0 ] divisor2;
  wire [    33:0 ] divisor3;
  reg  [    65:0 ] div;
  reg  [     1:0 ] state;
  reg  [     4:0 ] cnt;
  wire [     1:0 ] div_cnt;
  assign divisor2  = divisor1 << 1;
  assign divisor3  = divisor1 + divisor2;
  assign div_temp1 = {3'b000, div[63:32]} - {1'b0, divisor1};
  assign div_temp2 = {3'b000, div[63:32]} - {1'b0, divisor2};
  assign div_temp3 = {3'b000, div[63:32]} - {1'b0, divisor3};

  assign div_temp  = (div_temp3[34] == 1'b0) ? div_temp3 : (div_temp2[34] == 1'b0) ? div_temp2 : div_temp1;
  assign div_cnt   = (div_temp3[34] == 1'b0) ? 2'b11 : (div_temp2[34] == 1'b0) ? 2'b10 : 2'b01;


  always @(posedge cpu_clk_50M) begin
    if (cpu_rst_n == `RST_ENABLE) begin
      state  <= `DIV_FREE;
      div_rd <= `DIV_NOT_READY;
      divres <= `ZERO_DWORD;
    end else begin
      case (state)
        `DIV_FREE: begin
          if (div_start == `DIV_START) begin
            if (exe_src2_i == `ZERO_WORD) begin
              state <= `DIV_ZERO;
            end else begin
              state <= `DIV_ON;
              cnt   <= 5'b000000;
              if (exe_aluop_i == `MINIMIPS32_DIV && exe_src1_i[31] == 1'b1) begin
                div_data1 = ~exe_src1_i + 1;
              end else begin
                div_data1 = exe_src1_i;
              end
              if (exe_aluop_i == `MINIMIPS32_DIV && exe_src2_i[31] == 1'b1) begin
                div_data2 = ~exe_src2_i + 1;
              end else begin
                div_data2 = exe_src2_i;
              end
              div      <= {`ZERO_WORD, div_data1, 2'b00};
              divisor1 <= div_data2;
            end
          end else begin
            div_rd <= `DIV_NOT_READY;
            divres <= `ZERO_DWORD;
          end
        end
        `DIV_ZERO: begin
          div   <= {2'b00, `ZERO_DWORD};
          state <= `DIV_FINISHED;
        end
        `DIV_ON: begin
          if (cnt < 5'b10000) begin
            if (div_temp[34] == 1'b1) begin
              div <= {div[63:0], 2'b00};
            end else begin
              div <= {div_temp[31:0], div[31:0], div_cnt};
            end
            cnt <= cnt + 1;
          end else begin
            if ((exe_src1_i[31] ^ (exe_src2_i[31]) == 1'b1) && exe_aluop_i == `MINIMIPS32_DIV) begin
              div[31:0] <= (~div[31:0] + 1);
            end
            if (((exe_src1_i[31] ^ div[65]) == 1'b1) && exe_aluop_i == `MINIMIPS32_DIV) begin
              div[65:34] <= (~div[65:34] + 1);
            end
            state <= `DIV_FINISHED;
            cnt   <= 5'b00000;
          end
        end
        `DIV_FINISHED: begin
          divres <= {div[65:34], div[31:0]};
          div_rd <= `DIV_READY;
          if (div_start == `DIV_STOP) begin
            state  <= `DIV_FREE;
            div_rd <= `DIV_NOT_READY;
            divres <= `ZERO_DWORD;
          end
        end
      endcase
    end
  end

  integer src1, src2;

  /*----------------------------ALU--------------------------------*/
  always @(*) begin
    src1 = exe_src1_i;
    src2 = exe_src2_i;
    case (exe_aluop_i)
      `MINIMIPS32_ADD: begin
        arithres = exe_src1_i + exe_src2_i;
        if (exe_src1_i[31] == 0 && exe_src2_i[31] == 0 && arithres[31] == 1) ov = 1;
        else if (exe_src1_i[31] == 1 && exe_src2_i[31] == 1 && arithres[31] == 0) ov = 1;
        else ov = 0;
      end
      `MINIMIPS32_ADDI: begin
        arithres = exe_src1_i + exe_src2_i;
        if (exe_src1_i[31] == 0 && exe_src2_i[31] == 0 && arithres[31] == 1) ov = 1;
        else if (exe_src1_i[31] == 1 && exe_src2_i[31] == 1 && arithres[31] == 0) ov = 1;
        else ov = 0;
      end
      `MINIMIPS32_ADDU: begin
        arithres = exe_src1_i + exe_src2_i;
      end
      `MINIMIPS32_ADDIU: begin
        arithres = exe_src1_i + exe_src2_i;
      end
      `MINIMIPS32_SUB: begin
        arithres = exe_src1_i - exe_src2_i;
        if (exe_src1_i[31] == 1 && exe_src2_i[31] == 0 && arithres[31] == 0) ov = 1;
        else if (exe_src1_i[31] == 0 && exe_src2_i[31] == 1 && arithres[31] == 1) ov = 1;
        else ov = 0;
      end
      `MINIMIPS32_SUBU: begin
        arithres = exe_src1_i - exe_src2_i;
      end
      `MINIMIPS32_SLT: begin
        arithres = (src1 < src2);
      end
      `MINIMIPS32_SLTI: begin
        arithres = (src1 < src2);
      end
      `MINIMIPS32_SLTU: begin
        arithres = (exe_src1_i < exe_src2_i);
      end
      `MINIMIPS32_SLTIU: begin
        arithres = (exe_src1_i < exe_src2_i);
      end
      `MINIMIPS32_MULT: begin
        mulres = ($signed({{32{exe_src1_i[31]}}, exe_src1_i}) * $signed({{32{exe_src2_i[31]}}, exe_src2_i}));
      end
      `MINIMIPS32_MULTU: begin
        mulres = ($signed({32'h00000000, exe_src1_i}) * $signed({32'h00000000, exe_src2_i}));
      end
      `MINIMIPS32_AND: begin
        logicres = exe_src1_i & exe_src2_i;
      end
      `MINIMIPS32_ANDI: begin
        logicres = exe_src1_i & exe_src2_i;
      end
      `MINIMIPS32_LUI: begin
        logicres = {exe_src2_i[31 : 16], 16'b0000000000000000};
      end
      `MINIMIPS32_NOR: begin
        logicres = ~(exe_src1_i | exe_src2_i);
      end
      `MINIMIPS32_OR: begin
        logicres = exe_src1_i | exe_src2_i;
      end
      `MINIMIPS32_ORI: begin
        logicres = exe_src1_i | exe_src2_i;
      end
      `MINIMIPS32_XOR: begin
        logicres = exe_src1_i ^ exe_src2_i;
      end
      `MINIMIPS32_XORI: begin
        logicres = exe_src1_i ^ exe_src2_i;
      end
      `MINIMIPS32_SLLV: begin
        shiftres = exe_src2_i << exe_src1_i[4:0];
      end
      `MINIMIPS32_SLL: begin
        shiftres = exe_src2_i << exe_src1_i;
      end
      `MINIMIPS32_SRAV: begin
        shiftres = src2 >>> exe_src1_i[4:0];
      end
      `MINIMIPS32_SRA: begin
        shiftres = src2 >>> exe_src1_i;
      end
      `MINIMIPS32_SRLV: begin
        shiftres = exe_src2_i >> exe_src1_i[4:0];
      end
      `MINIMIPS32_SRL: begin
        shiftres = exe_src2_i >> exe_src1_i;
      end
      `MINIMIPS32_LB: begin
        arithres = exe_src1_i + exe_src2_i;
      end
      `MINIMIPS32_LBU: begin
        arithres = exe_src1_i + exe_src2_i;
      end
      `MINIMIPS32_LH: begin
        arithres = exe_src1_i + exe_src2_i;
      end
      `MINIMIPS32_LHU: begin
        arithres = exe_src1_i + exe_src2_i;
      end
      `MINIMIPS32_LW: begin
        arithres = exe_src1_i + exe_src2_i;
      end
      `MINIMIPS32_SB: begin
        arithres = exe_src1_i + exe_src2_i;
      end
      `MINIMIPS32_SH: begin
        arithres = exe_src1_i + exe_src2_i;
      end
      `MINIMIPS32_SW: begin
        arithres = exe_src1_i + exe_src2_i;
      end
      `MINIMIPS32_BGEZAL: begin
        jumpres = exe_ret_addr;
      end
      `MINIMIPS32_BLTZAL: begin
        jumpres = exe_ret_addr;
      end
      `MINIMIPS32_JAL: begin
        jumpres = exe_ret_addr;
      end
      `MINIMIPS32_JALR: begin
        jumpres = exe_ret_addr;
      end
      default: begin
        logicres = `ZERO_WORD;
        mulres   = `ZERO_DWORD;
        shiftres = `ZERO_WORD;
        jumpres  = `ZERO_WORD;
      end
    endcase
  end

  reg [`REG_BUS] hi;
  reg [`REG_BUS] lo;
  always @(*) begin
    if (mem2exe_whilo[1] == `WHILO_ENABLE) begin
      hi = mem2exe_hilo[63 : 32];
    end else if (wb2exe_whilo[1] == `WHILO_ENABLE) begin
      hi = wb2exe_hilo[63 : 32];
    end else begin
      hi = hi_i;
    end

    if (mem2exe_whilo[0] == `WHILO_ENABLE) begin
      lo = mem2exe_hilo[31 : 0];
    end else if (wb2exe_whilo[0] == `WHILO_ENABLE) begin
      lo = wb2exe_hilo[31 : 0];
    end else begin
      lo = lo_i;
    end
  end
  always @(*) begin
    case (exe_aluop_i)
      `MINIMIPS32_MFHI: begin
        moveres = hi;
      end
      `MINIMIPS32_MFLO: begin
        moveres = lo;
      end
      `MINIMIPS32_MTHI: begin
        moveres = exe_src1_i;
      end
      `MINIMIPS32_MTLO: begin
        moveres = exe_src1_i;
      end
      default: moveres = `ZERO_WORD;
    endcase
  end
  assign exe_aluop_o = exe_aluop_i;



  reg [`REG_BUS] result;
  always @(*) begin
    case (exe_alutype_i)
      `ARITH: begin
        result = arithres;
      end
      `LOGIC: begin
        result = logicres;
      end
      `SHIFT: begin
        result = shiftres;
      end
      `MOVE: begin
        result = moveres;
      end
      `JUMP: begin
        result = jumpres;
      end
      default: result = `ZERO_WORD;
    endcase
  end

  assign exe_mulres_o = (exe_aluop_i == `MINIMIPS32_DIV || exe_aluop_i == `MINIMIPS32_DIVU) ? divres : (exe_aluop_i == `MINIMIPS32_MULT || exe_aluop_i == `MINIMIPS32_MULTU) ? mulres : `ZERO_DWORD;

  //cp0
  assign exe_c_ds_o   = exe_c_ds_i;
  assign exe_cur_pc_o = exe_cur_pc_i;
  always @(*) begin
    if ((exe_aluop_i == `MINIMIPS32_ADD || exe_aluop_i == `MINIMIPS32_ADDI || exe_aluop_i == `MINIMIPS32_SUB) && ov == 1) exe_exctype_o = `Ov;
    else exe_exctype_o = exe_exctype_i;
  end
  //cp02
  assign exe_cp0_we_o = (exe_aluop_i == `MINIMIPS32_MTC0) ? 1 : 0;
  assign exe_cp0_ra_o = exe_wa_i;
  assign exe_cp0_wa_o = exe_wa_i;
  assign exe_cp0_wd_o = exe_src2_i;

  assign exe_wa_o     = (exe_aluop_i == `MINIMIPS32_MFC0) ? exe_cp0_rt : exe_wa_i;
  assign exe2id_wa    = (exe_aluop_i == `MINIMIPS32_MFC0) ? exe_cp0_rt : exe_wa_i;
  assign exe_wd_o     = (exe_aluop_i != `MINIMIPS32_MFC0) ? result : (mem_cp0_we_o == 1 && mem_cp0_wa_o == exe_cp0_wa_o) ? mem_cp0_wd_o : (wb_cp0_we_o == 1 && wb_cp0_wa_o == exe_cp0_wa_o) ? wb_cp0_wd_o : cp0_din;
  assign exe2id_wd    = (exe_aluop_i != `MINIMIPS32_MFC0) ? result : (mem_cp0_we_o == 1 && mem_cp0_wa_o == exe_cp0_wa_o) ? mem_cp0_wd_o : (wb_cp0_we_o == 1 && wb_cp0_wa_o == exe_cp0_wa_o) ? wb_cp0_wd_o : cp0_din;
  assign exe2id_mreg  = exe_mreg_i;
  assign debug_wb_pc  = exe_debug_wb_pc;
  assign exe2id_wreg  = exe_wreg_i;
  assign exe_wreg_o   = exe_wreg_i;
  assign exe_mreg_o   = exe_mreg_i;
  assign exe_whilo_o  = exe_whilo_i;
  assign exe_din_o    = exe_din_i;
endmodule

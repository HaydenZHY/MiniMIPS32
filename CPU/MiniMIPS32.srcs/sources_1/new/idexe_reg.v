`include "defines.v"

module idexe_reg (
    input wire cpu_clk_50M,
    input wire cpu_rst_n,

    // ��������׶ε���Ϣ
    input wire [  `ALUTYPE_BUS] id_alutype,
    input wire [    `ALUOP_BUS] id_aluop,
    input wire [      `REG_BUS] id_src1,
    input wire [      `REG_BUS] id_src2,
    input wire [ `REG_ADDR_BUS] id_wa,
    input wire                  id_wreg,
    input wire                  id_whilo,
    input wire                  id_whi,
    input wire                  id_wlo,
    input wire                  id_mreg,
    input wire [      `REG_BUS] id_din,
    input wire [`INST_ADDR_BUS] id_debug_wb_pc, // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
    input wire [`INST_ADDR_BUS]    id_ret_addr, //��ת�������
    input  wire [3 : 0]             stall, //��ͣ������� ����
     //cp0
    input  wire                     flush,
    input  wire                     id_c_ds,
    input  wire [`EXCTYPE_BUS  ]     id_exctype,
    input  wire [`INST_ADDR_BUS]    id_cur_pc,
    input  wire                     id_n_ds,
    output reg                     exe_c_ds,
    output reg [`EXCTYPE_BUS  ]    exe_exctype,
    output reg [`INST_ADDR_BUS]    exe_cur_pc,
    output reg                     exe_n_ds,
    //cp02
    input wire [`REG_ADDR_BUS]      id_cp0_rt,
    output reg [`REG_ADDR_BUS]     exe_cp0_rt,

    // ����ִ�н׶ε���Ϣ
    output reg [  `ALUTYPE_BUS] exe_alutype,
    output reg [    `ALUOP_BUS] exe_aluop,
    output reg [      `REG_BUS] exe_src1,
    output reg [      `REG_BUS] exe_src2,
    output reg [ `REG_ADDR_BUS] exe_wa,
    output reg                  exe_wreg,
    output reg                  exe_whilo,
    output reg                  exe_whi,
    output reg                  exe_wlo,
    output reg                  exe_mreg,
    output reg [      `REG_BUS] exe_din,
    output reg [`INST_ADDR_BUS]    exe_ret_addr, //ת�����
    output reg [`INST_ADDR_BUS] exe_debug_wb_pc  // ������ʹ�õ�PCֵ���ϰ����ʱ���ɾ�����ź�
);

    always @(posedge cpu_clk_50M) begin
        // ��λ��ʱ������ִ�н׶ε���Ϣ��0
        if (cpu_rst_n == `RST_ENABLE||flush == 1) begin
            exe_alutype 	   <= `NOP;
            exe_aluop 		   <= `MINIMIPS32_SLL;
            exe_src1 		   <= `ZERO_WORD;
            exe_src2 		   <= `ZERO_WORD;
            exe_wa 			   <= `REG_NOP;
            exe_wreg    	   <= `WRITE_DISABLE;
            exe_mreg           <= `MREG_DISABLE;
            exe_din            <= `ZERO_WORD;
            exe_whilo          <= `WHILO_DISABLE;
            exe_ret_addr       <= `ZERO_WORD;
            exe_debug_wb_pc    <= `PC_INIT;   // �ϰ����ʱ���ɾ�������
            //cp0
            exe_c_ds           <= 0;
            exe_exctype        <= `noexe;
            exe_cur_pc         <= `PC_INIT;
            exe_n_ds           <= 0;
            //cp02
            exe_cp0_rt         <= `REG_NOP;
        end
        // ����������׶ε���Ϣ�Ĵ沢����ִ�н׶�
        else begin
            if(stall[1] == `STOP_ENABLE &&  stall[0] == `STOP_ENABLE) begin
                exe_alutype 	   <= exe_alutype;
                exe_aluop 		   <= exe_aluop;
                exe_src1 		   <= exe_src1;
                exe_src2 		   <= exe_src2;
                exe_wa 			   <= exe_wa;
                exe_wreg		   <= exe_wreg;
                exe_mreg           <= exe_mreg;
                exe_din            <= exe_din;
                exe_whilo          <= exe_whilo;
                exe_ret_addr       <= exe_ret_addr;
                exe_debug_wb_pc    <= exe_debug_wb_pc;
                //cp0
                exe_c_ds           <= exe_c_ds;
                exe_exctype        <= exe_exctype;
                exe_cur_pc         <= exe_cur_pc;
                exe_n_ds           <= exe_n_ds;
                //cp02
                exe_cp0_rt         <= exe_cp0_rt;
            end
            else if(stall[1] == `STOP_ENABLE &&  stall[0] == `STOP_DISABLE) begin
                exe_alutype 	   <= `NOP;
                exe_aluop 		   <= `MINIMIPS32_SLL;
                exe_src1 		   <= `ZERO_WORD;
                exe_src2 		   <= `ZERO_WORD;
                exe_wa 			   <= `REG_NOP;
                exe_wreg    	   <= `WRITE_DISABLE;
                exe_mreg           <= `MREG_DISABLE;
                exe_din            <= `ZERO_WORD;
                exe_whilo          <= `WHILO_DISABLE;
                exe_ret_addr       <= `ZERO_WORD;
                exe_debug_wb_pc    <= `PC_INIT;
                //cp0
                exe_c_ds           <= 0;
                exe_exctype        <= `noexe;
                exe_cur_pc         <= `PC_INIT;
                exe_n_ds           <= 0;
                //cp02
                exe_cp0_rt         <= `REG_NOP;
            end
            else begin
                exe_alutype 	   <= id_alutype;
                exe_aluop 		   <= id_aluop;
                exe_src1 		   <= id_src1;
                exe_src2 		   <= id_src2;
                exe_wa 			   <= id_wa;
                exe_wreg		   <= id_wreg;
                exe_mreg           <= id_mreg;
                exe_din            <= id_din;
                exe_whilo          <= id_whilo;
                exe_ret_addr       <= id_ret_addr;
                exe_debug_wb_pc    <= id_debug_wb_pc;   // �ϰ����ʱ���ɾ�������
                //cp0
                exe_c_ds           <= id_c_ds;
                exe_exctype        <= id_exctype;
                exe_cur_pc         <= id_cur_pc;
                exe_n_ds           <= id_n_ds;
                //cp02
                exe_cp0_rt         <= id_cp0_rt;
            end
        end
    end

endmodule

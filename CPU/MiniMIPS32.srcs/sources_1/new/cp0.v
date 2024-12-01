`include "defines.v"

module cp0 (
    input  wire                     cpu_clk_50M,
	input  wire                     cpu_rst_n,
    input  wire                     we,
    input  wire [`REG_ADDR_BUS ]    ra,
    input  wire [`REG_ADDR_BUS ]    wa,
	input  wire [`REG_BUS      ]    wd,
    input  wire [`EXCTYPE_BUS  ]    exctype,
    input  wire [`INST_ADDR_BUS]    cur_pc,
    input  wire                     c_ds,
    input  wire [`REG_BUS      ]    badvaddr_i,
    input wire  [5:0]               int, 
    output reg [`REG_BUS      ]     rd, 
    output reg                      flush,
    output reg [`INST_ADDR_BUS]     excaddr,
    //output to mem
    output wire [`REG_BUS]           o_Cause,
    output wire [`REG_BUS]           o_Status
    );
    // define four cp0reg
    reg [`REG_BUS] BadVAddr;
    reg [`REG_BUS] Status;
    reg [`REG_BUS] Cause;
    reg [`REG_BUS] EPC;
    //assign flush
    always @(*) begin
        if(cpu_rst_n != `RST_ENABLE&&exctype != `noexe) flush = 1;
        else flush = 0;
    end
    //assign excaddr
    always @(*) begin
        if (cpu_rst_n == `RST_ENABLE) begin
            excaddr = `PC_INIT;
        end
        else if (exctype == `Eret) begin
            if(wa == `EPC_ID && we == `WRITE_ENABLE ) excaddr = wd;
            else excaddr = EPC;
        end
        else excaddr = `EXEADDR;
    end
    //update cp0reg
    always @ (posedge cpu_clk_50M) begin
        if(cpu_rst_n == `RST_ENABLE)begin
            BadVAddr <= `BadVAddr_init;
            Status   <= `Status_init;
            Cause    <= `Cause_init;
            EPC      <= `EPC_init;
        end
        else begin
            Cause[15:10] <= int;
            if(exctype == `noexe && we == `WRITE_ENABLE)begin
                case (wa)
                    `BadVAddr_ID:  BadVAddr <= wd;
                    `Status_ID:    Status   <= wd;
                    `Cause_ID:     Cause    <= wd;
                    `EPC_ID:       EPC      <= wd;
                endcase
            end
            else if(exctype != `noexe)begin
                if(exctype == `Eret)Status[1] <= 0;//exception is solved
                else begin
                    if(Status[1] == 0)begin
                        if(exctype==`Int)begin
                            if(c_ds)begin
                            EPC <= cur_pc;
                            Cause[31] <= 1;
                            end
                            else begin
                                EPC <= cur_pc+4;
                                Cause[31] <= 0;
                            end
                        end
                        else begin
                            if(c_ds)begin
                            EPC <= cur_pc-4;
                            Cause[31] <= 1;
                            end
                            else begin
                                EPC <= cur_pc;
                                Cause[31] <= 0;
                            end
                        end
                        
                        Status[1] <= 1;
                        Cause[6:2] <= exctype;
                        if(exctype == `ADEL||exctype == `ADES) BadVAddr <= badvaddr_i;
                    end
                end
            end
        end
    end

    //output data
    always @(*) begin
        if(cpu_rst_n == `RST_ENABLE)  rd <= `ZERO_WORD;
        else begin
            case (ra)
                    `BadVAddr_ID:  rd       <= BadVAddr;
                    `Status_ID:    rd       <= Status;
                    `Cause_ID:     rd       <= Cause;
                    `EPC_ID:       rd       <= EPC;
                    default:       rd       <= `ZERO_WORD; 
            endcase
        end
    end
    assign o_Cause = Cause;
    assign o_Status = Status;
endmodule
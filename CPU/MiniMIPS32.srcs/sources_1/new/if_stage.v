`include "defines.v"

module if_stage (
    input wire cpu_clk_50M,
    input wire cpu_rst_n,

    output reg                  ice,
    output reg [`INST_ADDR_BUS] pc,
    output     [`INST_ADDR_BUS] iaddr,
    output     [`INST_ADDR_BUS] debug_wb_pc,  // 供调试使用的PC值，上板测试时务必删除该信号

    // 转移相关 绿线
    input wire  [1:0]               jtsel,
    input wire [`INST_ADDR_BUS]     jump_addr_1,
    input wire [`INST_ADDR_BUS]     jump_addr_2,
    input wire [`INST_ADDR_BUS]     jump_addr_3,
    
    //暂停机制相关 蓝线
    input wire [3 : 0]              stall,
    
    //cp0相关
    input  wire                     flush,
    input  wire  [`INST_ADDR_BUS]   excaddr
);

  wire [`INST_ADDR_BUS] pc_next;
//  assign pc_next = pc + 4;  // 计算下一条指令的地址
    assign pc_next = (jtsel == 2'b01) ? jump_addr_1 : (jtsel == 2'b10) ? jump_addr_2 :
    (jtsel == 2'b11) ? jump_addr_3 : pc + 4;
    
    always @(*) begin
		if (cpu_rst_n == `RST_ENABLE) begin
			ice = `CHIP_DISABLE;		      // 复位的时候指令存储器禁用  
		end 
        else if(flush == 1)begin
            ice = `CHIP_DISABLE;
        end
        else begin
			ice = (stall[3] == `STOP_ENABLE) ? `CHIP_DISABLE : `CHIP_ENABLE; 		      // 复位结束后，指令存储器使能
		end
	end

    always @(posedge cpu_clk_50M) begin
        if (ice == `CHIP_DISABLE)
            if(flush == 1) pc <=  excaddr;
            else if(stall[3] == `STOP_ENABLE) pc <= pc;
            else pc <= `PC_INIT;                  // 指令存储器禁用的时候，PC保持初始值（MiniMIPS32中设置为0x00000000）
        else begin
            pc <= (stall[3] == `STOP_ENABLE) ? pc : pc_next;                    // 指令存储器使能后，PC值每时钟周期加4 	
        end
    end

  // TODO：指令存储器的访问地址没有根据其所处范围进行进行固定地址映射，需要修改!!! DONE
  assign iaddr = (ice == `CHIP_DISABLE) ? `PC_INIT : pc;    // 获得访问指令存储器的地址

  assign debug_wb_pc = pc;  // 上板测试时务必删除该语句

endmodule

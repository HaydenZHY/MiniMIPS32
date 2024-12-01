`timescale 1ns / 1ps

/*------------------- 全局参数 -------------------*/
`define RST_ENABLE 1'b0                // 复位信号有效  RST_ENABLE
`define RST_DISABLE 1'b1                // 复位信号无效
`define ZERO_WORD 32'h00000000        // 32位的数值0
`define ZERO_DWORD 64'b0               // 64位的数值0
`define WRITE_ENABLE 1'b1                // 使能写
`define WRITE_DISABLE 1'b0                // 禁止写
`define READ_ENABLE 1'b1                // 使能读
`define READ_DISABLE 1'b0                // 禁止读
`define MREG_ENABLE 1'b1                // 存储器到寄存器使能信号有效
`define MREG_DISABLE 1'b0                // 存储器到寄存器使能信号无效
`define RT_ENABLE 1'b1                // 目的寄存器选择信号有效
`define RT_DISABLE 1'b0                // 目的寄存器选择信号无效
`define SHIFT_ENABLE 1'b1                // 移位使能信号有效
`define SHIFT_DISABLE 1'b0                // 移位使能信号无效
`define WHILO_ENABLE 1'b1                //使能写hilo
`define WHILO_DISABLE 1'b0                //禁止写hilo
`define STOP_ENABLE 1'b1                // 暂停使能信号有效
`define STOP_DISABLE 1'b0                // 暂停使能信号无效
`define ALUOP_BUS 7 : 0               // 译码阶段的输出aluop_o的宽度
`define SHIFT_ENABLE 1'b1                // 移位指令使能 
`define ALUTYPE_BUS 2 : 0               // 译码阶段的输出alutype_o的宽度  
`define TRUE_V 1'b1                // 逻辑"真"  
`define FALSE_V 1'b0                // 逻辑"假"  
`define CHIP_ENABLE 1'b1                // 芯片使能  
`define CHIP_DISABLE 1'b0                // 芯片禁止  
`define WORD_BUS 31: 0               // 32位宽
`define DOUBLE_REG_BUS 63: 0               // 两倍的通用寄存器的数据线宽度
`define RT_ENABLE 1'b1                // rt选择使能
`define SIGNED_EXT 1'b1                // 符号扩展使能
`define IMM_ENABLE 1'b1                // 立即数选择使能
`define UPPER_ENABLE 1'b1                // 立即数移位使能
`define MREG_ENABLE 1'b1                // 写回阶段存储器结果选择信号
`define BSEL_BUS 3 : 0               // 数据存储器字节选择信号宽度
`define PC_INIT 32'hBFC00000        // PC初始值

/*------------------- 指令字参数 -------------------*/
`define INST_ADDR_BUS 31: 0               // 指令的地址宽度
`define INST_BUS 31: 0               // 指令的数据宽度

// 操作类型alutype
`define NOP 3'b000
`define ARITH 3'b001
`define LOGIC 3'b010
`define MOVE 3'b011
`define SHIFT 3'b100
`define STORE 3'b101
`define JUMP 3'b110
`define PRIVILEGE 3'b111
// 内部操作码aluop
//算数运算指令
`define MINIMIPS32_ADD 8'h10
`define MINIMIPS32_ADDI 8'h11
`define MINIMIPS32_ADDU 8'h12
`define MINIMIPS32_ADDIU 8'h13
`define MINIMIPS32_SUB 8'h14
`define MINIMIPS32_SUBU 8'h15
`define MINIMIPS32_SLT 8'h16
`define MINIMIPS32_SLTI 8'h17
`define MINIMIPS32_SLTU 8'h18
`define MINIMIPS32_SLTIU 8'h19
`define MINIMIPS32_MULT 8'h1A
`define MINIMIPS32_MULTU 8'h1B
//逻辑运算指令
`define MINIMIPS32_AND 8'h1C
`define MINIMIPS32_ANDI 8'h1D
`define MINIMIPS32_LUI 8'h1E
`define MINIMIPS32_NOR 8'h1F
`define MINIMIPS32_OR 8'h20
`define MINIMIPS32_ORI 8'h21
`define MINIMIPS32_XOR 8'h22
`define MINIMIPS32_XORI 8'h23

//移位指令
`define MINIMIPS32_SLL 8'h24
`define MINIMIPS32_SLLV 8'h25
`define MINIMIPS32_SRA 8'h26
`define MINIMIPS32_SRAV 8'h27
`define MINIMIPS32_SRL 8'h28
`define MINIMIPS32_SRLV 8'h29
//数据移动指令
`define MINIMIPS32_MFHI 8'h2A
`define MINIMIPS32_MFLO 8'h2B
`define MINIMIPS32_MTHI 8'h2C
`define MINIMIPS32_MTLO 8'h2D

//访存指令
`define MINIMIPS32_LB 8'h2E
`define MINIMIPS32_LBU 8'h2F
`define MINIMIPS32_LH 8'h30
`define MINIMIPS32_LHU 8'h31
`define MINIMIPS32_LW 8'h32
`define MINIMIPS32_SB 8'h33
`define MINIMIPS32_SH 8'h34
`define MINIMIPS32_SW 8'h35
//转移指令
`define MINIMIPS32_BEQ 8'h36
`define MINIMIPS32_BNE 8'h37
`define MINIMIPS32_BGEZ 8'h38
`define MINIMIPS32_BGTZ 8'h39
`define MINIMIPS32_BLEZ 8'h3A
`define MINIMIPS32_BLTZ 8'h3B
`define MINIMIPS32_BLTZAL 8'h3C
`define MINIMIPS32_BGEZAL 8'h3D
`define MINIMIPS32_J 8'h3E
`define MINIMIPS32_JAL 8'h3F
`define MINIMIPS32_JR 8'h40
`define MINIMIPS32_JALR 8'h41
//除法指令
`define MINIMIPS32_DIV 8'h42
`define MINIMIPS32_DIVU 8'h43
//CP0指令
`define MINIMIPS32_MFC0 8'h44
`define MINIMIPS32_MTC0 8'h45
//异常相关指令
`define MINIMIPS32_SYSCALL 8'h46
`define MINIMIPS32_BREAK 8'h47
`define MINIMIPS32_ERET 8'h48

`define STOP 1'b1
`define START 1'b0
`define DIV_NOT_READY 1'b0
`define DIV_READY 1'b1
`define DIV_START 1'b1
`define DIV_STOP 1'b0
`define DIV_FREE 2'b00
`define DIV_ON 2'b01
`define DIV_FINISHED 2'b10
`define DIV_ZERO 2'b11
/*------------------- 通用寄存器堆参数 -------------------*/
`define REG_BUS 31: 0               // 寄存器数据宽度
`define REG_ADDR_BUS 4 : 0               // 寄存器的地址宽度
`define REG_NUM 32                  // 寄存器数量32个
`define REG_NOP 5'b00000            // 零号寄存器

//.....exception argument
// need for exetype
`define Int 0               
`define ADEL 4              
`define ADES 5                  
`define Sys 8           
`define BP 9                
`define RI 10 
`define Ov 12
`define noexe 1
`define Eret 26  //a way to realize eret instruction
`define EXCTYPE_BUS 4:0  
`define EXEADDR 32'hbfc00380  
//cp0 regfile
`define BadVAddr_ID 8               
`define Status_ID 12              
`define Cause_ID 13                  
`define EPC_ID 14   
`define BadVAddr_init 32'h00000000
`define Status_init 32'h00000000              
`define Cause_init 32'h00000004                  
`define EPC_init 32'h00000000 

`define op_len 5:0
`define funct_len 5:0
`define rs_len 4:0
`define rt_len 4:0
`define rd_len 4:0
`define sa_len 4:0
`define imm_len 15:0
`define instr_index_len 25:0
`define INT_LEN 5:0

`timescale 1ns / 1ps

/*------------------- ???? -------------------*/
`define RST_ENABLE      1'b0                // ??????  RST_ENABLE
`define RST_DISABLE     1'b1                // ??????
`define ZERO_WORD       32'h00000000        // 32????0
`define ZERO_DWORD      64'b0               // 64????0
`define WRITE_ENABLE    1'b1                // ???
`define WRITE_DISABLE   1'b0                // ???
`define READ_ENABLE     1'b1                // ???
`define READ_DISABLE    1'b0                // ???
`define ALUOP_BUS       7 : 0               // ???????aluop_o???
`define SHIFT_ENABLE    1'b1                // ?????? 
`define ALUTYPE_BUS     2 : 0               // ???????alutype_o???  
`define TRUE_V          1'b1                // ??"?"  
`define FALSE_V         1'b0                // ??"?"  
`define CHIP_ENABLE     1'b1                // ????  
`define CHIP_DISABLE    1'b0                // ????  
`define WORD_BUS        31: 0               // 32??
`define DOUBLE_REG_BUS  63: 0               // ??????????????
`define RT_ENABLE       1'b1                // rt????
`define SIGNED_EXT      1'b1                // ??????
`define IMM_ENABLE      1'b1                // ???????
`define UPPER_ENABLE    1'b1                // ???????
`define MREG_ENABLE     1'b1                // ?????????????
`define BSEL_BUS        3 : 0               // ?????????????
`define PC_INIT         32'hbfc00000        // PC???
`define WHILO_ENABLE    1'b1                //?hilo??
`define STOP_ENABLE     1'b1                // ????????
`define STOP_DISABLE    1'b0                // ????????
`define MREG_ENABLE     1'b1                // ?????????????
`define MREG_DISABLE    1'b0                // ?????????????
`define WHILO_ENABLE    1'b1                //???hilo
`define WHILO_DISABLE   1'b0                //???hilo

/*------------------- ????? -------------------*/
`define INST_ADDR_BUS   31: 0               // ???????
`define INST_BUS        31: 0               // ???????

// ????alutype
`define NOP             3'b000
`define ARITH           3'b001
`define LOGIC           3'b010
`define MOVE            3'b011
`define SHIFT           3'b100
`define STORE           3'b101
`define JUMP            3'b110

// ?????aluop
// TODO:more inst
`define MINIMIPS32_LUI             8'h05
`define MINIMIPS32_MFHI            8'h0C
`define MINIMIPS32_MFLO            8'h0D
`define MINIMIPS32_MTHI            8'h0E
`define MINIMIPS32_MTLO            8'h0F
`define MINIMIPS32_SLL             8'h11
`define MINIMIPS32_SLLV            8'h12
`define MINIMIPS32_MULT            8'h14
`define MINIMIPS32_MULTU           8'h15
`define MINIMIPS32_SUB             8'h16
`define MINIMIPS32_ADDU            8'h17
`define MINIMIPS32_ADD             8'h18
`define MINIMIPS32_ADDIU           8'h19
`define MINIMIPS32_ADDI            8'h1A
`define MINIMIPS32_SUBU            8'h1B
`define MINIMIPS32_AND             8'h1C
`define MINIMIPS32_ORI             8'h1D
`define MINIMIPS32_ANDI            8'h1E
`define MINIMIPS32_NOR             8'h1F
`define MINIMIPS32_OR              8'h20
`define MINIMIPS32_XOR             8'h21
`define MINIMIPS32_XORI            8'h22
`define MINIMIPS32_SLT             8'h26
`define MINIMIPS32_SLTIU           8'h27
`define MINIMIPS32_SLTI            8'h28
`define MINIMIPS32_SLTU            8'h29
`define MINIMIPS32_SRA             8'h2A
`define MINIMIPS32_SRAV            8'h2B
`define MINIMIPS32_SRL             8'h2C
`define MINIMIPS32_SRLV            8'h2D
`define MINIMIPS32_J               8'h30
`define MINIMIPS32_JR              8'h31
`define MINIMIPS32_JAL             8'h32
`define MINIMIPS32_BEQ             8'h34
`define MINIMIPS32_BNE             8'h38
`define MINIMIPS32_BGEZ            8'h40
`define MINIMIPS32_BGTZ            8'h41
`define MINIMIPS32_BLEZ            8'h42
`define MINIMIPS32_BLTZ            8'h44
`define MINIMIPS32_BLTZAL          8'h48
`define MINIMIPS32_BGEZAL          8'h49
`define MINIMIPS32_JALR            8'h4A
`define MINIMIPS32_DIV             8'h50
`define MINIMIPS32_DIVU            8'h51
`define MINIMIPS32_SYSCALL         8'h86
`define MINIMIPS32_ERET            8'h87
`define MINIMIPS32_BREAK           8'h88
`define MINIMIPS32_MFC0            8'h8C
`define MINIMIPS32_MTC0            8'h8D
`define MINIMIPS32_LB              8'h90
`define MINIMIPS32_LBU             8'h91
`define MINIMIPS32_LW              8'h92
`define MINIMIPS32_LH              8'h94
`define MINIMIPS32_LHU             8'h96
`define MINIMIPS32_SB              8'h98
`define MINIMIPS32_SH              8'h99
`define MINIMIPS32_SW              8'h9A?

`define STOP                       1'b1
`define START                      1'b0
`define DIV_NOT_READY              1'b0
`define DIV_READY                  1'b1
`define DIV_START                  1'b1
`define DIV_STOP                   1'b0
`define DIV_FREE                   2'b00
`define DIV_ON                     2'b01
`define DIV_FINISHED               2'b10
`define DIV_ZERO                   2'b11

/*------------------- ???????? -------------------*/
`define REG_BUS         31: 0               // ???????
`define REG_ADDR_BUS    4 : 0               // ????????
`define REG_NUM         32                  // ?????32?
`define REG_NOP         5'b00000            // ?????

//.....exception argument
// need for exetype
`define Int             0               
`define ADEL            4              
`define ADES            5                  
`define Sys             8           
`define BP              9                
`define RI              10 
`define Ov              12
`define noexe           1
`define Eret            26  //a way to realize eret instruction
`define EXCTYPE_BUS     4:0  
`define EXEADDR         32'hbfc00380  
//cp0 regfile
`define BadVAddr_ID     8               
`define Status_ID       12              
`define Cause_ID        13                  
`define EPC_ID          14   
`define BadVAddr_init   32'h00000000
`define Status_init     32'h00000000              
`define Cause_init      32'h00000004                  
`define EPC_init        32'h00000000 


//.....exception argument
// need for exetype
`define Int             0               
`define ADEL            4              
`define ADES            5                  
`define Sys             8           
`define BP              9                
`define RI              10 
`define Ov              12
`define noexe           1
`define Eret            26  //a way to realize eret instruction
`define EXCTYPE_BUS     4:0  
`define EXEADDR         32'hbfc00380  
//cp0 regfile
`define BadVAddr_ID     8               
`define Status_ID       12              
`define Cause_ID        13                  
`define EPC_ID          14   
`define BadVAddr_init   32'h00000000
`define Status_init     32'h00000000              
`define Cause_init      32'h00000004                  
`define EPC_init        32'h00000000 
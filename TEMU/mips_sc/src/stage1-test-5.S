#include "trap.h"
.data
    bdata: .byte 0xF1,0xF2,0xF3,0xF4,0xF5,0xF6,0xF7,0xF8
.set noat
.globl main
.text
.set noreorder
main:
   lui $t8, 0x1010              
   nop
   nop
   nop
   ori $at, $t8, 0x1011         #$at = 0x10101011
   lui $t2, 0xF000
   nop
   nop
   nop
   ori $v0, $t2, 0x0005          
   nop
   nop
   nop          
   add $t0, $at, $v0            # 正数+负数
   addi $t1, $at,0x1111         # 正数+正数
   addu $t0,$at,$v0
   addiu $t1,$at,0x1111
   sub $t0,$at,$v0              # 正数-负数
   subu $t1,$at,$v0             # 正数-负数
   lui $t8,0x0000
   nop
   nop
   nop
   ori $at,$t8,0x0001
   lui $t2,0x0000
   nop
   nop
   nop
   ori $v0,$t2,0x0000
   nop
   nop
   nop
   slt $t0,$at,$v0              # 正数>正数
   slti $t0,$at,0x0000          # 正数>正数
   sltu $t0,$at,$v0             # 正数>0
   sltiu $t0,$at,0x0000         # 正数>0
   lui $t8,0xFFFF
   nop
   nop
   nop
   ori $at,$t8,0xFFFF
   lui $t2,0x7FFF
   nop
   nop
   nop
   ori $v0,$t2,0xFFFF
   nop
   nop
   nop
   mult $at,$v0                 # -1*最大有符号正数
   multu $at,$v0                # 最大无符号正数*大无符号正数
   li $at,0xFFFFFFFF
   li $v0,0x00000000
   lui $t8,0xFFFF
   nop
   nop
   nop
   ori $at,$t8,0xFFFF
   lui $t2,0x0000
   nop
   nop
   nop
   ori $v0,$t2,0x0000
   nop
   nop
   nop
   and $t0,$at,$v0              # 全1与全0
   andi $t0,$at,0x0000          # 全1与全0
   lui $t0,0xFFFF
   nor $t0,$at,$v0
   or $t1,$at,$v0
   ori $t0,$at,0x0000           # 全1或全0
   xor $t0,$at,$v0
   xori $t1,$at,0x0000
   #移位位数为0，31时
   lui $t8, 0xFF12             
   nop
   nop
   nop
   ori $at, $t8, 0x3456         
   lui $t2, 0x0000
   nop
   nop
   nop
   ori $v0, $t2, 0x0000          
   nop
   nop
   nop
   sllv $t0,$at,$v0              
   sll $t0, $at, 31             
   sra $t0, $at, 31    
   srav $t0,$at,$v0              
   srl $t0, $at, 31          
   srlv $t0, $at, $v0 
   lui $t8, 0xF234             
   nop
   nop
   nop
   ori $at, $t8, 0x5678   
   #向存储器中存入负数后再读取
   addiu $s0, $zero,0
   nop
   nop
   nop
   addiu $s0, $s0,bdata
   nop
   nop
   nop
   addu $s0,$s0,8
   nop
   nop
   nop
   sb $at,0($s0)
   sh $at,2($s0)
   sw $at,4($s0)
   lb $t0,0($s0)
   lbu $t0,0($s0)
   lh $t0,2($s0)
   lhu $t0,2($s0)
   lw $t0,4($s0)
   nop
   nop
   nop
   HIT_GOOD_TRAP
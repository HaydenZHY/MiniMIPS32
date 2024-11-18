#include "trap.h"
.data
    bdata: .byte 0xF1,0xF2,0xF3,0xF4,0xF5,0xF6,0xF7,0xF8
.set noat
.globl main
.text
.set noreorder
main:
   lui $t8, 0xF010
   nop
   nop
   nop
   ori $at, $t8, 0x1011         #$at = 0xF0101011
   lui $t2, 0x0000
   nop
   nop
   nop
   ori $v0, $t2, 0x0005         #$v0 = 0x00000005
   nop
   nop
   nop          
   add $t0, $at, $v0            # 负数+正数
   addi $t1, $at,0xFFFF         # 负数+负数
   addu $t0,$at,$v0
   addiu $t1,$at,0xFFFF         
   sub $t0,$at,$v0              # 负数-正数
   subu $t1,$at,$v0             # 负数-正数
   lui $t8,0xFFFF
   nop
   nop
   nop
   ori $at,$t8,0xFFFF
   lui $t2,0x0000
   nop
   nop
   nop
   ori $v0,$t2,0x0001
   nop
   nop
   nop
   slt $t0,$at,$v0              # 负数<正数
   slti $t0,$at,0x0001          # 负数<正数
   sltu $t0,$at,$v0             # 大正数<小正数
   sltiu $t0,$at,0x0001         # 大正数<小正数
   lui $t8,0xFFFF
   nop
   nop
   nop
   ori $at,$t8,0xFFFF
   lui $t2,0xFFFF
   nop
   nop
   nop
   ori $v0,$t2,0xFFFF
   nop
   nop
   nop
   mult $at,$v0                 # -1*-1
   multu $at,$v0                # 最大无符号正数*最大无符号正数
   lui $t8,0x0000
   nop
   nop
   nop
   ori $at,$t8,0x0000
   lui $t8,0x0000
   nop
   nop
   nop
   ori $v0,$t8,0x0000
   nop
   nop
   nop
   and $t0,$at,$v0              # 全0与全0
   andi $t0,$at,0x0000          # 全0与全0
   lui $t0,0xFFFF
   nor $t0,$at,$v0
   or $t1,$at,$v0
   ori $t0,$at,0x0000           # 全0或全0
   xor $t0,$at,$v0
   xori $t1,$at,0x0000
   #最高位为0的移位位数大于32位时
   lui $t8, 0x0F12             
   nop
   nop
   nop
   ori $at, $t8, 0x3456         
   lui $t2, 0x0000
   nop
   nop
   nop
   ori $v0, $t2, 0x0037          
   nop
   nop
   nop
   sllv $t0,$at,$v0              
   sll $t0, $at, 44              
   sra $t0, $at, 44    
   srav $t0,$at,$v0              
   srl $t0, $at, 44          
   srlv $t0, $at, $v0 
   #offset为正数，取出的数最高位为1时
   addiu $s0, $zero,0
   nop
   nop
   nop
   addiu $s0, $s0,bdata
   nop
   nop
   nop
   lb $t0,0($s0)
   lbu $t0,0($s0)
   lh $t0,2($s0)
   lhu $t0,2($s0)
   lw $t0,4($s0)
   sb $at,0($s0)
   lb $t0,0($s0)
   sh $at,2($s0)
   lh $t0,2($s0)
   sw $at,4($s0)
   lw $t0,4($s0)
   nop
   nop
   nop
   HIT_GOOD_TRAP
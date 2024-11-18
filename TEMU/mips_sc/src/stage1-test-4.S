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
   lui $t2, 0xF000
   nop
   nop
   nop
   ori $v0, $t2, 0x0005         #$v0 = 0xF0000005
   nop
   nop
   nop
   add $t0, $at, $v0            # 负数+负数
   addi $t1, $at,0x1111         # 负数+正数
   addu $t0,$at,$v0
   addiu $t1,$at,0x1111
   sub $t0,$at,$v0              # 负数-负数
   subu $t1,$at,$v0             # 负数-负数
   lui $t8,0x0000
   nop
   nop
   nop
   ori $at,$t8,0x0000           #$at = 0x00000000
   lui $t2,0x0000
   nop
   nop
   nop
   ori $v0,$t2,0x0001           #$v0 = 0x00000001
   nop
   nop
   nop
   slt $t0,$at,$v0              # 正数<正数
   slti $t0,$at,0x0001          # 正数<正数
   sltu $t0,$at,$v0             # 0<大正数
   sltiu $t0,$at,0x0001         # 0<大正数
   lui $t8,0xFFFF
   nop
   nop
   nop
   ori $at,$t8,0xFFFF           #$at = 0xFFFFFFFF
   lui $t2,0x7FFF
   nop
   nop
   nop
   ori $v0,$t2,0xFFFF           #$v0 = 0x7FFFFFFF
   nop
   nop
   nop
   mult $at,$v0                 # -1*最大有符号正数
   multu $at,$v0                # 最大无符号正数*大无符号正数
   lui $t8,0xAAAA
   nop
   nop
   nop
   ori $at,$t8,0xAAAA           #$at = 0xAAAAAAAA
   lui $t8,0x5555
   nop
   nop
   nop
   ori $v0,$t8,0x5555           #$v0 = 0x55555555
   nop
   nop
   nop
   and $t0,$at,$v0              # 错位与
   andi $t0,$at,0x5555          # 错位与
   lui $t0,0xFFFF
   nor $t0,$at,$v0
   or $t1,$at,$v0
   ori $t0,$at,0x5555           # 错位或
   xor $t0,$at,$v0
   xori $t1,$at,0x5555
   #最高位为1的移位位数大于32位时
   lui $t8, 0xFF12             
   nop
   nop
   nop
   ori $at, $t8, 0x3456         #$at = 0xFF123456  
   lui $t2, 0x0000
   nop
   nop
   nop
   ori $v0, $t2, 0x0037         #$v0 = 0x00000037  
   nop
   nop
   nop
   sllv $t0,$at,$v0              
   sll $t0, $at, 44              
   sra $t0, $at, 44    
   srav $t0,$at,$v0              
   srl $t0, $at, 44          
   srlv $t0, $at, $v0 
   lui $t8, 0xFFFF             
   nop
   nop
   nop
   ori $at, $t8, 0xFFFF          
   #offset为负数，取出的数最高位为1时
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
   lb $t0,-1($s0)
   lbu $t0,-1($s0)
   lh $t0,-2($s0)
   lhu $t0,-2($s0)
   lw $t0,-8($s0)
   sb $at,-1($s0)
   sh $at,-4($s0)
   sw $at,-8($s0)
   lw $at,-8($s0)
   lw $at,-4($s0)
   nop
   nop
   nop
   HIT_GOOD_TRAP
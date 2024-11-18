#include "trap.h"
.data
    bdata: .byte 0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88
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
   lui $t2, 0x0000
   nop
   nop
   nop
   ori $v0, $t2, 0x0005         #$v0 = 0x00000005
   nop
   nop
   nop
   add $t0, $at, $v0           # 正数+正数
   addi $t1, $at,0xFFFF        # 正数+负数
   addu $t0,$at,$v0
   addiu $t1,$at,0xFFFF
   sub $t0,$at,$v0             # 正数-正数
   subu $t1,$at,$v0            # 正数-正数
   lui $t8,0x0000
   nop
   nop
   nop
   ori $at,$t8,0x0001          # $at = 0x00000001
   lui $t2,0xFFFF
   nop
   nop
   nop
   ori $v0,$t2,0xFFFF          # $v0 = 0xFFFFFFFF
   nop
   nop
   nop
   slt $t0,$at,$v0              # 正数<负数
   slti $t0,$at,0xFFFF          # 正数<负数
   sltu $t0,$at,$v0             # 1<大正数
   sltiu $t0,$at,0xFFFF         # 1<大正数
   lui $t8,0x7FFF
   nop
   nop
   nop
   ori $at,$t8,0xFFFF           # $at = 0x7FFFFFFF
   lui $t2,0x7FFF               
   nop
   nop
   nop
   ori $v0,$t2,0xFFFF           # $v0 = 0x7FFFFFFF
   nop
   nop
   nop
   mult $at,$v0                 # 最大32正数*最大32正数
   multu $at,$v0                # 最大32正数*最大32正数
   lui $t8,0xFFFF
   nop
   nop
   nop
   ori $at,$t8,0xFFFF           # $at = 0xFFFFFFFF
   lui $t8,0x0000
   nop
   nop
   nop
   ori $v0,$t8,0x0000           # $v0 = 0x00000000
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
   #最高位为1，移位位数小于32位
   lui $t8, 0xFF12              
   nop
   nop
   nop
   ori $at, $t8, 0x3456         # $at = 0xFF123456         
   lui $t2, 0x0000
   nop
   nop
   nop
   ori $v0, $t2, 0x0007         # $v0 = 0x00000007         
   nop
   nop
   nop
   sllv $t0,$at,$v0             
   sll $t0, $at, 15              
   sra $t0, $at, 15    
   srav $t0,$at,$v0
   srl $t0, $at, 15
   srlv $t0, $at, $v0 
         
   #offset为负数，取出的数最高位为0时
   addiu $s0,$zero,0
   nop
   nop
   nop
   addiu $s0,$s0,bdata
   nop
   nop
   nop
   addu $s0,$s0,4
   nop
   nop
   nop
   lb $t0,-1($s0)
   lbu $t0,-1($s0)
   lh $t0,-2($s0)
   lhu $t0,-2($s0)
   lw $t0,-4($s0)
   sb $at,-1($s0)
   lb $t0,-1($s0)
   sh $at,-2($s0)
   lh $t0,-2($s0)
   sw $at,-4($s0)
   lw $t0,-4($s0)
   nop
   nop
   nop
   HIT_GOOD_TRAP
   
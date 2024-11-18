#include "trap.h"
   .set noat
   .globl main
   .text
   .set noreorder
main:
   lui $t8, 0x1010              #$at = 0x10100000
   nop
   nop
   nop
   ori $at, $t8, 0x1011         #$at = 0x10101011
   lui $t2, 0x0000              #$t2 = 0x00000000
   nop
   nop
   nop
   ori $v0, $t2, 0x0005         #$v0 = 0x00000005
   nop
   nop
   nop
   add $t0, $at, $v0            # 正数+正数 $t0 = 0x10101016
   addi $t1, $at,0x1111         # 正数+正数 $t1 = 0x10102122
   addu $t0,$at,$v0             # $t0 = 0x10101016
   addiu $t1,$at,0x1111         # $t1 = 0x10102122
   sub $t0,$at,$v0              # 正数-正数 $t0 = 0x1010100c
   subu $t1,$at,$v0             # 正数-正数 $10 = 0x1010100c
   lui $t8,0xF000
   nop
   nop
   nop
   ori $at,$t8,0x0000           # $at = 0xF0000000
   lui $t2,0xFFFF
   nop
   nop
   nop
   ori $v0,$t2,0xFFFF           # $v0 = 0xFFFFFFFF
   nop
   nop
   nop
   slt $t0,$at,$v0              # 负数<负数 $t0 = 0x00000001
   slti $t0,$at,0xFFFF          # 负数<负数 $t0 = 0x00000001
   sltu $t0,$at,$v0             # 小正数<大正数 $t0 = 0x00000001
   sltiu $t0,$at,0xFFFF         # 小正数<大正数 $t0 = 0x00000001
   lui $t8,0x0000
   nop
   nop
   nop
   ori $at,$t8,0x0001           # $at = 0x00000001
   lui $t2,0xFFFF
   nop
   nop
   nop
   ori $v0,$t2,0xFFFF           # $v0 = 0xFFFFFFFF
   nop
   nop
   nop
   mult $at,$v0                 # 正数*负数 
   multu $at,$v0                # 正数*正数
   lui $t8,0xFFFF
   nop
   nop
   nop
   ori $at,$t8,0xFFFF           # $at = 0xFFFFFFFF
   lui $t2,0xFFFF
   nop
   nop
   nop
   ori $v0,$t2,0xFFFF           # $v0 = 0xFFFFFFFF
   nop
   nop
   nop
   and $t0,$at,$v0              # 全1与全1 $t0 = 0xFFFFFFFF
   andi $t0,$at,0xFFFF          # 全1与半全1 $t0 = 0x0000FFFF
   lui $t0,0x1234               # $t0 = 0x12340000
   nor $t0,$at,$v0              # $t0 = 0x00000000
   or $t1,$at,$v0               # $t1 = 0xFFFFFFFF
   ori $t0,$at,0xFFFF           # 全1或半全1 $t0 = 0xFFFFFFFF
   xor $t0,$at,$v0              # $t0 = 0x00000000
   xori $t1,$at,0xFFFF          # $t1 = 0xFFFF0000
   #最高位为0，移位位数小于32位
   sllv $t0,$at,$v0              
   sll $t0, $at, 3              
   sra $t0, $at, 3    
   srav $t0,$at,$v0              
   srl $t0, $at, 3          
   srlv $t0, $at, $v0 
   mthi $at
   mtlo $at
   nop
   mfhi $t3
   mflo $t1
   #offset为正数，取出的数最高位为0时
   lui $t8, 0x1234
   nop
   nop
   nop
   ori $at, $t8, 0x5678          # $at = 0x12345678
   lui $t2, 0x0000
   nop
   nop
   nop
   ori $v0, $t2, 0x0004          # $v0 = 0x00000004
   nop
   nop
   nop
   sb $at,0x0001($v0)
   sh $at,0x0010($v0)
   sw $at,0x0020($v0)
   lb $t0,0x0001($v0)
   lbu $t0,0x0001($v0)
   lh $t0,0x0010($v0)
   lhu $t0,0x0010($v0)
   lw $t0,0x0020($v0)
   nop
   nop
   nop
   HIT_GOOD_TRAP
   #异常处理增加后要加的测试指令：lb访问未知内存，lw访问地址未对齐的情况

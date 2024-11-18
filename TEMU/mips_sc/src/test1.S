#include "trap.h"
   .set noat
   .globl main
   .text
   .set noreorder
main:
   li $at, 0x10101011           #$at = 0x10101011
   li $v0, 0x01011111           #$v0 = 0x01011111
   li $v1, 0x6FEFEFEF           #$v1 = 0x6FEFEFEF 
   add $t0, $at, $v0            #$t0 = 0x11112122   测试 add 正常
   # add $t1, $at, $v1          #   测试 add 例外
   
   li $at, 0x10101011           #$at = 0x10101011
   addi $t1, $at, 0x1111        #$t1 = 0x10102122   测试 addi 正常

   li $at, 0x10101011           #$at = 0x10101011
   addu $t2, $at, $v0           #$t2 = 0x11112122   测试 addu 正常

   li $at, 0x10101011           #$at = 0x10101011
   addiu $t3, $at, 0x1111       #$t3 = 0x10102122   测试 addiu 正常
   
   li $at, 0x10101011           #$at = 0x10101011
   sub $t4, $at, $v0            #$t4 = 0x0f0eff00   测试 sub 正常

   li $at, 0x10101011           #$at = 0x10101011
   subu $t5, $at, $v0           #$t5 = 0x0f0eff00   测试 subu 正常

   slt $t6, $at, $v0            #$t6 = 0x00000000   测试 slt 正常

   slti $t7, $at, 0x1111        #$t7 = 0x00000000   测试 slti 正常

   sltu $t8, $at, $v0           #$t8 = 0x00000000   测试 sltu 正常

   sltiu $t9, $at, 0x1111       #$t9 = 0x00000000   测试 sltiu 正常

   div $zero, $t1, $t1                 #   测试 div

   divu $zero, $t1, $t1                #   测试 divu

   mult $v0, $v0                #   测试 mult
   
   HIT_GOOD_TRAP		#stop temu

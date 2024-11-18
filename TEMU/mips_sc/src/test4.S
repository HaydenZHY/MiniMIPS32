#include "trap.h"
   .set noat
   .globl main
   .text
main:
   li $t1, 0xbfc00000
   beq $at, $t1, lable2
   li $v0, 0x00000000
   li $at, 0xf0e0d0c0
   mthi $at
   mtlo $at
   li $at, 0x00000001 
   mfhi $at
   li $at, 0x00000001
   mflo $at
   sw $at, 0x0000($v0)
   lb $at, 0x0000($v0)
   lbu $at, 0x0000($v0)
   lh $at, 0x0000($v0)
   lhu $at, 0x0000($v0)
   lw $at, 0x0000($v0)
   sb $at, 0x0004($v0)
   sh $at, 0x0008($v0)
   sw $at, 0x000c($v0)
   li $at, 0xbfc00000
   jalr $ra, $at
   HIT_BAD_TRAP		#stop temu

lable1:
   li $at, 0x00000000
   jalr $ra, $at
   HIT_GOOD_TRAP		#stop temu

lable2:
   jr $ra

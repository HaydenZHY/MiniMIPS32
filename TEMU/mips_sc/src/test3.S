#include "trap.h"
   .set noat
   .globl main
   .text
   .set noreorder
main:
    li $t0, 0x0 
    li $t1, 0x1
L1:
    beq $t0, $t1, L3
L2:
    bne $t0, $t1, L4
L3:
    li $t0, 0
    bgez $t0, L2
L4:
    li $t0, 1
    bgtz $t0, L6
L5:
    li $t0, 0
    blez $t0, L7
L6:
    li $t0, -1
    bltz $t0, L8
L7:
    li $t0, 0
    bgezal $t0, L9
L8:
    li $t0, -1
    bltzal $t0, L5

L9:
    #不跳转的情况
    li $t0, 0x12345678
    li $t1, 0x12345677
    beq $t0, $t1, inst_error

    li $t1, 0x12345678
    bne $t0, $t1, inst_error

    li $t0, -1
    bgez $t0, inst_error

    li $t0, 0
    bgtz $t0, inst_error

    li $t0, 1
    blez $t0, inst_error

    li $t0, 0
    bltz $t0, inst_error

    li $t0, -1
    bgezal $t0, inst_error

    li $t0, 0
    bltzal $t0, inst_error
    HIT_GOOD_TRAP

inst_error:
    HIT_BAD_TRAP
good:
    HIT_GOOD_TRAP
#分支语句测试正常
#主要加了测跳转的部分，通过si执行看能否正确跳转到相应位置，执行对应指令，bgezal,bltzal对比qemu中$ra的值
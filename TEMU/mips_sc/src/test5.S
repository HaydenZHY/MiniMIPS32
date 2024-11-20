#include "trap.h"
   .set noat
   .globl main
   .text
main:
    j L4
    nop
L2:
    li $at, 0xA
    li $s0, 0xA
    bne $at, $s0, inst_error

    jal L3
    nop
L3:
    li $at, 0x2
    li $s0, 0x2
    bne $at, $s0, inst_error

    HIT_GOOD_TRAP
    
L4:
    li $at, 0x3
    li $s0, 0x3
    bne $at, $s0, inst_error
    la $v0, L2
    jr $v0


inst_error:
    HIT_BAD_TRAP
    HIT_GOOD_TRAP

#看能否正确跳转(PC值和执行的指令)，测试正常
#对比qemu查ra的值，测试正常
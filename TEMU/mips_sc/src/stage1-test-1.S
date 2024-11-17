#include "trap.h"
    .set noreorder
    .global main 

    .data
    my_data: .word 0x12345678

    .text 
    main:
        li $t0, 10
        li $t1, 20
        nop
        nop
        add $t2, $t0, $t1
        sub $t3, $t1, $t0
        and $t4, $t0, $t1
        or $t5, $t0, $t1
        xor $t6, $t0, $t1
        nor $t7, $t0, $t1
        sll $t8, $t0, 2
        srl $t9, $t1, 2
        sra $s0, $t1, 2
        slt $s1, $t0, $t1
        sltu $s2, $t0, $t1
        addi $s3, $t0, 5
        andi $s4, $t0, 5
        ori $s5, $t0, 5
        xori $s6, $t0, 5
        lui $s7, 0x1234
        beq $t0, $t1, label1
        nop
        nop
        bne $t0, $t1, label2

        HIT_GOOD_TRAP

    label1:
        nop
        lw $t2, my_data
        
        HIT_GOOD_TRAP

    label2:
        nop
        lw $t2, my_data

        HIT_GOOD_TRAP
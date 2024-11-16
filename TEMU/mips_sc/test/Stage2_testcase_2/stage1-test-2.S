#include "trap.h"
    .set noreorder
    .global main 

    .data
result: .word 0        # 用于存储结果

    .text
    .globl main

main:
    li $t0, 5           # 将5加载到$t0中
    li $t1, 5           # 将5加载到$t1中

    beq $t0, $t1, equal # 如果$t0等于$t1，则跳转到equal标签
    nop                  # 这里是延迟槽，填充nop

    # 如果不满足条件，执行这部分代码
    li $t2, 0           # 将0加载到$t2中
    sw $t2, result      # 将0存储到结果中
    j end               # 跳转到结束

equal:
    nop                  # 这里是延迟槽，填充nop
    li $t2, 1           # 将1加载到$t2中
    sw $t2, result      # 将1存储到结果中

end:
    HIT_GOOD_TRAP                  # 程序结束

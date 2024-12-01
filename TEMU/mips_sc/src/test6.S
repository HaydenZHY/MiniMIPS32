#include "trap.h"
   .globl main
   .text
main:
   lui $v0, 0      # 将高16位清零
   ori $v0, $v0, 4 # 将低16位设置为 4
   lui $v1, 0
   ori $v1, $v1, 28 # 将低16位设置为 28

   div $v1, $v0    # $v1 / $v0，结果存储在 $lo 和 $hi
   mflo $t0        # 将商（$lo 的值）加载到 $t0 中
   bne $t0, $zero, error # 如果商不为 0，跳转到 error

   HIT_GOOD_TRAP    # 如果商为 0，触发好陷阱

error:
   HIT_BAD_TRAP     # 如果商不为 0，触发坏陷阱

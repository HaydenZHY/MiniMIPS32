#include "trap.h"
   .set noat
   .globl main
   .text
main:
   #两个都为正数的情况
   li $at, 0x10000011           
   li $v0, 0x01011111           
   multu $at, $v0               
   and $t0 ,$at ,$v0             
   andi $t1 ,$at,0x1234          
   lui $t0, 0x1234               
   nor $t1, $at,$v0              
   or $t0, $at,$v0               
   ori $t1, $t0, 0x1235          
   xor $t0, $at, $v0             
   xori $t0, $at,0x0123          
   li $v0, 0x0000000F            
   sllv $t0,$at,$v0              
   sll $t0, $at, 16              
   srav $t0,$at,$v0              
   sra $t0, $at, 16              
   srlv $t0, $at, $v0   
   srl $t0, $at, 16    
   #测试移位位数大于32的情况
   li $v0, 0x00000030           
   sllv $t0,$at,$v0              
   sll $t0, $at, 44              
   srav $t0,$at,$v0              
   sra $t0, $at, 44              
   srlv $t0, $at, $v0    
   srl $t0, $at, 44    
   #一正一负
   li $at, 0xF0000011           
   li $v0, 0x01011111           
   multu $at, $v0                
   sllv $t0,$at,$v0              
   sll $t0, $at, 44              
   srav $t0,$at,$v0              
   sra $t0, $at, 44              
   srlv $t0, $at, $v0     
   srl $t0, $at, 44    
   #两个都是负数
   li $at, 0xF0000011           
   li $v0, 0xF1011111           
   multu $at, $v0                
   sllv $t0,$at,$v0              
   sll $t0, $at, 44              
   srav $t0,$at,$v0              
   sra $t0, $at, 44              
   srlv $t0, $at, $v0 
   srl $t0, $at, 44    

   j L1    
   
L1:
   jal L2
   HIT_GOOD_TRAP

L2:
   add $t0, $t0, $t0
   jr $ra
   #以上指令测试完毕，均正常

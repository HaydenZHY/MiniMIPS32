
build/stage1-test-1:     file format elf32-tradlittlemips
build/stage1-test-1


Disassembly of section .text:

bfc00000 <main>:
bfc00000:	2408000a 	li	t0,10
bfc00004:	24090014 	li	t1,20
bfc00008:	00000000 	nop
bfc0000c:	01095020 	add	t2,t0,t1
bfc00010:	01285822 	sub	t3,t1,t0
bfc00014:	01096024 	and	t4,t0,t1
bfc00018:	01096825 	or	t5,t0,t1
bfc0001c:	01097026 	xor	t6,t0,t1
bfc00020:	01097827 	nor	t7,t0,t1
bfc00024:	0008c080 	sll	t8,t0,0x2
bfc00028:	0009c882 	srl	t9,t1,0x2
bfc0002c:	00098083 	sra	s0,t1,0x2
bfc00030:	0109882a 	slt	s1,t0,t1
bfc00034:	0109902b 	sltu	s2,t0,t1
bfc00038:	21130005 	addi	s3,t0,5
bfc0003c:	31140005 	andi	s4,t0,0x5
bfc00040:	35150005 	ori	s5,t0,0x5
bfc00044:	39160005 	xori	s6,t0,0x5
bfc00048:	3c171234 	lui	s7,0x1234
bfc0004c:	11090004 	beq	t0,t1,bfc00060 <label1>
bfc00050:	00000000 	nop
bfc00054:	00000000 	nop
bfc00058:	15090005 	bne	t0,t1,bfc00070 <label2>
bfc0005c:	4a000000 	c2	0x0

bfc00060 <label1>:
label1():
bfc00060:	00000000 	nop
bfc00064:	3c0a8000 	lui	t2,0x8000
bfc00068:	8d4a0000 	lw	t2,0(t2)
bfc0006c:	4a000000 	c2	0x0

bfc00070 <label2>:
label2():
bfc00070:	00000000 	nop
bfc00074:	3c0a8000 	lui	t2,0x8000
bfc00078:	8d4a0000 	lw	t2,0(t2)
bfc0007c:	4a000000 	c2	0x0

Disassembly of section .data:

80000000 <my_data>:
my_data():
80000000:	12345678 	beq	s1,s4,800159e4 <my_data+0x159e4>

Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	03ffff00 	0x3ffff00
	...

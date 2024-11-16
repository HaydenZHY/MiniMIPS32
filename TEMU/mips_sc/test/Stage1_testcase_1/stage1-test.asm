
build/stage1-test:     file format elf32-tradlittlemips
build/stage1-test


Disassembly of section .text:

bfc00000 <main>:
bfc00000:	2408000a 	li	t0,10
bfc00004:	24090014 	li	t1,20
bfc00008:	01095020 	add	t2,t0,t1
bfc0000c:	01285822 	sub	t3,t1,t0
bfc00010:	01096024 	and	t4,t0,t1
bfc00014:	01096825 	or	t5,t0,t1
bfc00018:	01097026 	xor	t6,t0,t1
bfc0001c:	01097827 	nor	t7,t0,t1
bfc00020:	0008c080 	sll	t8,t0,0x2
bfc00024:	0009c882 	srl	t9,t1,0x2
bfc00028:	00098083 	sra	s0,t1,0x2
bfc0002c:	0109882a 	slt	s1,t0,t1
bfc00030:	0109902b 	sltu	s2,t0,t1
bfc00034:	21130005 	addi	s3,t0,5
bfc00038:	31140005 	andi	s4,t0,0x5
bfc0003c:	35150005 	ori	s5,t0,0x5
bfc00040:	39160005 	xori	s6,t0,0x5
bfc00044:	3c171234 	lui	s7,0x1234
bfc00048:	11090004 	beq	t0,t1,bfc0005c <label1>
bfc0004c:	00000000 	nop
bfc00050:	00000000 	nop
bfc00054:	15090005 	bne	t0,t1,bfc0006c <label2>
bfc00058:	4a000000 	c2	0x0

bfc0005c <label1>:
label1():
bfc0005c:	00000000 	nop
bfc00060:	3c0a8000 	lui	t2,0x8000
bfc00064:	8d4a0000 	lw	t2,0(t2)
bfc00068:	4a000000 	c2	0x0

bfc0006c <label2>:
label2():
bfc0006c:	00000000 	nop
bfc00070:	3c0a8000 	lui	t2,0x8000
bfc00074:	8d4a0000 	lw	t2,0(t2)
bfc00078:	4a000000 	c2	0x0

Disassembly of section .data:

80000000 <my_data>:
my_data():
80000000:	12345678 	beq	s1,s4,800159e4 <my_data+0x159e4>

Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	03ffff00 	0x3ffff00
	...

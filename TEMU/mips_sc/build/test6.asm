
build/test6:     file format elf32-tradlittlemips
build/test6


Disassembly of section .text:

bfc00000 <main>:
bfc00000:	3c020000 	lui	v0,0x0
bfc00004:	34420004 	ori	v0,v0,0x4
bfc00008:	3c030000 	lui	v1,0x0
bfc0000c:	3463001c 	ori	v1,v1,0x1c
bfc00010:	14400002 	bnez	v0,bfc0001c <main+0x1c>
bfc00014:	0062001a 	div	zero,v1,v0
bfc00018:	0007000d 	break	0x7
bfc0001c:	2401ffff 	li	at,-1
bfc00020:	14410004 	bne	v0,at,bfc00034 <main+0x34>
bfc00024:	3c018000 	lui	at,0x8000
bfc00028:	14610002 	bne	v1,at,bfc00034 <main+0x34>
bfc0002c:	00000000 	nop
bfc00030:	0006000d 	break	0x6
bfc00034:	00001812 	mflo	v1
bfc00038:	00004012 	mflo	t0
bfc0003c:	15000002 	bnez	t0,bfc00048 <error>
bfc00040:	00000000 	nop
bfc00044:	4a000000 	c2	0x0

bfc00048 <error>:
error():
bfc00048:	0000003f 	0x3f

Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	0000010e 	0x10e
	...

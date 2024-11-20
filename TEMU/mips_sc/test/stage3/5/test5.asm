
build/test5:     file format elf32-tradlittlemips
build/test5


Disassembly of section .text:

bfc00000 <main>:
bfc00000:	0bf0000f 	j	bfc0003c <L4>
bfc00004:	00000000 	nop
bfc00008:	00000000 	nop

bfc0000c <L2>:
L2():
bfc0000c:	2401000a 	li	at,10
bfc00010:	2410000a 	li	s0,10
bfc00014:	14300011 	bne	at,s0,bfc0005c <inst_error>
bfc00018:	00000000 	nop
bfc0001c:	0ff0000a 	jal	bfc00028 <L3>
bfc00020:	00000000 	nop
bfc00024:	00000000 	nop

bfc00028 <L3>:
L3():
bfc00028:	24010002 	li	at,2
bfc0002c:	24100002 	li	s0,2
bfc00030:	1430000a 	bne	at,s0,bfc0005c <inst_error>
bfc00034:	00000000 	nop
bfc00038:	4a000000 	c2	0x0

bfc0003c <L4>:
L4():
bfc0003c:	24010003 	li	at,3
bfc00040:	24100003 	li	s0,3
bfc00044:	14300005 	bne	at,s0,bfc0005c <inst_error>
bfc00048:	00000000 	nop
bfc0004c:	3c02bfc0 	lui	v0,0xbfc0
bfc00050:	2442000c 	addiu	v0,v0,12
bfc00054:	00400008 	jr	v0
bfc00058:	00000000 	nop

bfc0005c <inst_error>:
inst_error():
bfc0005c:	0000003f 	0x3f
bfc00060:	4a000000 	c2	0x0

Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	80010006 	lb	at,6(zero)
	...

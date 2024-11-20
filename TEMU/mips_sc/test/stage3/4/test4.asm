
build/test4:     file format elf32-tradlittlemips
build/test4


Disassembly of section .text:

bfc00000 <main>:
bfc00000:	3c09bfc0 	lui	t1,0xbfc0
bfc00004:	1029001c 	beq	at,t1,bfc00078 <lable2>
bfc00008:	00000000 	nop
bfc0000c:	24020000 	li	v0,0
bfc00010:	3c01f0e0 	lui	at,0xf0e0
bfc00014:	3421d0c0 	ori	at,at,0xd0c0
bfc00018:	00200011 	mthi	at
bfc0001c:	00200013 	mtlo	at
bfc00020:	24010001 	li	at,1
bfc00024:	00000810 	mfhi	at
bfc00028:	24010001 	li	at,1
bfc0002c:	00000812 	mflo	at
bfc00030:	ac410000 	sw	at,0(v0)
bfc00034:	80410000 	lb	at,0(v0)
bfc00038:	90410000 	lbu	at,0(v0)
bfc0003c:	84410000 	lh	at,0(v0)
bfc00040:	94410000 	lhu	at,0(v0)
bfc00044:	8c410000 	lw	at,0(v0)
bfc00048:	00000000 	nop
bfc0004c:	a0410004 	sb	at,4(v0)
bfc00050:	a4410008 	sh	at,8(v0)
bfc00054:	ac41000c 	sw	at,12(v0)
bfc00058:	3c01bfc0 	lui	at,0xbfc0
bfc0005c:	0020f809 	jalr	at
bfc00060:	00000000 	nop
bfc00064:	0000003f 	0x3f

bfc00068 <lable1>:
lable1():
bfc00068:	24010000 	li	at,0
bfc0006c:	0020f809 	jalr	at
bfc00070:	00000000 	nop
bfc00074:	4a000000 	c2	0x0

bfc00078 <lable2>:
lable2():
bfc00078:	03e00008 	jr	ra
bfc0007c:	00000000 	nop

Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	80000206 	lb	zero,518(zero)
	...

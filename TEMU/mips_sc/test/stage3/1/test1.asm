
build/test1:     file format elf32-tradlittlemips
build/test1


Disassembly of section .text:

bfc00000 <main>:
bfc00000:	3c011010 	lui	at,0x1010
bfc00004:	34211011 	ori	at,at,0x1011
bfc00008:	3c020101 	lui	v0,0x101
bfc0000c:	34421111 	ori	v0,v0,0x1111
bfc00010:	3c036fef 	lui	v1,0x6fef
bfc00014:	3463efef 	ori	v1,v1,0xefef
bfc00018:	00224020 	add	t0,at,v0
bfc0001c:	3c011010 	lui	at,0x1010
bfc00020:	34211011 	ori	at,at,0x1011
bfc00024:	20291111 	addi	t1,at,4369
bfc00028:	3c011010 	lui	at,0x1010
bfc0002c:	34211011 	ori	at,at,0x1011
bfc00030:	00225021 	addu	t2,at,v0
bfc00034:	3c011010 	lui	at,0x1010
bfc00038:	34211011 	ori	at,at,0x1011
bfc0003c:	242b1111 	addiu	t3,at,4369
bfc00040:	3c011010 	lui	at,0x1010
bfc00044:	34211011 	ori	at,at,0x1011
bfc00048:	00226022 	sub	t4,at,v0
bfc0004c:	3c011010 	lui	at,0x1010
bfc00050:	34211011 	ori	at,at,0x1011
bfc00054:	00226823 	subu	t5,at,v0
bfc00058:	0022702a 	slt	t6,at,v0
bfc0005c:	282f1111 	slti	t7,at,4369
bfc00060:	0022c02b 	sltu	t8,at,v0
bfc00064:	2c391111 	sltiu	t9,at,4369
bfc00068:	0129001a 	div	zero,t1,t1
bfc0006c:	0129001b 	divu	zero,t1,t1
bfc00070:	00420018 	mult	v0,v0
bfc00074:	4a000000 	c2	0x0

Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	0300ff0e 	0x300ff0e
	...

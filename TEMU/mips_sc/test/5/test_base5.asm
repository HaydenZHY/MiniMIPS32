
build/test_base5:     file format elf32-tradlittlemips
build/test_base5


Disassembly of section .text:

bfc00000 <main>:
bfc00000:	3c181010 	lui	t8,0x1010
	...
bfc00010:	37011011 	ori	at,t8,0x1011
bfc00014:	3c0af000 	lui	t2,0xf000
	...
bfc00024:	35420005 	ori	v0,t2,0x5
	...
bfc00034:	00224020 	add	t0,at,v0
bfc00038:	20291111 	addi	t1,at,4369
bfc0003c:	00224021 	addu	t0,at,v0
bfc00040:	24291111 	addiu	t1,at,4369
bfc00044:	00224022 	sub	t0,at,v0
bfc00048:	00224823 	subu	t1,at,v0
bfc0004c:	3c180000 	lui	t8,0x0
	...
bfc0005c:	37010001 	ori	at,t8,0x1
bfc00060:	3c0a0000 	lui	t2,0x0
	...
bfc00070:	35420000 	ori	v0,t2,0x0
	...
bfc00080:	0022402a 	slt	t0,at,v0
bfc00084:	28280000 	slti	t0,at,0
bfc00088:	0022402b 	sltu	t0,at,v0
bfc0008c:	2c280000 	sltiu	t0,at,0
bfc00090:	3c18ffff 	lui	t8,0xffff
	...
bfc000a0:	3701ffff 	ori	at,t8,0xffff
bfc000a4:	3c0a7fff 	lui	t2,0x7fff
	...
bfc000b4:	3542ffff 	ori	v0,t2,0xffff
	...
bfc000c4:	00220018 	mult	at,v0
bfc000c8:	00220019 	multu	at,v0
bfc000cc:	2401ffff 	li	at,-1
bfc000d0:	24020000 	li	v0,0
bfc000d4:	3c18ffff 	lui	t8,0xffff
	...
bfc000e4:	3701ffff 	ori	at,t8,0xffff
bfc000e8:	3c0a0000 	lui	t2,0x0
	...
bfc000f8:	35420000 	ori	v0,t2,0x0
	...
bfc00108:	00224024 	and	t0,at,v0
bfc0010c:	30280000 	andi	t0,at,0x0
bfc00110:	3c08ffff 	lui	t0,0xffff
bfc00114:	00224027 	nor	t0,at,v0
bfc00118:	00224825 	or	t1,at,v0
bfc0011c:	34280000 	ori	t0,at,0x0
bfc00120:	00224026 	xor	t0,at,v0
bfc00124:	38290000 	xori	t1,at,0x0
bfc00128:	3c18ff12 	lui	t8,0xff12
	...
bfc00138:	37013456 	ori	at,t8,0x3456
bfc0013c:	3c0a0000 	lui	t2,0x0
	...
bfc0014c:	35420000 	ori	v0,t2,0x0
	...
bfc0015c:	00414004 	sllv	t0,at,v0
bfc00160:	000147c0 	sll	t0,at,0x1f
bfc00164:	000147c3 	sra	t0,at,0x1f
bfc00168:	00414007 	srav	t0,at,v0
bfc0016c:	000147c2 	srl	t0,at,0x1f
bfc00170:	00414006 	srlv	t0,at,v0
bfc00174:	3c18f234 	lui	t8,0xf234
	...
bfc00184:	37015678 	ori	at,t8,0x5678
bfc00188:	24100000 	li	s0,0
	...
bfc00198:	26100000 	addiu	s0,s0,0
	...
bfc001a8:	26100008 	addiu	s0,s0,8
	...
bfc001b8:	a2010000 	sb	at,0(s0)
bfc001bc:	a6010002 	sh	at,2(s0)
bfc001c0:	ae010004 	sw	at,4(s0)
bfc001c4:	82080000 	lb	t0,0(s0)
bfc001c8:	92080000 	lbu	t0,0(s0)
bfc001cc:	86080002 	lh	t0,2(s0)
bfc001d0:	96080002 	lhu	t0,2(s0)
bfc001d4:	8e080004 	lw	t0,4(s0)
	...
bfc001e4:	4a000000 	c2	0x0

Disassembly of section .data:

80000000 <bdata>:
bdata():
80000000:	f4f3f2f1 	0xf4f3f2f1
80000004:	f8f7f6f5 	0xf8f7f6f5

Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	01010706 	0x1010706
	...


build/test_base3:     file format elf32-tradlittlemips
build/test_base3


Disassembly of section .text:

bfc00000 <main>:
bfc00000:	3c18f010 	lui	t8,0xf010
	...
bfc00010:	37011011 	ori	at,t8,0x1011
bfc00014:	3c0a0000 	lui	t2,0x0
	...
bfc00024:	35420005 	ori	v0,t2,0x5
	...
bfc00034:	00224020 	add	t0,at,v0
bfc00038:	2029ffff 	addi	t1,at,-1
bfc0003c:	00224021 	addu	t0,at,v0
bfc00040:	2429ffff 	addiu	t1,at,-1
bfc00044:	00224022 	sub	t0,at,v0
bfc00048:	00224823 	subu	t1,at,v0
bfc0004c:	3c18ffff 	lui	t8,0xffff
	...
bfc0005c:	3701ffff 	ori	at,t8,0xffff
bfc00060:	3c0a0000 	lui	t2,0x0
	...
bfc00070:	35420001 	ori	v0,t2,0x1
	...
bfc00080:	0022402a 	slt	t0,at,v0
bfc00084:	28280001 	slti	t0,at,1
bfc00088:	0022402b 	sltu	t0,at,v0
bfc0008c:	2c280001 	sltiu	t0,at,1
bfc00090:	3c18ffff 	lui	t8,0xffff
	...
bfc000a0:	3701ffff 	ori	at,t8,0xffff
bfc000a4:	3c0affff 	lui	t2,0xffff
	...
bfc000b4:	3542ffff 	ori	v0,t2,0xffff
	...
bfc000c4:	00220018 	mult	at,v0
bfc000c8:	00220019 	multu	at,v0
bfc000cc:	3c180000 	lui	t8,0x0
	...
bfc000dc:	37010000 	ori	at,t8,0x0
bfc000e0:	3c180000 	lui	t8,0x0
	...
bfc000f0:	37020000 	ori	v0,t8,0x0
	...
bfc00100:	00224024 	and	t0,at,v0
bfc00104:	30280000 	andi	t0,at,0x0
bfc00108:	3c08ffff 	lui	t0,0xffff
bfc0010c:	00224027 	nor	t0,at,v0
bfc00110:	00224825 	or	t1,at,v0
bfc00114:	34280000 	ori	t0,at,0x0
bfc00118:	00224026 	xor	t0,at,v0
bfc0011c:	38290000 	xori	t1,at,0x0
bfc00120:	3c180f12 	lui	t8,0xf12
	...
bfc00130:	37013456 	ori	at,t8,0x3456
bfc00134:	3c0a0000 	lui	t2,0x0
	...
bfc00144:	35420037 	ori	v0,t2,0x37
	...
bfc00154:	00414004 	sllv	t0,at,v0
bfc00158:	00014300 	sll	t0,at,0xc
bfc0015c:	00014303 	sra	t0,at,0xc
bfc00160:	00414007 	srav	t0,at,v0
bfc00164:	00014302 	srl	t0,at,0xc
bfc00168:	00414006 	srlv	t0,at,v0
bfc0016c:	24100000 	li	s0,0
	...
bfc0017c:	26100000 	addiu	s0,s0,0
	...
bfc0018c:	82080000 	lb	t0,0(s0)
bfc00190:	92080000 	lbu	t0,0(s0)
bfc00194:	86080002 	lh	t0,2(s0)
bfc00198:	96080002 	lhu	t0,2(s0)
bfc0019c:	8e080004 	lw	t0,4(s0)
bfc001a0:	a2010000 	sb	at,0(s0)
bfc001a4:	82080000 	lb	t0,0(s0)
bfc001a8:	a6010002 	sh	at,2(s0)
bfc001ac:	86080002 	lh	t0,2(s0)
bfc001b0:	ae010004 	sw	at,4(s0)
bfc001b4:	8e080004 	lw	t0,4(s0)
	...
bfc001c4:	4a000000 	c2	0x0

Disassembly of section .data:

80000000 <bdata>:
bdata():
80000000:	f4f3f2f1 	0xf4f3f2f1
80000004:	f8f7f6f5 	0xf8f7f6f5

Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	01010706 	0x1010706
	...


build/test_base2:     file format elf32-tradlittlemips
build/test_base2


Disassembly of section .text:

bfc00000 <main>:
bfc00000:	3c181010 	lui	t8,0x1010
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
bfc0004c:	3c180000 	lui	t8,0x0
	...
bfc0005c:	37010001 	ori	at,t8,0x1
bfc00060:	3c0affff 	lui	t2,0xffff
	...
bfc00070:	3542ffff 	ori	v0,t2,0xffff
	...
bfc00080:	0022402a 	slt	t0,at,v0
bfc00084:	2828ffff 	slti	t0,at,-1
bfc00088:	0022402b 	sltu	t0,at,v0
bfc0008c:	2c28ffff 	sltiu	t0,at,-1
bfc00090:	3c187fff 	lui	t8,0x7fff
	...
bfc000a0:	3701ffff 	ori	at,t8,0xffff
bfc000a4:	3c0a7fff 	lui	t2,0x7fff
	...
bfc000b4:	3542ffff 	ori	v0,t2,0xffff
	...
bfc000c4:	00220018 	mult	at,v0
bfc000c8:	00220019 	multu	at,v0
bfc000cc:	3c18ffff 	lui	t8,0xffff
	...
bfc000dc:	3701ffff 	ori	at,t8,0xffff
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
bfc00120:	3c18ff12 	lui	t8,0xff12
	...
bfc00130:	37013456 	ori	at,t8,0x3456
bfc00134:	3c0a0000 	lui	t2,0x0
	...
bfc00144:	35420007 	ori	v0,t2,0x7
	...
bfc00154:	00414004 	sllv	t0,at,v0
bfc00158:	000143c0 	sll	t0,at,0xf
bfc0015c:	000143c3 	sra	t0,at,0xf
bfc00160:	00414007 	srav	t0,at,v0
bfc00164:	000143c2 	srl	t0,at,0xf
bfc00168:	00414006 	srlv	t0,at,v0
bfc0016c:	24100000 	li	s0,0
	...
bfc0017c:	26100000 	addiu	s0,s0,0
	...
bfc0018c:	26100004 	addiu	s0,s0,4
	...
bfc0019c:	8208ffff 	lb	t0,-1(s0)
bfc001a0:	9208ffff 	lbu	t0,-1(s0)
bfc001a4:	8608fffe 	lh	t0,-2(s0)
bfc001a8:	9608fffe 	lhu	t0,-2(s0)
bfc001ac:	8e08fffc 	lw	t0,-4(s0)
bfc001b0:	a201ffff 	sb	at,-1(s0)
bfc001b4:	8208ffff 	lb	t0,-1(s0)
bfc001b8:	a601fffe 	sh	at,-2(s0)
bfc001bc:	8608fffe 	lh	t0,-2(s0)
bfc001c0:	ae01fffc 	sw	at,-4(s0)
bfc001c4:	8e08fffc 	lw	t0,-4(s0)
	...
bfc001d4:	4a000000 	c2	0x0

Disassembly of section .data:

80000000 <bdata>:
bdata():
80000000:	44332211 	0x44332211
80000004:	88776655 	lwl	s7,26197(v1)

Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	01010706 	0x1010706
	...


build/test_base1:     file format elf32-tradlittlemips
build/test_base1


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
bfc00038:	20291111 	addi	t1,at,4369
bfc0003c:	00224021 	addu	t0,at,v0
bfc00040:	24291111 	addiu	t1,at,4369
bfc00044:	00224022 	sub	t0,at,v0
bfc00048:	00224823 	subu	t1,at,v0
bfc0004c:	3c18f000 	lui	t8,0xf000
	...
bfc0005c:	37010000 	ori	at,t8,0x0
bfc00060:	3c0affff 	lui	t2,0xffff
	...
bfc00070:	3542ffff 	ori	v0,t2,0xffff
	...
bfc00080:	0022402a 	slt	t0,at,v0
bfc00084:	2828ffff 	slti	t0,at,-1
bfc00088:	0022402b 	sltu	t0,at,v0
bfc0008c:	2c28ffff 	sltiu	t0,at,-1
bfc00090:	3c180000 	lui	t8,0x0
	...
bfc000a0:	37010001 	ori	at,t8,0x1
bfc000a4:	3c0affff 	lui	t2,0xffff
	...
bfc000b4:	3542ffff 	ori	v0,t2,0xffff
	...
bfc000c4:	00220018 	mult	at,v0
bfc000c8:	00220019 	multu	at,v0
bfc000cc:	3c18ffff 	lui	t8,0xffff
	...
bfc000dc:	3701ffff 	ori	at,t8,0xffff
bfc000e0:	3c0affff 	lui	t2,0xffff
	...
bfc000f0:	3542ffff 	ori	v0,t2,0xffff
	...
bfc00100:	00224024 	and	t0,at,v0
bfc00104:	3028ffff 	andi	t0,at,0xffff
bfc00108:	3c081234 	lui	t0,0x1234
bfc0010c:	00224027 	nor	t0,at,v0
bfc00110:	00224825 	or	t1,at,v0
bfc00114:	3428ffff 	ori	t0,at,0xffff
bfc00118:	00224026 	xor	t0,at,v0
bfc0011c:	3829ffff 	xori	t1,at,0xffff
bfc00120:	00414004 	sllv	t0,at,v0
bfc00124:	000140c0 	sll	t0,at,0x3
bfc00128:	000140c3 	sra	t0,at,0x3
bfc0012c:	00414007 	srav	t0,at,v0
bfc00130:	000140c2 	srl	t0,at,0x3
bfc00134:	00414006 	srlv	t0,at,v0
bfc00138:	00200011 	mthi	at
bfc0013c:	00200013 	mtlo	at
bfc00140:	00000000 	nop
bfc00144:	00005810 	mfhi	t3
bfc00148:	00004812 	mflo	t1
bfc0014c:	3c181234 	lui	t8,0x1234
	...
bfc0015c:	37015678 	ori	at,t8,0x5678
bfc00160:	3c0a0000 	lui	t2,0x0
	...
bfc00170:	35420004 	ori	v0,t2,0x4
	...
bfc00180:	a0410001 	sb	at,1(v0)
bfc00184:	a4410010 	sh	at,16(v0)
bfc00188:	ac410020 	sw	at,32(v0)
bfc0018c:	80480001 	lb	t0,1(v0)
bfc00190:	90480001 	lbu	t0,1(v0)
bfc00194:	84480010 	lh	t0,16(v0)
bfc00198:	94480010 	lhu	t0,16(v0)
bfc0019c:	8c480020 	lw	t0,32(v0)
	...
bfc001ac:	4a000000 	c2	0x0

Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	01000f06 	0x1000f06
	...

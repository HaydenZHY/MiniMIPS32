
build/test2:     file format elf32-tradlittlemips
build/test2


Disassembly of section .text:

bfc00000 <main>:
bfc00000:	3c011000 	lui	at,0x1000
bfc00004:	34210011 	ori	at,at,0x11
bfc00008:	3c020101 	lui	v0,0x101
bfc0000c:	34421111 	ori	v0,v0,0x1111
bfc00010:	00220019 	multu	at,v0
bfc00014:	00224024 	and	t0,at,v0
bfc00018:	30291234 	andi	t1,at,0x1234
bfc0001c:	3c081234 	lui	t0,0x1234
bfc00020:	00224827 	nor	t1,at,v0
bfc00024:	00224025 	or	t0,at,v0
bfc00028:	35091235 	ori	t1,t0,0x1235
bfc0002c:	00224026 	xor	t0,at,v0
bfc00030:	38280123 	xori	t0,at,0x123
bfc00034:	2402000f 	li	v0,15
bfc00038:	00414004 	sllv	t0,at,v0
bfc0003c:	00014400 	sll	t0,at,0x10
bfc00040:	00414007 	srav	t0,at,v0
bfc00044:	00014403 	sra	t0,at,0x10
bfc00048:	00414006 	srlv	t0,at,v0
bfc0004c:	00014402 	srl	t0,at,0x10
bfc00050:	24020030 	li	v0,48
bfc00054:	00414004 	sllv	t0,at,v0
bfc00058:	00014300 	sll	t0,at,0xc
bfc0005c:	00414007 	srav	t0,at,v0
bfc00060:	00014303 	sra	t0,at,0xc
bfc00064:	00414006 	srlv	t0,at,v0
bfc00068:	00014302 	srl	t0,at,0xc
bfc0006c:	3c01f000 	lui	at,0xf000
bfc00070:	34210011 	ori	at,at,0x11
bfc00074:	3c020101 	lui	v0,0x101
bfc00078:	34421111 	ori	v0,v0,0x1111
bfc0007c:	00220019 	multu	at,v0
bfc00080:	00414004 	sllv	t0,at,v0
bfc00084:	00014300 	sll	t0,at,0xc
bfc00088:	00414007 	srav	t0,at,v0
bfc0008c:	00014303 	sra	t0,at,0xc
bfc00090:	00414006 	srlv	t0,at,v0
bfc00094:	00014302 	srl	t0,at,0xc
bfc00098:	3c01f000 	lui	at,0xf000
bfc0009c:	34210011 	ori	at,at,0x11
bfc000a0:	3c02f101 	lui	v0,0xf101
bfc000a4:	34421111 	ori	v0,v0,0x1111
bfc000a8:	00220019 	multu	at,v0
bfc000ac:	00414004 	sllv	t0,at,v0
bfc000b0:	00014300 	sll	t0,at,0xc
bfc000b4:	00414007 	srav	t0,at,v0
bfc000b8:	00014303 	sra	t0,at,0xc
bfc000bc:	00414006 	srlv	t0,at,v0
bfc000c0:	00014302 	srl	t0,at,0xc
bfc000c4:	0bf00033 	j	bfc000cc <L1>
bfc000c8:	00000000 	nop

bfc000cc <L1>:
L1():
bfc000cc:	0ff00036 	jal	bfc000d8 <L2>
bfc000d0:	00000000 	nop
bfc000d4:	4a000000 	c2	0x0

bfc000d8 <L2>:
L2():
bfc000d8:	01084020 	add	t0,t0,t0
bfc000dc:	03e00008 	jr	ra
bfc000e0:	00000000 	nop

Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	80000306 	lb	zero,774(zero)
	...

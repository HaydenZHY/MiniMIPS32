
build/test3:     file format elf32-tradlittlemips
build/test3


Disassembly of section .text:

bfc00000 <main>:
bfc00000:	24080000 	li	t0,0
bfc00004:	24090001 	li	t1,1

bfc00008 <L1>:
L1():
bfc00008:	11090001 	beq	t0,t1,bfc00010 <L3>

bfc0000c <L2>:
L2():
bfc0000c:	15090002 	bne	t0,t1,bfc00018 <L4>

bfc00010 <L3>:
L3():
bfc00010:	24080000 	li	t0,0
bfc00014:	0501fffd 	bgez	t0,bfc0000c <L2>

bfc00018 <L4>:
L4():
bfc00018:	24080001 	li	t0,1
bfc0001c:	1d000002 	bgtz	t0,bfc00028 <L6>

bfc00020 <L5>:
L5():
bfc00020:	24080000 	li	t0,0
bfc00024:	19000002 	blez	t0,bfc00030 <L7>

bfc00028 <L6>:
L6():
bfc00028:	2408ffff 	li	t0,-1
bfc0002c:	05000002 	bltz	t0,bfc00038 <L8>

bfc00030 <L7>:
L7():
bfc00030:	24080000 	li	t0,0
bfc00034:	05110002 	bgezal	t0,bfc00040 <L9>

bfc00038 <L8>:
L8():
bfc00038:	2408ffff 	li	t0,-1
bfc0003c:	0510fff8 	bltzal	t0,bfc00020 <L5> 
1111 1111 1111 1111 1110 0000
bfc00040 <L9>:
L9():
bfc00040:	3c081234 	lui	t0,0x1234
bfc00044:	35085678 	ori	t0,t0,0x5678
bfc00048:	3c091234 	lui	t1,0x1234
bfc0004c:	35295677 	ori	t1,t1,0x5677
bfc00050:	11090010 	beq	t0,t1,bfc00094 <inst_error>
bfc00054:	3c091234 	lui	t1,0x1234
bfc00058:	35295678 	ori	t1,t1,0x5678
bfc0005c:	1509000d 	bne	t0,t1,bfc00094 <inst_error>
bfc00060:	2408ffff 	li	t0,-1
bfc00064:	0501000b 	bgez	t0,bfc00094 <inst_error>
bfc00068:	24080000 	li	t0,0
bfc0006c:	1d000009 	bgtz	t0,bfc00094 <inst_error>
bfc00070:	24080001 	li	t0,1
bfc00074:	19000007 	blez	t0,bfc00094 <inst_error>
bfc00078:	24080000 	li	t0,0
bfc0007c:	05000005 	bltz	t0,bfc00094 <inst_error>
bfc00080:	2408ffff 	li	t0,-1
bfc00084:	05110003 	bgezal	t0,bfc00094 <inst_error>
bfc00088:	24080000 	li	t0,0 ##
bfc0008c:	05100001 	bltzal	t0,bfc00094 <inst_error>
bfc00090:	4a000000 	c2	0x0

bfc00094 <inst_error>:
inst_error():
bfc00094:	0000003f 	0x3f

bfc00098 <good>:
good():
bfc00098:	4a000000 	c2	0x0

Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	80000300 	lb	zero,768(zero)
	...

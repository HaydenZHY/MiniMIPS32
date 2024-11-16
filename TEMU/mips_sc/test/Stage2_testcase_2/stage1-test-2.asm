
build/stage1-test-2:     file format elf32-tradlittlemips
build/stage1-test-2


Disassembly of section .text:

bfc00000 <main>:
bfc00000:	24080005 	li	t0,5
bfc00004:	24090005 	li	t1,5
bfc00008:	11090005 	beq	t0,t1,bfc00020 <equal>
bfc0000c:	00000000 	nop
bfc00010:	240a0000 	li	t2,0
bfc00014:	3c018000 	lui	at,0x8000
bfc00018:	ac2a0000 	sw	t2,0(at)
bfc0001c:	0bf0000c 	j	bfc00030 <end>

bfc00020 <equal>:
equal():
bfc00020:	00000000 	nop
bfc00024:	240a0001 	li	t2,1
bfc00028:	3c018000 	lui	at,0x8000
bfc0002c:	ac2a0000 	sw	t2,0(at)

bfc00030 <end>:
end():
bfc00030:	4a000000 	c2	0x0

Disassembly of section .data:

80000000 <result>:
result():
80000000:	00000000 	nop

Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	00000702 	srl	zero,zero,0x1c
	...

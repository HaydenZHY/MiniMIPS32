#include "helper.h"
#include "monitor.h"
#include "reg.h"

extern uint32_t instr;
extern char assembly[80];

static void decode_j_type(uint32_t instr) {
    op_src1->instr_index = ( instr & INDEX_MASK ) & 0x1FFFFFFF;
}

make_helper(j) {
    decode_j_type(instr);
    uint32_t addr = (((int)cpu.pc)&0xF0000000) | (op_src1->instr_index << 2);
    cpu.pc = addr - 4;
    sprintf(assembly, "j %x", cpu.pc + 4);
}

make_helper(jal) {
    decode_j_type(instr);
    cpu.ra=cpu.pc + 8;
    uint32_t addr = (((int)cpu.pc)&0xF0000000) | (op_src1->instr_index << 2);
    cpu.pc = addr - 4;
    sprintf(assembly, "jal %x", cpu.pc+4);
}
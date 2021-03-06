`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface hazard_unit_if;
// import types
import cpu_types_pkg::*;

logic dhit, ihit, halt;//input for hazard unit
logic [1:0] ptAScr, ptBScr;
logic [5:0] opcode_ex;
logic [4:0] regwrite_mem, regwrite_wb, rs, rt, rs_ex, rt_ex, regwrite_ex;//last one
logic regwen_mem, regwen_wb, memren_ex, memren_mem;//lastone
logic pc_en_nxt, ifid_en_nxt,idex_en_nxt,exmem_en_nxt, memwb_en_nxt,flush_ifid_nxt,flush_idex_nxt,flush_exmem_nxt;
logic [5:0] opcode_mem, opcode_id;
logic datomic;


logic ifid_en, idex_en,exmem_en,memwb_en, pc_en, dmemren;
logic flush_idex,flush_ifid, flush_exmem; //flush_memwb;
logic branch;
logic Regwen;
logic memwen_ex;

modport hu (
	input dhit, ihit, halt,regwrite_mem, regwrite_wb, rs, rt, rs_ex, rt_ex, regwen_mem, memren_ex, regwen_wb, branch, opcode_mem,opcode_ex,dmemren,opcode_id, regwrite_ex, memren_mem,memwen_ex,
	output ptAScr, ptBScr,ifid_en, idex_en,exmem_en,memwb_en, pc_en, flush_idex,flush_ifid, flush_exmem, pc_en_nxt, ifid_en_nxt,idex_en_nxt,exmem_en_nxt, memwb_en_nxt,flush_ifid_nxt,flush_idex_nxt,flush_exmem_nxt
);

endinterface

`endif 

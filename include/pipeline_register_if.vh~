`ifndef PIPELINE_REGISTER_IF_VH
`define PIPELINE_REGISTER_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface pipeline_register_if;
  // import types
  import cpu_types_pkg::*;

  logic dhit;//, ihit;
  logic ifid_en, idex_en,exmem_en,memwb_en; 

  //IF/ID input
  word_t imemload_if, pc_if;
  logic flush_ifid;
 
  //IF/ID output
  word_t imemload_id, pc_id;

  //ID/EX input
  
  opcode_t opcode_id;
  logic [1:0] PCScr_id,dataScr_id,ALUScr_id,RegDest_id;
  logic memren_id, memwen_id, Regwen_id, halt_id, branch_id;	
  logic [3:0] ALUOP_id;
  word_t rdat1_id, rdat2_id;
  logic [15:0] imm_id;
  logic [4:0] shamt_id, rt_id, rd_id, rs_id;
  logic flush_idex;
  
  //ID/EX output
  logic [5:0] opcode_ex; 
  logic [1:0] PCScr_ex,dataScr_ex,ALUScr_ex,RegDest_ex;
  logic memren_ex, memwen_ex, Regwen_ex, halt_ex, branch_ex;	
  logic [3:0] ALUOP_ex;
  word_t rdat1_ex, rdat2_ex, pc_ex, instr_ex, rdat2_temp;
  logic [15:0] imm_ex;
  logic [4:0] shamt_ex, rt_ex, rd_ex, rs_ex;

  //EX/MEM input
  logic zero_flag;
  word_t pc_bran_ex, ALUrlt_ex;
  logic [4:0] regwrite_ex;
  logic flush_exmem;
  

  //EX/MEM output
  logic [5:0] opcode_mem;
  logic dmemren, dmemwen, branch_mem, Regwen_mem, halt_mem,zero_flag_mem;
  logic[1:0] PCScr_mem, dataScr_mem;
  word_t pc_mem, pc_bran_mem, dmemaddr, dmemstore, instr_mem, rdat1_mem;
  logic[4:0] regwrite_mem;
  logic [15:0] imm_mem;

  //MEM/WB input
  word_t dmemload;
  
  //MEM/WB output
  logic halt_wb,Regwen_wb;
  logic[1:0] dataScr_wb;
  logic [4:0] regwrite_wb;
  word_t dmemaddr_wb, dmemload_wb;
  logic [15:0] imm_wb;
  word_t pc_wb;

  	
 
endinterface

`endif 

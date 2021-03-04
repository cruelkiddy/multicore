`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;
	
	opcode_t opcode;
	funct_t  funct;
        logic [1:0] PCScr,DataScr,ALUScr,RegDest;
	logic memren, memwen, Regwen, halt, zero_flag, branch, dhit, ihit;	
	logic [3:0] ALUOP;

modport ctr (
	input opcode, funct, zero_flag,dhit,ihit,
	output PCScr,DataScr,ALUScr, memren, memwen, Regwen, ALUOP, RegDest, halt, branch	
);

modport tb (
	input PCScr,DataScr,ALUScr, memren, memwen, Regwen, ALUOP, RegDest, halt, branch,
	output opcode, funct, zero_flag	,dhit
);

endinterface
`endif


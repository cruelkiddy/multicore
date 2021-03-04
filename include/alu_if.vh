`ifndef ALU_IF_VH
`define ALU_IF_VH

`include "cpu_types_pkg.vh"

interface alu_if;
	  import cpu_types_pkg::*;

	  word_t portA,portB,portOut;
	  logic neg_flag,zero_flag,of_flag;
	  logic [3:0] ALUOP;
 modport alu (
    input   portA, portB,ALUOP,
    output  portOut, neg_flag, zero_flag, of_flag
  );
  // register file tb
  modport tb (
    input   portOut, neg_flag, zero_flag, of_flag,
    output  portA, portB, ALUOP
  );
endinterface
`endif

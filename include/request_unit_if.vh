`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

// typedefs
`include "cpu_types_pkg.vh"
`include "control_unit_if.vh"

interface request_unit_if;
// import types
import cpu_types_pkg::*;
         
	logic memren, memwen, dhit, ihit;	
	logic dmemwen, dmemren;

modport req (
	input memren, memwen, dhit, ihit,
	output 	dmemwen, dmemren
);

modport tb (
	input dmemwen, dmemren,
	output memren, memwen, dhit, ihit
);

endinterface
`endif


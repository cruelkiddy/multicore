// mapped needs this
`include "hazard_unit_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module hazard_unit_tb;

  
  // interface
  hazard_unit_if huif ();
  //test program 
  test PROG (huif);
  // DUT
`ifndef MAPPED
  hazard_unit DUT(huif);
`endif
endmodule

program test(
	hazard_unit_if.hu husif,
);

initial begin
	huif.dhit = 0;
	huif.ihit = 0;
	huif.halt = 0;
	huif.regwrite_mem = 5'b0;
	huif.regwrite_wb = 5'b0;
	huif.rs = 5'b0;
rt, rs_ex, rt_ex, regwen_mem, memren_ex, regwen_wb, branch, opcode
end
endprogram

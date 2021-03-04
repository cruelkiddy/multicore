// mapped needs this
`include "request_unit_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module request_unit_tb;
  
   parameter PERIOD = 10;
  
   logic CLK = 0, nRST;
  
   // clock
   always #(PERIOD/2) CLK++;

   //interface
   request_unit_if ruif();

   //test program
   test PROG (CLK, nRST, ruif);
   request_unit DUT(CLK, nRST, ruif);
endmodule

program test (input logic CLK, 
	      output logic nRST,
	      request_unit_if.tb ruif);
int testcase =0;
initial begin
	ruif.memren=1'b0;
	ruif.memwen=1'b0;
	ruif.ihit=1'b0;
	ruif.dhit=1'b0;
        //test reset
	@(posedge CLK)
        testcase++;
	nRST = 1'b0;
	@(posedge CLK)
        testcase++;
        nRST = 1'b1;
	@(posedge CLK)
	@(posedge CLK)
        ruif.memren=1'b1;
	//test memren
	@(posedge CLK)
        ruif.dhit=1'b1;
 	@(posedge CLK)
	testcase++;
	ruif.dhit=1'b0;
	ruif.ihit=1'b1;
        @(posedge CLK)
	ruif.memren=1'b0;
        ruif.memwen=1'b1;
	@(posedge CLK)
        ruif.dhit=1'b1;
        @(posedge CLK)
	ruif.dhit=1'b0;
	@(posedge CLK)
	ruif.memwen=1'b0;
	testcase++;
end
endprogram

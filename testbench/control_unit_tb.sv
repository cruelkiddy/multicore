// mapped needs this
`include "control_unit_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module control_unit_tb;
  
   parameter PERIOD = 10;
  
   logic CLK = 0, nRST;
  
   // clock
   always #(PERIOD/2) CLK++;

   //interface
   control_unit_if ruif();

   //test program
   test PROG (CLK, nRST, ruif);
   control_unit DUT(CLK, nRST, cuif);
endmodule

program test (input logic CLK, 
	      output logic nRST,
	      control_unit_if.tb cuif);
int testcase =0;
initial begin
	cuif.opcode='0;
	cuif.funct='0;
	cuif.zero_flag=1'b0;
        //test reset
	@(posedge CLK)
        testcase++;//test J type
	cuif.opcode=6'b000010;//J
	cuif.funct='0;
	cuif.zero_flag=1'b0;	
	@(posedge CLK)
        testcase++;//test JAL type	
	cuif.opcode=6'b000011;//JAL
	cuif.funct='0;
	cuif.zero_flag=1'b0;
	@(posedge CLK)
        testcase++;//test itype	
	cuif.opcode=6'b000100;//BEQ
	cuif.funct='0;
	cuif.zero_flag=1'b0;
	@(posedge CLK)
        testcase++;//test itype	
	cuif.opcode=6'b000101;//BNE
	cuif.funct='0;
	cuif.zero_flag=1'b0;
	@(posedge CLK)
        testcase++;//test itype	
	cuif.opcode=6'b000100;//ADDI
	cuif.funct='0;
	cuif.zero_flag=1'b0;
        @(posedge CLK)
        testcase++;//test itype	
	cuif.opcode=6'b001101;//ORI
	cuif.funct='0;
	cuif.zero_flag=1'b0;@(posedge CLK)
        @(posedge CLK)        
	testcase++;//test itype	
	cuif.opcode=6'b001110;//LUI
	cuif.funct='0;
	cuif.zero_flag=1'b0;@(posedge CLK)
	@(posedge CLK)
        testcase++;//test itype	
	cuif.opcode=6'b111111;//HALT
	cuif.funct='0;
	cuif.zero_flag=1'b0;
	@(posedge CLK)
        testcase++;//test Rtype	
	cuif.funct=6'b00000;//SLL
	cuif.opcode='0;
	cuif.zero_flag=1'b0;
	@(posedge CLK)
        testcase++;//test Rtype	
	cuif.funct=6'b001000;//JR
	cuif.opcode='0;
	cuif.zero_flag=1'b0;
	@(posedge CLK)
        testcase++;//test Rtype	
	cuif.funct=6'b10010;//SUB
	cuif.opcode='0;
	cuif.zero_flag=1'b0;
	
			       
end
endprogram


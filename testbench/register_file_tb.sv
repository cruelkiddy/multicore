// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;
  
  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;
  int testcase = 0;
   
  // clock
  always #(PERIOD/2) CLK++;
  
  // interface
  register_file_if rfif ();
  //test program 
  test PROG (CLK, nRST, rfif, v1, v2, v3);
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\reg_f.rdat2 (rfif.rdat2),
    .\reg_f.rdat1 (rfif.rdat1),
    .\reg_f.wdat (rfif.wdat),
    .\reg_f.rsel2 (rfif.rsel2),
    .\reg_f.rsel1 (rfif.rsel1),
    .\reg_f.wsel (rfif.wsel),
    .\reg_f.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif
endmodule

program test(
	input logic CLK,
	output logic nRST,
	register_file_if.tb rfif,
        input int v1, v2, v3	
);
int testcase;
initial begin
	rfif.wsel = 0;
      rfif.rsel1 = 0;
       rfif.rsel2=0;      
      @(posedge CLK)//reset test
      nRST = 1'b0;
      @(posedge CLK)
      nRST = 1'b1;
      //store enable
      rfif.WEN = 1;
      //write v1 in wsel=1
      rfif.wdat = v1;
      rfif.wsel = 1;
      @(posedge CLK)
      //write v2 in wsel=2
      rfif.wdat = v2;
      rfif.wsel = 2;
      @(posedge CLK)
      //write v3 in wsel=3
      rfif.wdat = v3;
      rfif.wsel = 3;
      @(posedge CLK);
      testcase++;
      
      rfif.rsel1 = 3;
      rfif.rsel2 = 2;
      @(posedge CLK);
      
      //write zero in register 0
      rfif.wsel = 0;
      rfif.wdat = v2;
      
      //read from data1 3 data2 2
      
       @(posedge CLK)
       testcase++;
      
      //write v2 in wsel=3
      rfif.rsel1 = 0;
      rfif.rsel2 = 0;
	 
      rfif.wdat = v3;
      rfif.wsel = 1;
 
      @(posedge CLK)//reset test 2
      testcase ++;
   
      nRST = 1'b0;
      @(posedge CLK)
      nRST = 1'b1;
end
endprogram

// mapped needs this
`include "alu_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;
    parameter PERIOD = 10;
  // interface
   alu_if aluif ();

   logic CLK = 0;
   
   always #(PERIOD/2) CLK++;
`ifndef MAPPED
   alu DUT(aluif);
`else
   alu DUT(
      .\aluif.portA (aluif.portA),
      .\aluif.portB (aluif.portB),
      .\aluif.portOut (aluif.portOut),
      .\aluif.neg_flag (aluif.neg_flag),
      .\aluif.zero_flag (aluif.zero_flag),
      .\aluif.of_flag (aluif.of_flag),
      .\aluif.ALUOP (aluif.ALUOP)
   );  
`endif 
   int 	 testcase = 0;
   
   initial begin
      aluif.portA = 0;
      aluif.portB = 0;
      aluif.ALUOP= 4'hF;
      @(posedge CLK);
      
      testcase++;
      aluif.ALUOP = 0;
      aluif.portA = 32'd1;
      aluif.portB = 2;
      @(posedge CLK);
      
      testcase++;
      aluif.ALUOP = 1;
      aluif.portA = 32'd16;
      aluif.portB = 2;
      @(posedge CLK);
      
	testcase++;
      aluif.ALUOP = 2;
      aluif.portA = $signed(32'hAfffffff);
      aluif.portB = $signed(32'hAfffffff);
      @(posedge CLK);
      
      testcase++;
      aluif.ALUOP = 3;
      aluif.portA = 100;
      aluif.portB = 101;

        @(posedge CLK);
      
      testcase++;
      aluif.ALUOP = 3;
      aluif.portA = 101;
      aluif.portB = 101;

      @(posedge CLK);
      testcase++;
      aluif.ALUOP = 4;
      aluif.portA = 1;
      aluif.portB = 3;

      @(posedge CLK);

       testcase++;
      aluif.ALUOP = 5;
      aluif.portA = 1;
      aluif.portB = 10;

      @(posedge CLK);

       testcase++;
      aluif.ALUOP = 6;
      aluif.portA = 1;
      aluif.portB = 100;

      @(posedge CLK);

       testcase++;
      aluif.ALUOP = 7;
      aluif.portA = 10;
      aluif.portB = 32'hff20;

      @(posedge CLK);

       testcase++;
      aluif.ALUOP = 10;
      aluif.portA = 1;
      aluif.portB = 32'hffffffff;
            
      @(posedge CLK);

       testcase++;
      aluif.ALUOP = 11;
      aluif.portA = 1;
      aluif.portB = 32'hffffffff;
      
   end // initial begin
  
endmodule



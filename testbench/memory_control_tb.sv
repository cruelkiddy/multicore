// mapped needs this
`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"
`include "cpu_ram_if.vh"
`include "caches_if.vh"
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;
  
   parameter PERIOD = 10;
  
   logic CLK = 0, nRST;
  
   // clock
   always #(PERIOD/2) CLK++;
  
  // interface
   caches_if cif0();
   cache_control_if #(.CPUS(1)) ccif(cif0,cif0);
 
   cpu_ram_if ramif();
  //test program 
  test PROG (CLK, nRST, ccif);
  // DUT
`ifndef MAPPED
  memory_control DUT(CLK, nRST, ccif);
  ram ram (CLK, nRST, ramif);
`endif
endmodule

program test(
	input logic CLK,
	output logic nRST,
	cache_control_if ccif	
);
   import cpu_types_pkg::*;
   
   int 		     testcase;	
   assign ramif.ramaddr = ccif.ramaddr;
   assign ramif.ramstore = ccif.ramstore;
   assign ramif.ramREN = ccif.ramREN;
   assign ramif.ramWEN = ccif.ramWEN;
	
   assign ccif.ramstate = ramif.ramstate;
   assign ccif.ramload = ramif.ramload;

 
   
   initial begin
      //test reset
      @(posedge CLK);
      testcase ++;
      nRST = 1'b0;
      ccif.cif0.dWEN=1'b0;
      ccif.cif0.iREN=1'b0;
      ccif.cif0.dREN=1'b0;
     
      //test write data
      @(posedge CLK);
      testcase ++;
      nRST = 1'b1;
      ccif.cif0.dWEN = 1'b1;
      ccif.cif0.daddr = 32'd00000012;
      ccif.cif0.dstore = 32'd00000001;
      @(posedge CLK);
      
      @(posedge CLK);
      
      //test read instruction
      @(posedge CLK);
      testcase ++;
      ccif.cif0.dWEN = 1'b0;
      ccif.cif0.iREN = 1'b1;
      ccif.cif0.iaddr = 32'd000000012;
      
      //write second data
      @(posedge CLK);
      testcase ++;
      ccif.cif0.iREN=1'b0;	
      ccif.cif0.dWEN = 1'b1;
      ccif.cif0.daddr = 32'd000000016;
      ccif.cif0.dstore = 32'd00000002;

      @(posedge CLK);
      
      @(posedge CLK);
      
      //read data
      @(posedge CLK);
      ccif.cif0.dWEN = 1'b0;
      ccif.cif0.dREN = 1'b1;
      ccif.cif0.daddr = 32'd000000016;
      
      //continous writing data 
      @(posedge CLK);	
      ccif.cif0.dREN = 1'b0;
      ccif.cif0.dWEN = 1'b1;
      ccif.cif0.daddr = 32'd00000000;
      ccif.cif0.dstore = 32'd00000002;
      @(posedge CLK);
      
      @(posedge CLK);
      @(posedge CLK);		
      ccif.cif0.daddr = 32'd00000004;
      ccif.cif0.dstore = 32'd00000003;
       @(posedge CLK);
      
      @(posedge CLK);
      @(posedge CLK);		
      ccif.cif0.daddr = 32'd00000008;
      ccif.cif0.dstore = 32'd00000004;

     
      @(posedge CLK);
      
      @(posedge CLK);
      //test read data
      @(posedge CLK);
      testcase ++;
      ccif.cif0.dWEN = 1'b0;
      ccif.cif0.iREN = 1'b1;
      ccif.cif0.dREN = 1'b1;
      ccif.cif0.daddr = 32'd00000008;
      @(posedge CLK);
      @(posedge CLK);
      ccif.cif0.daddr = 32'd00000004;
      @(posedge CLK);
      @(posedge CLK);
      ccif.cif0.daddr = 32'd00000000;
      @(posedge CLK);
      //test continouse read instruction
      @(posedge CLK);
      testcase ++;
      ccif.cif0.dREN = 1'b0;
      ccif.cif0.iREN = 1'b1;
      ccif.cif0.iaddr = 32'd00000000;
      @(posedge CLK);
      @(posedge CLK);
      ccif.cif0.iaddr = 32'd00000004;
       @(posedge CLK);
      @(posedge CLK);
      ccif.cif0.iaddr = 32'd00000008;

      dump_memory();
      
      
   end // initial begin


   task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    //cif0.tbCTRL = 1;
    cif0.daddr = 0;
    cif0.dWEN = 0;
    cif0.dREN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      cif0.daddr = i << 2;
      cif0.dREN = 1;
      repeat (4) @(posedge CLK);
      if (cif0.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif0.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif0.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      //cif0.tbCTRL = 0;
      cif0.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask
endprogram


// mapped needs this
`include "cache_control_if.vh"
`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"
`include "cpu_ram_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module icache_tb;
	import cpu_types_pkg::*;
	
	 parameter PERIOD = 20;
  
   	logic CLK = 0, CPUCLK = 0, nRST;
  
   	// clock
   	always #(PERIOD/2) CLK++;
  	always #(PERIOD) CPUCLK++;
  	
        // interface
        caches_if cif0();
   	cache_control_if #(.CPUS(1)) ccif(cif0,cif0);
 	datapath_cache_if dcif();
        cpu_ram_if ramif();
   

  	//test program 
 	test PROG (CPUCLK, nRST, dcif, cif0, ramif);
	
  	// DUT  
	`ifndef MAPPED
	icache ic (CPUCLK, nRST, dcif, cif0);
 	memory_control mc(CPUCLK, nRST, ccif);
 	ram ram (CLK, nRST, ramif);
    
	
	assign ramif.ramaddr = ccif.ramaddr;
   	assign ramif.ramstore = ccif.ramstore;
  	assign ramif.ramREN = ccif.ramREN;
   	assign ramif.ramWEN = ccif.ramWEN;
   	assign ccif.ramstate = ramif.ramstate;
   	assign ccif.ramload = ramif.ramload;
	`endif
endmodule

program test (
	input logic CLK,
	output logic nRST,
	datapath_cache_if dcif,
	//cache_control_if ccif,
	caches_if cif0,
	cpu_ram_if ramif		
	);
	
	int testcase = 0;	
   	
		
	parameter PERIOD = 20;
	int ind = 0;
	initial begin
		
      		//test reset
      		@(posedge CLK);
      		testcase ++;
		nRST = 1'b0;
		@(posedge CLK);
		nRST = 1'b1;
		
		$display ("Begin Instr Fetch");
		dcif.imemREN = 1'b1;
	        dcif.imemaddr = '0; 
		#(2 * PERIOD);
		for (ind = 0; ind < 16; ind++) begin
			testcase ++;
			#(2 * PERIOD);
			dcif.imemaddr += 4;
			#(2 * PERIOD);
			if (dcif.ihit == 1)
				$display ("hit\n");
		end 
		while (ind >= 0) begin
			testcase ++;
			#(2 * PERIOD);
			dcif.imemaddr -= 4;
			#(2 * PERIOD);
			if (dcif.ihit == 1)
				$display ("hit\n");
			ind -=1;	
		end	
		$finish;
	end

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


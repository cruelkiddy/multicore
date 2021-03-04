// mapped needs this
`include "cache_control_if.vh"
`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"
`include "cpu_ram_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module dcache_tb;
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
	dcache ic (CPUCLK, nRST, dcif, cif0);
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
		cif0.iREN = 1'b0;
		cif0.iaddr = 32'b0; 
      		//test reset
		nRST = 1'b0;
      		@(posedge CLK);
      		testcase ++;
		@(negedge CLK);
		nRST = 1'b0;
		$display ("Reset Test");
		@(negedge CLK);
		nRST = 1'b1;
		//cif0.iRen = 1'b0;

		$display ("Begin Data Write");
		dcif.dmemREN = 1'b0;
		dcif.dmemWEN = 1'b0;
	        dcif.dmemaddr = 32'h0000;
		dcif.dmemstore = 32'hAAAA;
		#(5 * PERIOD);
		for (ind = 0; ind < 10; ind++) begin
			testcase ++;
			
			dcif.dmemaddr += 4;
                        dcif.dmemstore +=1;
			dcif.dmemWEN = 1'b1;
			while (!dcif.dhit) 
				#(PERIOD);
			dcif.dmemWEN = 1'b0;
			$display("Address: %x, Data: %x", dcif.dmemaddr, dcif.dmemstore);
			if (dcif.dhit == 1)
				$display ("hit\n");
				dcif.dmemWEN = 1'b0;
			#(2 * PERIOD);
		end 
		dcif.dmemWEN = 1'b0;
		#(2 * PERIOD);
		$display ("Begin Data Read");
		//dcif.dmemREN = 1'b1;
		dcif.dmemWEN = 1'b0;
		dcif.dmemaddr+= 4;
		while (ind > 0) begin
			testcase ++;
			//#(2 * PERIOD);
			dcif.dmemaddr -= 4;
			dcif.dmemREN = 1'b1;
			while (!dcif.dhit) 
				#(PERIOD);
			dcif.dmemREN = 1'b0;
			if (dcif.dhit == 1)
				$display ("hit\n");
			ind -=1;
			#(2 * PERIOD);	
		end	
		dcif.dmemREN = 1'b0;
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


// mapped needs this
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
`include "cpu_types_pkg.vh"
`include "caches_if.vh"


// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module coherency_control_tb;

	  parameter PERIOD = 10;
	  parameter WAIT = 1;

	  logic CLK = 0, nRST;


	  // clock
	  always #(PERIOD/2) CLK++;

	  // interface
	  //cache_control_if ccif ();
	  caches_if cif0();
	  caches_if cif1();
   	  cache_control_if ccif(cif0,cif1);

	  logic snoopmatch0,snoopmatch1;
	  // test program
	  test PROG (
	  CLK,
	  nRST,
	  snoopmatch0,
	  snoopmatch1,
	  ccif

	  );
	 
	  // DUT
	  coherency_control DUT(CLK,nRST,snoopmatch0,snoopmatch1, ccif);

endmodule

program test(
	input logic CLK,
	output logic nRST, 
	output logic snoopmatch0,snoopmatch1,
	cache_control_if ccif
	
);
	import cpu_types_pkg::*;
	parameter PERIOD = 10;

	integer memfile;

initial begin
	nRST = 0;
	#(PERIOD)
	#(PERIOD)
	nRST = 1;
	ccif.cif0.daddr = 32'hdeadbeef;
	ccif.cif1.daddr = 32'hdeadbeee;
	
	ccif.cif0.cctrans=1;
	ccif.cif1.cctrans=0;
  
	//snoop1
	#(PERIOD)
	ccif.dwait[0] = 0;
  	ccif.dwait[1] = 0;
	
	ccif.cif1.ccwrite=1;
	ccif.cif0.ccwrite=0;

        snoopmatch0 = 0;
	snoopmatch1 = 1;
  	
  	//WB10
  	#(PERIOD)
 	ccif.dwait[0] = 0;
  	ccif.dwait[1] = 1;

	ccif.cif1.ccwrite=0;
	ccif.cif0.ccwrite=0;

        snoopmatch0 = 0;
	snoopmatch1 = 0;

	#(PERIOD)
 	ccif.dwait[1] = 0;

	//WB11
   	#(PERIOD)
 	ccif.dwait[0] = 0;
  	ccif.dwait[1] = 1;

	ccif.cif1.ccwrite=0;
	ccif.cif0.ccwrite=0;

        snoopmatch0 = 0;
	snoopmatch1 = 0;

	#(PERIOD)
 	ccif.dwait[1] = 0;

	//IDLE
	#(PERIOD)
	ccif.cif0.cctrans=0;
	ccif.cif1.cctrans=1;

	//snoop0
	#(PERIOD)
	ccif.dwait[0] = 0;
  	ccif.dwait[1] = 0;
	
	ccif.cif1.ccwrite=0;
	ccif.cif0.ccwrite=1;

        snoopmatch0 = 1;
	snoopmatch1 = 0;
  	
  	//WB00
  	#(PERIOD)
 	ccif.dwait[0] = 1;
  	ccif.dwait[1] = 0;

	ccif.cif1.ccwrite=0;
	ccif.cif0.ccwrite=0;

        snoopmatch0 = 0;
	snoopmatch1 = 0;

	#(PERIOD)
 	ccif.dwait[0] = 0;

	//WB01
   	#(PERIOD)
 	ccif.dwait[0] = 1;
  	ccif.dwait[1] = 0;

	ccif.cif1.ccwrite=0;
	ccif.cif0.ccwrite=0;

        snoopmatch0 = 0;
	snoopmatch1 = 0;

	#(PERIOD)
 	ccif.dwait[0] = 0;

        

	  

	#(PERIOD);
	#(PERIOD);
	$finish; 
end	  


endprogram

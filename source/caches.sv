/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/
`include "caches_if.vh"
`include "datapath_cache_if.vh"

module caches (
  input logic CLK, nRST,
  datapath_cache_if dcif,
  caches_if cif
);
  parameter CPUID = 0;
  // icache
  icache  ICACHE(CLK, nRST, dcif, cif);
  // dcache
  dcache  DCACHE(CLK, nRST, dcif, cif);

  
endmodule

`include "register_file_if.vh"
`include "cpu_types_pkg.vh"
module register_file
(
 input logic CLK,
 input logic nRST,
 register_file_if.rf reg_f
 );
   import cpu_types_pkg::*;
   word_t [31:0] reg_file;
   word_t [31:0] reg_file_nxt;
   always_ff @ (negedge CLK, negedge nRST) begin
      if (nRST == 0)  
	reg_file <='0;
      else if (reg_f.WEN == 1)
	reg_file <= reg_file_nxt;
   end

   always_comb begin
      reg_file_nxt = reg_file;
      if (reg_f.wsel == 0) begin
	 reg_file_nxt[reg_f.wsel] = '0;

	 
      end
      else begin
	 reg_file_nxt[reg_f.wsel] = reg_f.wdat;

      end
      	 reg_f.rdat1=reg_file[reg_f.rsel1];
	 reg_f.rdat2=reg_file[reg_f.rsel2];
   end
endmodule // register_file

   
  

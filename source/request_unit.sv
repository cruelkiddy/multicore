//CPU types
`include "cpu_types_pkg.vh"

//interfaces
`include "request_unit_if.vh"

module request_unit(
        input logic CLK, nRST,
	request_unit_if.req ruif
);

import cpu_types_pkg::*;

   
always_ff @(posedge CLK, negedge nRST)begin
	if (nRST==1'b0) begin
	   ruif.dmemwen<=1'b0;
	   ruif.dmemren<=1'b0;
	end
	else begin
	   if (ruif.ihit) begin
	      ruif.dmemwen<=ruif.memwen;
	      ruif.dmemren<=ruif.memren;
	   end
	   else if (ruif.dhit) begin
	      ruif.dmemwen<=1'b0;
	      ruif.dmemren<=1'b0;
	   end		 
	end
end
endmodule




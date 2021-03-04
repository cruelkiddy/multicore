`include "cpu_types_pkg.vh"
`include "alu_if.vh"

module alu
(
 alu_if.alu aluif	  
 );
import cpu_types_pkg::*;
   always_comb begin
      aluif.neg_flag = 0;
      aluif.of_flag = 0;
      aluif.zero_flag = 0;
      aluif.portOut = 0;
  
     if (aluif.ALUOP == ALU_SLL)begin
	 aluif.portOut = aluif.portA << aluif.portB;
      end
      else if (aluif.ALUOP == ALU_SRL) begin
	 aluif.portOut = aluif.portA >> aluif.portB;
      end
      else if (aluif.ALUOP == ALU_ADD) begin 
	   aluif.portOut = aluif.portA + aluif.portB;
	 if (aluif.portA[31] == aluif.portB[31] && aluif.portOut[31] != aluif.portB[31])
	   aluif.of_flag = 1;
      end

      else if (aluif.ALUOP == ALU_SUB) begin
	 aluif.portOut = aluif.portA-aluif.portB;
	  if (aluif.portA[31] != aluif.portB[31] && aluif.portOut[31] != aluif.portA[31])
	   aluif.of_flag = 1;	
      end

      else if (aluif.ALUOP == ALU_AND) begin
	 aluif.portOut =aluif.portA & aluif.portB;
      end
      else if (aluif.ALUOP == ALU_OR ) begin
	 aluif.portOut =aluif.portA | aluif.portB;
      end
      else if (aluif.ALUOP == ALU_XOR) begin
	 aluif.portOut =aluif.portA ^ aluif.portB;
      end
      else if (aluif.ALUOP == ALU_NOR) begin
	 aluif.portOut = ~(aluif.portA | aluif.portB);
      end
      else if (aluif.ALUOP == ALU_SLT) begin
	aluif.portOut=($signed(aluif.portA) < $signed(aluif.portB));
      end
      else if (aluif.ALUOP == ALU_SLTU)begin
	aluif.portOut=(aluif.portA < aluif.portB);
      end
      if (aluif.portOut[31]==1)
	aluif.neg_flag = 1;
      if (aluif.portOut==32'b0)
	aluif.zero_flag=1;
	  
   end // always_comb begin

  
   
endmodule // alu

   
   

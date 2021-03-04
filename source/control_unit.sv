//CPU types
`include "cpu_types_pkg.vh"

//interfaces

`include "control_unit_if.vh"

module control_unit(
	control_unit_if.ctr ctrif
);

import cpu_types_pkg::*;
	
logic bran_flag;	
always_comb begin
   ctrif.PCScr = 2'b0;
   ctrif.DataScr = 2'b0;
   ctrif.ALUScr = 2'b0;
   ctrif.RegDest = 2'b0;
   
   ctrif.memren=1'b0;
   ctrif.memwen=1'b0;
   ctrif.Regwen=1'b0;
   ctrif.halt=1'b0;
   ctrif.branch=1'b0;
   
   ctrif.ALUOP = 4'b1000;//alu op defualt value
   ctrif.datomic = '0;
  // bran_flag=1'b0;
   
   casez (ctrif.opcode)
//r type 
	RTYPE: begin
		casez(ctrif.funct)
		SLL: begin
		ctrif.ALUOP=ALU_SLL;
		ctrif.Regwen=1'b1;
		ctrif.ALUScr=2'b10;
		ctrif.RegDest=2'b1;
		end
			
		SRL: begin
		ctrif.ALUOP=ALU_SRL;
		ctrif.Regwen=1'b1;
		ctrif.ALUScr=2'b10;
		ctrif.RegDest=2'b1;	
		end

		ADD: begin
		ctrif.ALUOP=ALU_ADD;
		ctrif.Regwen=1'b1;
		ctrif.RegDest=2'b1;
		end
		
		ADDU: begin
		ctrif.ALUOP=ALU_ADD;
		ctrif.Regwen=1'b1;
		ctrif.RegDest=2'b1;
		end
	
		SUB: begin
		ctrif.ALUOP=ALU_SUB;
		ctrif.Regwen=1'b1;
		ctrif.RegDest=2'b1;
		end

		SUBU: begin
		ctrif.ALUOP=ALU_SUB;
		ctrif.Regwen=1'b1;
		ctrif.RegDest=2'b1;
		end

		AND: begin
		ctrif.ALUOP=ALU_AND;
		ctrif.Regwen=1'b1;
		ctrif.RegDest=2'b1;
		end

		OR: begin
		ctrif.ALUOP=ALU_OR;
		ctrif.Regwen=1'b1;
		ctrif.RegDest=2'b1;
		end

		XOR: begin
		ctrif.ALUOP=ALU_XOR;
		ctrif.Regwen=1'b1;
		ctrif.RegDest=2'b1;
		end

		NOR: begin
		ctrif.ALUOP= ALU_NOR;
		ctrif.Regwen=1'b1;
		ctrif.RegDest=2'b1;
		end

		SLT: begin
		ctrif.ALUOP=ALU_SLT;
		ctrif.Regwen=1'b1;
		ctrif.RegDest=2'b1;		
		end

		SLTU: begin
		ctrif.ALUOP=ALU_SLTU;
		ctrif.Regwen=1'b1;
		ctrif.RegDest=2'b1;
		end
              
                JR: begin
			ctrif.PCScr=2'b10;
		end

		endcase

        end 
//j type
	J: begin
		ctrif.PCScr=2'b11;		  		
	end
		
	JAL: begin
	   ctrif.PCScr=2'b11;
	   ctrif.RegDest=2'b10;
	   ctrif.Regwen=1'b1;
	   ctrif.DataScr=2'b11;		
	end

//i type
	BEQ: begin
		bran_flag=1'b1;
		ctrif.ALUOP=ALU_SUB;
		ctrif.PCScr=2'b1;
	   ctrif.branch=1'b1;
	end

	BNE: begin
		bran_flag=1'b1;
		ctrif.ALUOP=ALU_SUB;
		ctrif.PCScr=2'b1;
	   ctrif.branch=1'b1; 		
	end
//i type operation
	ADDI: begin
		ctrif.Regwen=1'b1;
		ctrif.ALUScr=2'b1;
		ctrif.ALUOP=ALU_ADD;	
	end

	ADDIU: begin
	        ctrif.Regwen=1'b1;
		ctrif.ALUScr=2'b1;
		ctrif.ALUOP=ALU_ADD;	
	end

	SLTI: begin
		ctrif.Regwen=1'b1;
		ctrif.ALUScr=2'b1;
		ctrif.ALUOP=ALU_SLT;	
	end

	SLTIU: begin
        	ctrif.Regwen=1'b1;
		ctrif.ALUScr=2'b1;
		ctrif.ALUOP=ALU_SLTU;
	end

	ANDI: begin
		ctrif.Regwen=1'b1;
		ctrif.ALUScr=2'b11;
		ctrif.ALUOP=ALU_AND;		
	end

	ORI: begin
		ctrif.Regwen=1'b1;
		ctrif.ALUScr=2'b11;
		ctrif.ALUOP=ALU_OR;	        
	end

	XORI: begin
	 	ctrif.Regwen=1'b1;
		ctrif.ALUScr=2'b11;
		ctrif.ALUOP=ALU_XOR;		
	end

	LUI: begin
        	ctrif.Regwen=1'b1;
       	        ctrif.DataScr=2'b10;
   
	end
	
	LW: begin
	   	ctrif.ALUScr=2'b1;
	   	ctrif.memren=1'b1;
	   	ctrif.DataScr=2'b1;
	   	ctrif.ALUOP=ALU_ADD;
	   	ctrif.Regwen=1'b1;		
	end

	SW: begin	   
		ctrif.Regwen=1'b0;
		ctrif.ALUScr=2'b1;
		ctrif.memwen=1'b1;	
  		ctrif.ALUOP=ALU_ADD;       
	end

	LL: begin
		   ctrif.memren = 1'b1;
		   ctrif.ALUScr = 2'b1;
		   ctrif.ALUOP = ALU_ADD;
		   ctrif.DataScr = 2'b1;
		   ctrif.Regwen = 1'b1;
		   ctrif.datomic = 1'b1;
	end
	
	SC: begin
		   ctrif.memwen = 1'b1;
		   ctrif.ALUScr = 2'b1;
		   ctrif.ALUOP = ALU_ADD;
		   ctrif.datomic = 1'b1;
		   ctrif.Regwen = 1'b1;
		   ctrif.DataScr = 2'b1;	   
	end
	HALT: begin
		ctrif.halt=1'b1;
	end
	
   endcase	
	
end

endmodule

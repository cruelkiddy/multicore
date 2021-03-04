/*
  Hao Wang, mg269
  Siyi Cai, mg268
*/

// data path interface
`include "datapath_cache_if.vh"

//interface
`include "register_file_if.vh"
`include "alu_if.vh"
`include "control_unit_if.vh"
`include "request_unit_if.vh"
`include "pipeline_register_if.vh"
`include "hazard_unit_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
	input logic CLK, nRST,
	datapath_cache_if.dp dpif
 
);
// import types
	import cpu_types_pkg::*;

	register_file_if rfif();
	alu_if aluif();
	control_unit_if cuif();
	//request_unit_if ruif();
	pipeline_register_if prif(); 
	hazard_unit_if huif();
 
// pc init
	parameter PC_INIT = 0;

	register_file RF (CLK, nRST, rfif);
	alu ALU (aluif);
	control_unit CU (cuif);
	pipeline_register PR(CLK, nRST, prif);
	hazard_unit HU ( huif);
 
//intruction declaration
	word_t instr, pc, pc_nxt;
    	assign instr=prif.imemload_id;
//hazard unit
	assign huif.dhit=dpif.dhit;
	assign huif.ihit=dpif.ihit;
	assign huif.halt=prif.halt_wb;//enable for ifid
	assign huif.regwrite_mem=prif.regwrite_mem;
	assign huif.regwrite_wb=prif.regwrite_wb;
	assign huif.rs=prif.rs_id;
	assign huif.rt=prif.rt_id;
	assign huif.rs_ex=prif.rs_ex;
	assign huif.rt_ex=prif.rt_ex;
	assign huif.regwen_mem=prif.Regwen_mem;
	assign huif.regwen_wb=prif.Regwen_wb;
	assign huif.memren_ex=prif.memren_ex;
        assign huif.opcode_mem=prif.opcode_mem;
	assign huif.opcode_id=prif.opcode_id;
	assign huif.regwrite_ex = prif.regwrite_ex;//asdfsafsadfasdfasdfsafsafasf
	assign huif.memren_mem = prif.dmemren;//safsadfasdfasfdfsda
/////////////////////////////////////////////////////////
        assign huif.memwen_ex = prif.memwen_ex;
	//assign huif.Regwen = prif.Regwen_ex;//asdfghjksdfghjkdfghjk
	assign huif.dmemren=prif.dmemren;
        assign huif.opcode_ex=prif.opcode_ex; 

	
//pipeline register enable
	assign prif.ifid_en=huif.ifid_en;
	assign prif.idex_en=huif.idex_en;
	assign prif.exmem_en=huif.exmem_en;
	assign prif.memwb_en=huif.memwb_en;
//pipeline register flush
	assign prif.flush_ifid	= huif.flush_ifid;
	assign prif.flush_idex 	= huif.flush_idex;
	assign prif.flush_exmem = huif.flush_exmem;
//control unit
	assign cuif.opcode=opcode_t'(instr[31:26]);
        assign cuif.funct=funct_t'(instr[5:0]);
	  
//pipeline assignment==control unit output
	assign prif.PCScr_id		= cuif.PCScr;
	assign prif.dataScr_id		= cuif.DataScr;
	assign prif.ALUScr_id		= cuif.ALUScr;
	assign prif.RegDest_id		= cuif.RegDest;
	assign prif.memren_id		= cuif.memren;
	assign prif.memwen_id		= cuif.memwen;
	assign prif.Regwen_id		= cuif.Regwen;
	assign prif.halt_id		= cuif.halt;
	assign prif.branch_id		= cuif.branch;
	assign prif.ALUOP_id		= cuif.ALUOP;
	assign prif.opcode_id 		= cuif.opcode;

////////////////////////////////////////////////////////////
	assign prif.datomic_id = cuif.datomic;
	assign dpif.datomic = prif.datomic_mem;        
	assign huif.datomic = prif.datomic_ex;
/////////////////////////////////////////////////////////////


//register file
	assign rfif.WEN=prif.Regwen_wb;
	assign rfif.rsel1=instr[25:21];
	assign rfif.rsel2=instr[20:16];
	assign rfif.wsel=prif.regwrite_wb;

  	assign prif.rdat1_id		= rfif.rdat1;
	assign prif.rdat2_id		= rfif.rdat2;
	assign prif.imm_id		= instr[15:0];
	assign prif.shamt_id		= instr[10:6];
	assign prif.rs_id		= instr[25:21];
	assign prif.rt_id		= instr[20:16];
	assign prif.rd_id		= instr[15:11];  
//ALU
  	//assign aluif.portA=prif.rdat1_ex;
	always_comb begin
		casez(huif.ptAScr)
		0: begin
			aluif.portA=prif.rdat1_ex;
		end
		1:begin
			aluif.portA=rfif.wdat;
		end
		2: begin
			aluif.portA=prif.dmemaddr;
		end
		3: begin
			aluif.portA= {prif.imm_mem,16'b0};
		end
		endcase
	end
  	assign aluif.ALUOP=prif.ALUOP_ex;
        word_t rdat2_temp;
        assign prif.rdat2_temp=rdat2_temp;
	always_comb begin

		casez(huif.ptBScr) 
		0: begin 
			rdat2_temp=prif.rdat2_ex;
		end
		1:begin
			rdat2_temp=rfif.wdat;
		end
		2: begin
			rdat2_temp=prif.dmemaddr;
		end
		3: begin
			rdat2_temp={prif.imm_mem,16'b0};
		end
	        endcase 

		casez(prif.ALUScr_ex)
		0: begin
			aluif.portB=rdat2_temp;
                       
		end
		1: begin
			if (prif.instr_ex[15])
				aluif.portB={{16{1'b1}},prif.imm_ex};
			else
				aluif.portB={{16{1'b0}},prif.imm_ex};
			end
		2: begin
			aluif.portB={{27{1'b0}},prif.shamt_ex};
		end
	    	3: begin
				aluif.portB={{16{1'b0}},prif.imm_ex};
		end
		endcase
	end   	
	always_comb begin
		casez(prif.RegDest_ex)
		0: begin
			prif.regwrite_ex = prif.rt_ex;
		end
		1: begin
			prif.regwrite_ex = prif.rd_ex;
		end
		2: begin
			prif.regwrite_ex = 5'b11111;
		end
		3: begin
			prif.regwrite_ex = 5'b0;
		end
		endcase
	end
        assign prif.pc_bran_ex = prif.imm_ex[15]?({{16{1'b1}},prif.imm_ex}<<2)+prif.pc_ex:({{16{1'b0}},prif.imm_ex}<<2)+prif.pc_ex;
	assign prif.zero_flag = aluif.zero_flag;
        assign prif.ALUrlt_ex= aluif.portOut;


//halt
	always_ff @ (negedge CLK, negedge nRST) begin
		if (nRST == 0)
			dpif.halt <= 0;
		else
			dpif.halt <= dpif.halt | prif.halt_mem;
	end
//	assign dpif.halt=prif.halt_mem;
//datapath
	assign dpif.imemREN=1'b1;   
	assign dpif.dmemREN=prif.dmemren;
    	assign dpif.dmemWEN=prif.dmemwen;	
	assign dpif.imemaddr=pc;
	assign dpif.dmemstore=prif.dmemstore;
	assign prif.imemload_if=dpif.imemload;
	assign dpif.dmemaddr=prif.dmemaddr;	
	assign prif.dhit=dpif.dhit;
        assign prif.dmemload=dpif.dmemload;
        
//PC !!!!
	
        assign prif.pc_if = pc+4;
   
  	always_ff @(posedge CLK, negedge nRST) begin
		if (nRST == 1'b0 ) 
			pc <= PC_INIT;
		else if (huif.pc_en)
			pc <= pc_nxt;
	end	       

	always_comb begin
		casez (prif.PCScr_mem) 
			0: begin
				pc_nxt= pc+4;
			end
			1: begin
				if (prif.opcode_mem == BEQ) begin
		  			if (prif.zero_flag_mem)
						pc_nxt=prif.pc_bran_mem;
					else
						pc_nxt = pc+4/*prif.pc_mem*/;
				end
				else begin
					if (!prif.zero_flag_mem)
						pc_nxt=prif.pc_bran_mem;
					else
						pc_nxt = pc+4/*prif.pc_mem*/;
				end
			end
			2: begin
				pc_nxt=prif.rdat1_mem;
			end
			3: begin
			   	pc_nxt={prif.pc_mem[31:28], prif.instr_mem[25:0],2'b00}; 
			end
		endcase	      
	end
	assign huif.branch = ((prif.opcode_mem == BEQ && prif.zero_flag_mem) || (prif.opcode_mem == BNE && !prif.zero_flag_mem) || prif.opcode_mem == J || prif.opcode_mem == JAL || (prif.opcode_mem == RTYPE && prif.instr_mem[5:0] == 6'b001000));
   
//wdat  
	always_comb begin
		casez(prif.dataScr_wb)
			0: begin
				rfif.wdat = prif.dmemaddr_wb;
			end
			1: begin
				rfif.wdat = prif.dmemload_wb;
			end
			2: begin
				rfif.wdat = {prif.imm_wb,16'b0};
			end
			3: begin
				rfif.wdat = prif.pc_wb;
			end
		endcase
	end
endmodule	

`include "pipeline_register_if.vh"
`include "cpu_types_pkg.vh"
module pipeline_register
(
 input logic CLK,
 input logic nRST,
 pipeline_register_if prif
 );
   import cpu_types_pkg::*;
//IF/ID
	always_ff @(posedge CLK, negedge nRST) begin
		if (!nRST) begin
			prif.imemload_id<='0;
			prif.pc_id<='0;
		end
		else if (prif.flush_ifid) begin
			prif.imemload_id<='0;
			prif.pc_id<='0;
		end
		else begin
			//if (!prif.halt_wb & prif.ihit) begin
			if (prif.ifid_en) begin
				prif.imemload_id<=prif.imemload_if;
				prif.pc_id <=prif.pc_if;
			end else begin
				prif.imemload_id <= prif.imemload_id;
				prif.pc_id <= prif.pc_id;
			end
		end
	end
//ID/EX
	always_ff @(posedge CLK, negedge nRST) begin
		if (!nRST) begin
			prif.PCScr_ex		<= 2'b0;
			prif.dataScr_ex		<= 2'b0;
			prif.ALUScr_ex		<= 2'b0;
			prif.RegDest_ex		<= 2'b0;
			prif.memren_ex		<= 0;
			prif.memwen_ex		<= 0;
			prif.Regwen_ex		<= 0;
			prif.halt_ex		<= 0;
			prif.branch_ex		<= 0;
			prif.ALUOP_ex		<= 4'b1111;//NOP
			prif.rdat1_ex		<= 32'b0;
			prif.rdat2_ex		<= 32'b0;
	        	prif.pc_ex		<= 32'b0;
			prif.imm_ex		<= 16'b0;
			prif.shamt_ex		<= 5'b0;
			prif.rt_ex		<= 5'b0;
			prif.rd_ex		<= 5'b0;
			prif.rd_ex		<= 5'b0;
  			prif.opcode_ex 		<= 6'b0;
			prif.instr_ex		<= 32'b0;
			prif.datomic_ex		<='0;
		end
		else if (prif.flush_idex) begin
			prif.PCScr_ex		<= 2'b0;
			prif.dataScr_ex		<= 2'b0;
			prif.ALUScr_ex		<= 2'b0;
			prif.RegDest_ex		<= 2'b0;
			prif.memren_ex		<= 0;
			prif.memwen_ex		<= 0;
			prif.Regwen_ex		<= 0;
			prif.halt_ex		<= 0;
			prif.branch_ex		<= 0;
			prif.ALUOP_ex		<= 4'b1111;//NOP
			prif.rdat1_ex		<= 32'b0;
			prif.rdat2_ex		<= 32'b0;
	        	prif.pc_ex		<= 32'b0;
			prif.imm_ex		<= 16'b0;
			prif.shamt_ex		<= 5'b0;
			prif.rt_ex		<= 5'b0;
			prif.rd_ex		<= 5'b0;
			prif.rd_ex		<= 5'b0;
  			prif.opcode_ex 		<= 6'b0;
			prif.instr_ex		<= 32'b0;
			prif.datomic_ex		<='0;
		end
        	else begin
			//if (prif.ihit) begin
			if (prif.idex_en) begin
				prif.PCScr_ex		<= prif.PCScr_id;
				prif.dataScr_ex		<= prif.dataScr_id;
				prif.ALUScr_ex		<= prif.ALUScr_id;
				prif.RegDest_ex		<= prif.RegDest_id;
				prif.memren_ex		<= prif.memren_id;
				prif.memwen_ex		<= prif.memwen_id;
				prif.Regwen_ex		<= prif.Regwen_id;
				prif.halt_ex		<= prif.halt_id;
				prif.branch_ex		<= prif.branch_id;
				prif.ALUOP_ex		<= prif.ALUOP_id;
				prif.rdat1_ex		<= prif.rdat1_id;
				prif.rdat2_ex		<= prif.rdat2_id;
				prif.pc_ex		<= prif.pc_id;
				prif.imm_ex		<= prif.imm_id;
				prif.shamt_ex		<= prif.shamt_id;
				prif.rt_ex		<= prif.rt_id;
				prif.rd_ex		<= prif.rd_id;
				prif.rs_ex		<= prif.rs_id;
				prif.opcode_ex 		<= prif.opcode_id;
				prif.instr_ex		<= prif.imemload_id;
				prif.datomic_ex		<= prif.datomic_id;
			end else begin
				prif.PCScr_ex		<= prif.PCScr_ex;
				prif.dataScr_ex		<= prif.dataScr_ex;
				prif.ALUScr_ex		<= prif.ALUScr_ex;
				prif.RegDest_ex		<= prif.RegDest_ex;
				prif.memren_ex		<= prif.memren_ex;
				prif.memwen_ex		<= prif.memwen_ex;
				prif.Regwen_ex		<= prif.Regwen_ex;
				prif.halt_ex		<= prif.halt_ex;
				prif.branch_ex		<= prif.branch_ex;
				prif.ALUOP_ex		<= prif.ALUOP_ex;
				prif.rdat1_ex		<= prif.rdat1_ex;
				prif.rdat2_ex		<= prif.rdat2_ex;
				prif.pc_ex		<= prif.pc_ex;
				prif.imm_ex		<= prif.imm_ex;
				prif.shamt_ex		<= prif.shamt_ex;
				prif.rt_ex		<= prif.rt_ex;
				prif.rd_ex		<= prif.rd_ex;
				prif.rs_ex		<= prif.rs_ex;
				prif.opcode_ex 		<= prif.opcode_ex;
				prif.instr_ex		<= prif.instr_ex;
				prif.datomic_ex		<= prif.datomic_ex;
			end
		end
	end
//EX/MEM
	always_ff @(posedge CLK, negedge nRST) begin
		if (!nRST) begin
			prif.dmemren		<= 0;
			prif.dmemwen		<= 0;
			prif.branch_mem		<= 0;
			prif.Regwen_mem		<= 0;
			prif.halt_mem		<= 0;
			prif.zero_flag_mem	<= 0;
			prif.PCScr_mem		<= 2'b0;
			prif.dataScr_mem	<= 2'b0;
			prif.pc_bran_mem	<= 32'b0;
			prif.dmemaddr		<= 32'b0;
			prif.dmemstore		<= 32'b0;
			prif.regwrite_mem	<= 5'b0;
			prif.opcode_mem 	<= 6'b0;
			prif.imm_mem		<= 16'b0;
			prif.instr_mem		<= 32'b0;
			prif.rdat1_mem		<=32'b0;
		end
		else if (prif.dhit) begin
			prif.dmemren		<= 0;
			prif.dmemwen		<= 0;
			prif.branch_mem		<= 0;
			prif.Regwen_mem		<= 0;
			prif.halt_mem		<= 0;
			prif.zero_flag_mem	<= 0;
			prif.PCScr_mem		<= 2'b0;
			prif.dataScr_mem	<= 2'b0;
			prif.pc_bran_mem	<= 32'b0;
			prif.dmemaddr		<= 32'b0;
			prif.dmemstore		<= 32'b0;
			prif.regwrite_mem	<= 5'b0;
			prif.opcode_mem 	<= 6'b0;
			prif.imm_mem		<= 16'b0;
			prif.instr_mem		<= 32'b0;
			prif.rdat1_mem		<=32'b0;
			prif.datomic_mem	<= '0;
		end
		else if (prif.flush_exmem) begin
			prif.dmemren		<= 0;
			prif.dmemwen		<= 0;
			prif.branch_mem		<= 0;
			prif.Regwen_mem		<= 0;
			prif.halt_mem		<= 0;
			prif.zero_flag_mem	<= 0;
			prif.PCScr_mem		<= 2'b0;
			prif.dataScr_mem	<= 2'b0;
			prif.pc_bran_mem	<= 32'b0;
			prif.dmemaddr		<= 32'b0;
			prif.dmemstore		<= 32'b0;
			prif.regwrite_mem	<= 5'b0;
			prif.opcode_mem 	<= 6'b0;
			prif.imm_mem		<= 16'b0;
			prif.instr_mem		<= 32'b0;
			prif.rdat1_mem		<=32'b0;
			prif.datomic_mem	<= '0;
		end
        	else begin
			//if (prif.ihit) begin
			if (prif.exmem_en) begin
				prif.dmemren		<= prif.memren_ex;
				prif.dmemwen		<= prif.memwen_ex;
				prif.branch_mem		<= prif.branch_ex;
				prif.Regwen_mem		<= prif.Regwen_ex;
				prif.halt_mem		<= prif.halt_ex;
				prif.zero_flag_mem	<= prif.zero_flag;
				prif.PCScr_mem		<= prif.PCScr_ex;
				prif.dataScr_mem	<= prif.dataScr_ex;
				prif.pc_mem		<= prif.pc_ex;
				prif.pc_bran_mem	<= prif.pc_bran_ex;
				prif.dmemaddr		<= prif.ALUrlt_ex;
				prif.dmemstore		<= prif.rdat2_temp; //forwarding
				prif.regwrite_mem	<= prif.regwrite_ex;
				prif.opcode_mem		<= prif.opcode_ex;
				prif.imm_mem		<= prif.imm_ex;
				prif.instr_mem		<= prif.instr_ex;
				prif.rdat1_mem		<= prif.rdat1_ex;
				prif.datomic_mem	<= prif.datomic_ex;
			end else begin
				prif.dmemren		<= prif.dmemren;
				prif.dmemwen		<= prif.dmemwen;
				prif.branch_mem		<= prif.branch_mem;
				prif.Regwen_mem		<= prif.Regwen_mem;
				prif.halt_mem		<= prif.halt_mem;
				prif.zero_flag_mem	<= prif.zero_flag_mem;
				prif.PCScr_mem		<= prif.PCScr_mem;
				prif.dataScr_mem	<= prif.dataScr_mem;
				prif.pc_mem		<= prif.pc_mem;
				prif.pc_bran_mem	<= prif.pc_bran_mem;
				prif.dmemaddr		<= prif.dmemaddr;
				prif.dmemstore		<= prif.dmemstore;
				prif.regwrite_mem	<= prif.regwrite_mem;
				prif.opcode_mem		<= prif.opcode_mem;
				prif.imm_mem		<= prif.imm_mem;
				prif.instr_mem		<= prif.instr_mem;
				prif.rdat1_mem		<= prif.rdat1_mem;
				prif.datomic_mem	<= prif.datomic_mem;
			end
		end
	end
//MEM/WB
	always_ff @(posedge CLK, negedge nRST) begin
		if (!nRST) begin
			prif.halt_wb		<= 0;
			prif.regwrite_wb	<= 0;
			prif.Regwen_wb		<= 0;
			prif.dataScr_wb		<= 2'b0;
			prif.dmemaddr_wb	<= 32'b0;
			prif.dmemload_wb	<= 32'b0;
			prif.imm_wb		<= 16'b0;
			prif.pc_wb		<= 32'b0;
		end else begin
			//if (prif.dhit || prif.ihit) begin
			if (prif.memwb_en) begin
				prif.halt_wb		<= prif.halt_mem;
				prif.regwrite_wb	<= prif.regwrite_mem;
				prif.Regwen_wb		<= prif.Regwen_mem;
				prif.dataScr_wb		<= prif.dataScr_mem;
				prif.dmemaddr_wb	<= prif.dmemaddr;
				prif.dmemload_wb	<= prif.dmemload;
				prif.imm_wb		<= prif.imm_mem;
				prif.pc_wb		<= prif.pc_mem;
			end else begin
				prif.halt_wb		<= prif.halt_wb;
				prif.regwrite_wb	<= prif.regwrite_wb;
				prif.Regwen_wb		<= prif.Regwen_wb;
				prif.dataScr_wb		<= prif.dataScr_wb;
				prif.dmemaddr_wb	<= prif.dmemaddr_wb;
				prif.dmemload_wb	<= prif.dmemload_wb;
				prif.imm_wb		<= prif.imm_wb;
				prif.pc_wb		<= prif.pc_wb;
			end
		end
	end
  
endmodule

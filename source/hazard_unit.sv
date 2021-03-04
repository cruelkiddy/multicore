`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"
module hazard_unit
(
	hazard_unit_if huif
 );

	import cpu_types_pkg::*;

always_comb begin 
	huif.ptAScr=2'b00;
	huif.ptBScr=2'b00;
        if (huif.opcode_mem == LUI && huif.regwen_mem && huif.regwrite_mem != 0 && huif.regwrite_mem == huif.rs_ex && huif.rs_ex != 0 )
		huif.ptAScr=2'b11;
	else if ( huif.regwen_mem && huif.regwrite_mem != 0 && huif.regwrite_mem == huif.rs_ex && huif.rs_ex != 0 ) 
		huif.ptAScr=2'b10;
	if (huif.regwen_mem && huif.regwrite_mem != 0 && huif.regwrite_mem == huif.rt_ex && huif.rt_ex != 0 )
		huif.ptBScr=2'b10;
	if (huif.regwen_mem && huif.regwrite_mem != 0 && huif.regwrite_mem == huif.rs_ex && huif.regwrite_wb == huif.rs_ex && huif.rs_ex != 0 ) 
		huif.ptAScr=2'b10;
	if (huif.regwen_mem && huif.regwrite_mem != 0 && huif.regwrite_mem == huif.rt_ex && huif.regwrite_wb == huif.rt_ex && huif.rt_ex != 0 )
		huif.ptBScr=2'b10;
	if (huif.regwen_wb && huif.regwrite_wb != 0 && huif.regwrite_wb == huif.rs_ex && huif.regwrite_mem != huif.rs_ex && huif.rs_ex != 0 )
		huif.ptAScr=2'b01;
	if (huif.regwen_wb && huif.regwrite_wb != 0 && huif.regwrite_wb == huif.rt_ex && huif.regwrite_mem != huif.rt_ex && huif.rt_ex != 0 )
		huif.ptBScr=2'b01;
	
end 

assign huif.exmem_en=!huif.dhit & huif.ihit;
assign huif.memwb_en=huif.ihit | huif.dhit;
assign huif.idex_en=huif.ihit;

always_comb begin //hazard unit
	huif.pc_en=huif.ihit & (~huif.dhit);
	huif.ifid_en=huif.ihit & !huif.halt;
	huif.flush_ifid=1'b0;
	huif.flush_idex=1'b0;
	huif.flush_exmem=1'b0;	


	if (huif.branch && huif.ihit) begin
		huif.flush_ifid=1'b1;
		huif.flush_idex=1'b1;		
		huif.flush_exmem=1'b1;
	end	
	else if (((huif.opcode_ex==6'b100011 | huif.opcode_ex== 6'b101011) || (huif.datomic && (huif.memwen_ex || huif.memren_ex))) && huif.ihit) begin
		huif.flush_idex=1'b1;
		huif.pc_en=1'b0;
		huif.ifid_en=1'b0; 
	end
end


endmodule

`include "cpu_types_pkg.vh"
`include "caches_if.vh"
`include "datapath_cache_if.vh"

module dcache(
	input logic CLK, nRST,
	datapath_cache_if dcif,
	caches_if cif
);

	import cpu_types_pkg::*;

	logic [7:0] 		  valid_left, valid_right, dirty_left, dirty_right, lru_left, lru_right;
	logic [7:0] 		  nxt_valid_left, nxt_valid_right, nxt_dirty_left, nxt_dirty_right, nxt_lru_left, nxt_lru_right;

	logic [7:0][25:0] 	  tag_left,tag_right;
	logic [7:0][25:0] 	  nxt_tag_left, nxt_tag_right;

	logic [7:0][31:0] 	  d1_left, d2_left, d1_right, d2_right;
	logic [7:0][31:0] 	  nxt_d1_left, nxt_d2_left, nxt_d1_right, nxt_d2_right;   
   
	typedef enum 	  logic [4:0] {IDLE, READ_WB_L1, READ_WB_L2, READ_WB_R1, READ_WB_R2, READ_LOAD_L1, READ_LOAD_L2, READ_LOAD_R1,READ_LOAD_R2, WRITE_WB_L1, WRITE_WB_L2, WRITE_WB_R1, WRITE_WB_R2, WRITE_LOAD1, WRITE_LOAD2, HALT_WB, HALT_WB_L1, HALT_WB_L2, HALT_WB_R1, HALT_WB_R2, HALT, SNOOP, HALT_SNOOP, WRITE_LEFT, WRITE_RIGHT} StateType;
	StateType state,nxt_state;
   
	logic [2:0] 		   index, l_index, nxt_l_index, cc_index;
	logic 		   word_sel, cc_select;
	logic [25:0] 	   tag, cc_tag;
	logic [31:0] 	   data_IN, data_OUT;
   
	assign index = dcif.dmemaddr[5:3];
	assign word_sel = dcif.dmemaddr[2];
	assign tag = dcif.dmemaddr[31:6];
	assign data_IN = cif.dload;
	assign cif.dstore = data_OUT;
	assign cc_index = cif.ccsnoopaddr[5:3];
	assign cc_tag = cif.ccsnoopaddr[31:6];
	assign cc_select = cif.ccsnoopaddr[2];
   

   //hit counter
	logic [31:0] 		   hit_count, nxt_hit_count;
	logic 			   miss, nxt_miss;

   //link register
	word_t 		   nxt_linkreg, linkreg;
	logic 		   nxt_link_v, link_v;
	logic 		   dmemWEN;

	always_ff @(posedge CLK, negedge nRST) begin
		if(!nRST) begin
			linkreg <= '0;
			link_v <= '0;
			state <= IDLE;
			valid_left <= '0;
			valid_right <= '0;
			dirty_left <= '0;
			dirty_right <= '0;
			lru_left <= '0;
			lru_right <= '0;
			tag_left <= '0;
			tag_right <= '0;
			d1_left <= '0;
			d2_left <= '0;
			d1_right <= '0;
			d2_right <= '0;
			l_index <= 0;
			hit_count <= '0;
			miss <= '0;
		end else begin
			linkreg <= nxt_linkreg;
			link_v <= nxt_link_v;
			state <= nxt_state;
			valid_left <= nxt_valid_left;
			valid_right <= nxt_valid_right;
			dirty_left <= nxt_dirty_left;
			dirty_right <= nxt_dirty_right;
			lru_left <= nxt_lru_left;
			lru_right <= nxt_lru_right;
			tag_left <= nxt_tag_left;
			tag_right <= nxt_tag_right;
			d1_left <= nxt_d1_left;
			d2_left <= nxt_d2_left;
			d1_right <= nxt_d1_right;
			d2_right <= nxt_d2_right;
			l_index <= nxt_l_index;
			hit_count <= nxt_hit_count;
			miss <= nxt_miss;
		end
	end
   

	//dmemload
	always_comb begin
		dcif.dmemload = '0;
		dmemWEN = '0;
	
		if (dcif.datomic && !dcif.dmemREN && linkreg == dcif.dmemaddr) begin
			if(!link_v) begin
				dcif.dmemload = 32'd0;
				dmemWEN = 0;
			end else if (link_v) begin
				dmemWEN = dcif.dmemWEN;
				dcif.dmemload = 32'd1;
			end
		end else begin
			dmemWEN = dcif.dmemWEN;	   
			if(tag == tag_left[index] & valid_left[index]) begin
				if(!word_sel)
					dcif.dmemload = d1_left[index];
				else
					dcif.dmemload = d2_left[index];
			end else if(tag == tag_right[index] & valid_right[index]) begin
				if(!word_sel)
					dcif.dmemload = d1_right[index];
				else
					dcif.dmemload = d2_right[index];
			end
		end
	end
   
	//dhit
	always_comb begin
		dcif.dhit = 0;
		if (dcif.datomic && !dcif.dmemREN && !link_v && linkreg == dcif.dmemaddr)
			dcif.dhit = 1;
		else if((tag == tag_left[index] & valid_left[index]) || (tag == tag_right[index] & valid_right[index])) begin
			if(dcif.dmemREN)
				dcif.dhit = 1;
			else if(dmemWEN) begin
				if(state == IDLE && ((dirty_left[index] && tag == tag_left[index]) || (dirty_right[index] && tag == tag_right[index])))
					dcif.dhit = 1;
			end
		end
	end

	//cctrans and ccwrite
	always_comb begin
		cif.cctrans = 0;
		cif.ccwrite = 0;
		if(!dcif.halt) begin
			if(cif.ccwait) begin
				if((valid_left[cc_index] && cc_tag == tag_left[cc_index]) || (cc_tag == tag_right[cc_index] & valid_right[cc_index]))
					cif.cctrans = 1;
				if((dirty_left[cc_index] && cc_tag == tag_left[cc_index]) || (cc_tag == tag_right[cc_index] & dirty_right[cc_index]))
					cif.ccwrite = 1;
			end else begin
				if(state == READ_WB_L1 || state == READ_WB_L2 || state == READ_WB_R1 || state == READ_WB_R2 || state == WRITE_WB_L1 || state == WRITE_WB_L2 || state == WRITE_WB_R1 || state == WRITE_WB_R2) begin
					cif.ccwrite = 1;
					cif.cctrans = 1;
				end else begin 
					if((valid_left[index] && tag == tag_left[index]) || (tag == tag_right[index] && valid_right[index]))
						cif.cctrans = 1;
					if((dirty_left[index] && tag == tag_left[index]) || (tag == tag_right[index] && dirty_right[index]))
						cif.ccwrite = 1;
				end
			end
		end else begin
			if(cif.ccwait) begin
				if((valid_left[cc_index] && cc_tag == tag_left[cc_index])  ||  (valid_right[cc_index] && cc_tag == tag_right[cc_index]))
					cif.cctrans = 1;
				if((dirty_left[cc_index] && cc_tag == tag_left[cc_index])  ||  (dirty_right[cc_index] == 1 && cc_tag == tag_right[cc_index]))
					cif.ccwrite = 1;
			end else begin
				if((valid_left[l_index]) ||  (valid_right[l_index]))
					cif.cctrans = 1;
				if((dirty_left[l_index]) ||  (dirty_right[l_index]))
					cif.ccwrite = 1;
			end
		end
	end
   
	//state logic
	always_comb begin
		nxt_valid_left = valid_left;
		nxt_valid_right = valid_right;
		nxt_dirty_left = dirty_left;
		nxt_dirty_right = dirty_right;
		nxt_lru_left = lru_left;
		nxt_lru_right = lru_right;
		nxt_tag_left = tag_left;
		nxt_tag_right = tag_right;
		nxt_d1_left = d1_left;
		nxt_d2_left = d2_left;
		nxt_d1_right = d1_right;
		nxt_d2_right = d2_right;
		nxt_state = state;
		cif.dREN = 0;
		cif.dWEN = 0;
		cif.daddr = 0;
		dcif.flushed = 0;
		data_OUT = 0;
		nxt_l_index = l_index;
		nxt_hit_count = hit_count;
		nxt_miss = miss;
		nxt_link_v = link_v;
		nxt_linkreg = linkreg;

		if (dcif.dhit && link_v && dmemWEN && linkreg == dcif.dmemaddr)
			nxt_link_v = 1'b0;
		if (dcif.datomic && dcif.dmemREN) begin
			nxt_link_v = 1'b1;	   
			nxt_linkreg = dcif.dmemaddr;
		end
	case(state)
		IDLE: begin
			if(dcif.dmemREN) begin
				if(tag == tag_left[index] & valid_left[index]) begin
					nxt_lru_left[index] = 1;
					nxt_lru_right[index] = 0;
				end
				else if(tag == tag_right[index] & valid_right[index]) begin
					nxt_lru_right[index] = 1;
					nxt_lru_left[index] = 0;
				end
			end else if(dmemWEN) begin
				if((tag == tag_left[index]) && valid_left[index] && dirty_left[index]) begin
					if(word_sel)
						nxt_d2_left[index] = dcif.dmemstore;
					else
						nxt_d1_left[index] = dcif.dmemstore;
					nxt_dirty_left[index] = 1;
					nxt_valid_left[index] = 1;
					nxt_lru_left[index] = 1;
					nxt_lru_right[index] = 0;
				end else if((tag == tag_right[index]) && valid_right[index] && dirty_right[index]) begin
					if(word_sel)
						nxt_d2_right[index] = dcif.dmemstore;
					else
			      		nxt_d1_right[index] = dcif.dmemstore;
			 		nxt_dirty_right[index] = 1;
			 		nxt_valid_right[index] = 1;
			 		nxt_lru_right[index] = 1;
			 		nxt_lru_left[index] = 0;
		      	end
		 	end
			if(dcif.halt) begin		 
				nxt_l_index = 0;
				nxt_state = HALT_WB;
			end else if(dcif.dmemREN)begin		 
				if(tag == tag_left[index] & valid_left[index] | tag == tag_right[index] & valid_right[index]) begin		      
					nxt_miss = 0;
					if(!miss)	   
						nxt_hit_count += 1;
					nxt_state = IDLE;		      
				end else if(!lru_right[index])  begin		     
					nxt_miss = 1;
					if(dirty_right[index])		   
						nxt_state = READ_WB_R1;			   
					else			  
						nxt_state = READ_LOAD_R1;
				end else if(dirty_left[index]) begin		      
					nxt_miss = 1;
					nxt_state = READ_WB_L1;
				end else begin		      
					nxt_miss = 1;
					nxt_state = READ_LOAD_L1;
				end
			end else if(dmemWEN) begin
				if((tag == tag_left[index]) && valid_left[index] && dirty_left[index]) begin		      
					nxt_miss = 0;
					if(!miss) begin			   
						nxt_hit_count += 1;
					end
					nxt_state = IDLE;
				end else if(tag == tag_right[index] && valid_right[index] && dirty_right[index]) begin		      
					nxt_miss = 0;
					if(!miss)
						nxt_hit_count += 1;
					nxt_state = IDLE;
				end else if((tag == tag_left[index]) && valid_left[index] && !dirty_left[index]) begin		      
					nxt_miss = 1;
					nxt_state = WRITE_LEFT;
				end else if((tag == tag_right[index] && valid_right[index]) && !dirty_right[index]) begin
					nxt_miss = 1;
					nxt_state = WRITE_RIGHT;
				end else if(!lru_right[index]) begin
					nxt_miss = 1;
					if(dirty_right[index])
						nxt_state = WRITE_WB_R1;
					else
						nxt_state = WRITE_LOAD2;
				end else if(dirty_left[index]) begin
					nxt_miss = 1;
					nxt_state = WRITE_WB_L1;
				end else begin
					nxt_miss = 1;
					nxt_state = WRITE_LOAD1;
				end
			end
				if(cif.ccwait)
					nxt_state = SNOOP;
		end
		READ_WB_L1: begin
			cif.dWEN = 1;
			cif.daddr = {tag_left[index],index,1'b0,2'b00};
			data_OUT = d1_left[index];
			if(!cif.dwait)
				nxt_state = READ_WB_L2;
			if(cif.ccwait)
				nxt_state = SNOOP;
		end
		READ_WB_L2: begin
			cif.dWEN = 1;
			cif.daddr = {tag_left[index],index,1'b1,2'b00};
			data_OUT = d2_left[index];
			if(!cif.dwait)
				nxt_state = READ_LOAD_L1;
		end
		READ_LOAD_L1: begin
			if(dcif.dmemREN) begin
				if(!cif.dwait) begin
					if(word_sel)
						nxt_d2_left[index] = data_IN;
					else
						nxt_d1_left[index] = data_IN;
				end
			end
			cif.dREN = 1;
			cif.daddr = dcif.dmemaddr;
			if(!cif.dwait)
				nxt_state = READ_LOAD_L2;
			if(cif.ccwait)
				nxt_state = SNOOP;
		end
		READ_LOAD_L2: begin
			if(dcif.dmemREN) begin
				if(!cif.dwait) begin
					if(word_sel)
						nxt_d1_left[index] = data_IN;
					else
						nxt_d2_left[index] = data_IN;
					nxt_tag_left[index] = tag;
					nxt_valid_left[index] = 1;
					nxt_dirty_left[index] = 0;
					nxt_lru_left[index] = 1;
					nxt_lru_right[index] = 0;
				end
			end
			cif.dREN = 1;
			cif.daddr = dcif.dmemaddr ^ 32'd4;
			if(!cif.dwait)
				nxt_state = IDLE;
		end
		READ_WB_R1: begin
			cif.dWEN = 1;
			cif.daddr = {tag_right[index],index,1'b0,2'b00};
			data_OUT = d1_right[index];
			if(!cif.dwait)
				nxt_state = READ_WB_R2;
			if(cif.ccwait)
				nxt_state = SNOOP;
		end
		READ_WB_R2: begin
			cif.dWEN = 1;
			cif.daddr = {tag_right[index],index,1'b1,2'b00};
			data_OUT = d2_right[index];
			if(!cif.dwait)
				nxt_state = READ_LOAD_R1;
		end
		READ_LOAD_R1: begin
			if(dcif.dmemREN) begin
				if(!cif.dwait) begin
					if(word_sel)
						nxt_d2_right[index] = data_IN;
					else
						nxt_d1_right[index] = data_IN;
				end
			end
			cif.dREN = 1;
			cif.daddr = dcif.dmemaddr;
			if(!cif.dwait)
				nxt_state = READ_LOAD_R2;
			if(cif.ccwait)
				nxt_state = SNOOP;
		end
		READ_LOAD_R2: begin
			if(dcif.dmemREN) begin
				if(!cif.dwait) begin
					if(word_sel)
						nxt_d1_right[index] = data_IN;
					else
						nxt_d2_right[index] = data_IN;
					nxt_tag_right[index] = tag;
					nxt_valid_right[index] = 1;
					nxt_dirty_right[index] = 0;
					nxt_lru_right[index] = 1;
					nxt_lru_left[index] = 0;
				end
			end
			cif.dREN = 1;
			cif.daddr = dcif.dmemaddr ^ 32'd4;
			if(!cif.dwait)
				nxt_state = IDLE;
		end
		WRITE_WB_L1: begin
			cif.dWEN = 1;
			cif.daddr = {tag_left[index],index,1'b0,2'b00};
			data_OUT = d1_left[index];
			if(!cif.dwait)
				nxt_state = WRITE_WB_L2;
			if(cif.ccwait)
				nxt_state = SNOOP;
		end
		WRITE_WB_L2: begin
			cif.dWEN = 1;
			cif.daddr = {tag_left[index],index,1'b1,2'b00};
			data_OUT = d2_left[index];
			if(!cif.dwait)
				nxt_state = WRITE_LOAD1;
		end
		WRITE_LOAD1: begin
			if(dmemWEN) begin
				if(!word_sel) begin
					nxt_d1_left[index] = dcif.dmemstore;
					if(!cif.dwait)
						nxt_d2_left[index] = data_IN;
				end else begin
					nxt_d2_left[index] = dcif.dmemstore;
					if(!cif.dwait)
						nxt_d1_left[index] = data_IN;
				end
				if(!cif.dwait) begin
					nxt_tag_left[index] = tag;
					nxt_valid_left[index] = 1;
					nxt_dirty_left[index] = 1;
					nxt_lru_left[index] = 1;
					nxt_lru_right[index] = 0;
				end
			end
			cif.dWEN = 1;
			if(!word_sel)
				cif.daddr = {tag,index,1'b1,2'b00};
			else
				cif.daddr = {tag,index,1'b0,2'b00};
			if(cif.ccwait)
				nxt_state = SNOOP;
			if(!cif.dwait)
				nxt_state = IDLE;
		end
		WRITE_LEFT: begin
			if(word_sel)
				nxt_d2_left[index] = dcif.dmemstore;
			else
				nxt_d1_left[index] = dcif.dmemstore;
			if(!cif.dwait) begin
				nxt_dirty_left[index] = 1;
				nxt_valid_left[index] = 1;
				nxt_lru_left[index] = 1;
				nxt_lru_right[index] = 0;
			end
			cif.dWEN = 1;
			if(!word_sel)
				cif.daddr = {tag,index,1'b1,2'b00};
			else
				cif.daddr = {tag,index,1'b0,2'b00};
			if(cif.ccwait)
				nxt_state = SNOOP;
			if(!cif.dwait)
				nxt_state = IDLE;
		end
		WRITE_WB_R1: begin
			cif.dWEN = 1;
			cif.daddr = {tag_right[index],index,1'b0,2'b00};
			data_OUT = d1_right[index];
			if(cif.ccwait)
				nxt_state = SNOOP;
			if(!cif.dwait)
				nxt_state = WRITE_WB_R2;
		end
		WRITE_WB_R2: begin
			cif.dWEN = 1;
			cif.daddr = {tag_right[index],index,1'b1,2'b00};
			data_OUT = d2_right[index];
			if(!cif.dwait)
				nxt_state = WRITE_LOAD2;
		end
		WRITE_LOAD2: begin
			if(dmemWEN) begin
				if(!word_sel) begin
					nxt_d1_right[index] = dcif.dmemstore;
					if(!cif.dwait)
						nxt_d2_right[index] = data_IN;
				end else begin
					nxt_d2_right[index] = dcif.dmemstore;
					if(!cif.dwait)
						nxt_d1_right[index] = data_IN;
				end
				if(!cif.dwait) begin
					nxt_tag_right[index] = tag;
					nxt_valid_right[index] = 1;
					nxt_dirty_right[index] = 1;
					nxt_lru_right[index] = 1;
					nxt_lru_left[index] = 0;
				end
			end
			cif.dWEN = 1;
			if(!word_sel)
				cif.daddr = {tag,index,1'b1,2'b00};
			else
				cif.daddr = {tag,index,1'b0,2'b00};
			if(cif.ccwait)
				nxt_state = SNOOP;
			if(!cif.dwait)
				nxt_state= IDLE;
		end
		WRITE_RIGHT: begin
			if(word_sel)
				nxt_d2_right[index] = dcif.dmemstore;
			else
				nxt_d1_right[index] = dcif.dmemstore;
			if(!cif.dwait) begin
				nxt_dirty_right[index] = 1;
				nxt_valid_right[index] = 1;
				nxt_lru_right[index] = 1;
				nxt_lru_left[index] = 0;
			end
			cif.dWEN = 1;
			if(!word_sel)
				cif.daddr = {tag,index,1'b1,2'b00};
			else
				cif.daddr = {tag,index,1'b0,2'b00};
			if(cif.ccwait)
				nxt_state = SNOOP;
			if(!cif.dwait)
				nxt_state = IDLE;
		end
		HALT_WB: begin
			if(dirty_left[l_index])
				nxt_state = HALT_WB_L1;
			else if(dirty_right[l_index])
				nxt_state = HALT_WB_R1;
			else if(l_index == '1)
				nxt_state = HALT;
			else
				nxt_l_index = l_index + 1;
			if(cif.ccwait)
				nxt_state = SNOOP;
		end
		HALT_WB_L1: begin
			cif.dWEN = 1;
			cif.daddr = {tag_left[l_index],l_index,1'b0,2'b00};
			data_OUT = d1_left[l_index];
			if(!cif.dwait)
				nxt_state = HALT_WB_L2;
			if(cif.ccwait)
				nxt_state = SNOOP;
		end
		HALT_WB_L2: begin
			if(!cif.dwait)
				nxt_dirty_left[l_index] = 0;
			cif.dWEN = 1;
			cif.daddr = {tag_left[l_index],l_index,1'b1,2'b00};
			data_OUT = d2_left[l_index];
			if(!cif.dwait)
				nxt_state = HALT_WB;
		end
		HALT_WB_R1: begin
			cif.dWEN = 1;
			cif.daddr = {tag_right[l_index],l_index,1'b0,2'b00};
			data_OUT = d1_right[l_index];
			if(!cif.dwait)
				nxt_state = HALT_WB_R2;
			if(cif.ccwait)
				nxt_state = SNOOP;
		end
		HALT_WB_R2: begin
			if(!cif.dwait)
				nxt_dirty_right[l_index] = 0;
			cif.dWEN = 1;
			cif.daddr = {tag_right[l_index],l_index,1'b1,2'b00};
			data_OUT = d2_right[l_index];
			if(!cif.dwait)
				nxt_state = HALT_WB;
		end
		HALT: begin
			if(cif.ccwait)
				nxt_state = HALT_SNOOP;
			dcif.flushed = 1;
		end
		HALT_SNOOP: begin
			if(!cif.dwait) begin
				if(cc_tag == tag_left[cc_index] && valid_left[cc_index] && dirty_left[cc_index])
					nxt_dirty_left[cc_index] = 0;
		    	if(cc_tag == tag_right[cc_index] && valid_right[cc_index] && dirty_right[cc_index])
					nxt_dirty_right[cc_index] = 0;
			end
			if(cc_tag == tag_left[cc_index] && valid_left[cc_index] && cif.ccinv)
				nxt_valid_left[cc_index] = 0;
			if(cc_tag == tag_right[cc_index] && valid_right[cc_index] && cif.ccinv)
				nxt_valid_right[cc_index] = 0;
			if(!cif.ccwait)
				nxt_state = HALT;
			if(cc_tag == tag_left[cc_index] & valid_left[cc_index]) begin
				if(!cc_select)
					data_OUT = d1_left[cc_index];
				else
					data_OUT = d2_left[cc_index];
			end else if(cc_tag == tag_right[cc_index] & valid_right[cc_index]) begin
				if(!cc_select)
					data_OUT = d1_right[cc_index];
				else
					data_OUT = d2_right[cc_index];
			end
			if (cif.ccsnoopaddr ^ {{29'b0},1'b1,{2'b0}} == linkreg && cif.ccinv && dcif.datomic) begin
				nxt_link_v <= 1'b0;
			end
		end
		SNOOP: begin
			if(!cif.dwait) begin
				if(cc_tag == tag_left[cc_index] && valid_left[cc_index] && dirty_left[cc_index])
					nxt_dirty_left[cc_index] = 0;
				if(cc_tag == tag_right[cc_index] && valid_right[cc_index] && dirty_right[cc_index])
					nxt_dirty_right[cc_index] = 0;
			end
			if(cc_tag == tag_left[cc_index] && valid_left[cc_index] && cif.ccinv)
				nxt_valid_left[cc_index] = 0;
			if(cc_tag == tag_right[cc_index] && valid_right[cc_index] && cif.ccinv)
				nxt_valid_right[cc_index] = 0;
			if(!cif.ccwait)
				nxt_state = IDLE;
			if(cc_tag == tag_left[cc_index] & valid_left[cc_index]) begin
				if(!cc_select)
					data_OUT = d1_left[cc_index];
				else
					data_OUT = d2_left[cc_index];
			end else if(cc_tag == tag_right[cc_index] & valid_right[cc_index]) begin
				if(!cc_select)
					data_OUT = d1_right[cc_index];
				else
					data_OUT = d2_right[cc_index];
			end
			if (cif.ccsnoopaddr ^ {{29'b0},1'b1,{2'b0}} == linkreg && cif.ccinv && dcif.datomic)
				nxt_link_v <= 1'b0;
		end
	endcase
	end
endmodule

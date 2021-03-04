
// interface include
`include "caches_if.vh"
`include "datapath_cache_if.vh"

// CPU types
`include "cpu_types_pkg.vh"

module icache(
	input logic CLK, nRST,
	datapath_cache_if dpif,
	caches_if.icache cif 
	);
	
	import cpu_types_pkg::*;
	icachef_t imemaddr;
	
	logic [15:0] valid;
	logic valid_nxt;
	logic [15:0][25:0] tag;
	logic [25:0] tag_nxt;
	logic [15:0][31:0] block;
	logic [31:0] block_nxt;
	logic ihit;
 	
	assign imemaddr=dpif.imemaddr; //input from datapath
	//assign dpif.imemload = block[imemaddr.idx]; //instruction loaded 
	assign cif.iaddr = imemaddr; //sent addr to memory
	assign dpif.imemload = block[imemaddr.idx];
	//assign dpif.ihit = ihit && !dpif.dmemREN && !dpif.dmemWEN;

	//assign dpif.ihit = (tag[imemaddr.idx]==imemaddr.tag) && valid[imemaddr.idx] && dpif.imemREN ? 1'b1:1'b0; //ihit

	typedef enum logic [2:0] {IDLE, FETCH, MISS} StateType;
        StateType state,  state_nxt; 

	int ind = 0;
	always_ff @(posedge CLK, negedge nRST) begin
		if (!nRST) begin
			state <= IDLE;
			valid <= '0;
			tag <= '0;
			block <= '0;
		end
		else begin
			state <= state_nxt;
			valid[imemaddr.idx] <= valid_nxt;
			tag[imemaddr.idx] <= tag_nxt;
			block[imemaddr.idx] <= block_nxt;
		end		
	end

	always_comb begin
		state_nxt = state;
		valid_nxt = valid[imemaddr.idx];
		tag_nxt = tag[imemaddr.idx];
		block_nxt = block[imemaddr.idx];
		cif.iREN = 1'b0;
		dpif.ihit = 1'b0;
		
		case (state)
			IDLE: begin
				if ((tag[imemaddr.idx]==imemaddr.tag) && valid[imemaddr.idx] && dpif.imemREN) begin
					state_nxt = FETCH;
				end
				else
					state_nxt = MISS;
			end
			FETCH: begin
				dpif.ihit = !dpif.dmemREN && !dpif.dmemWEN;
				state_nxt = IDLE;
				/*dpif.imemload = block[imemaddr.idx];*/			
			end
			MISS: begin
				cif.iREN = 1'b1; //enable memory
				valid_nxt = 1'b1;
				tag_nxt = imemaddr.tag;
				block_nxt = cif.iload;
				if (!cif.iwait) begin
					/*valid_nxt = 1'b1;
					tag_nxt = imemaddr.tag;
					block_nxt = cif.iload;	*/				
					state_nxt = FETCH;
				end
				else 
					state_nxt = MISS;					
			end
		endcase
	end
endmodule 

/*
// interface include
`include "caches_if.vh"
`include "datapath_cache_if.vh"

// CPU types
`include "cpu_types_pkg.vh"

module icache(
	input logic CLK, nRST,
	datapath_cache_if dcif,
	caches_if.caches cif 
	);
	
	import cpu_types_pkg::*;
	icachef_t imemaddr;
	
	logic [15:0] valid;
	logic valid_nxt;
	logic [15:0][25:0] tag;
	logic [25:0] tag_nxt;
	logic [15:0][31:0] block;
	logic [31:0] block_nxt;
 	
	assign imemaddr=dpif.imemaddr; //input from datapath
	//assign dpif.imemload = block[imemaddr.idx]; //instruction loaded 
	assign cif.iaddr = imemaddr; //sent addr to memory

	//assign dpif.ihit = (tag[imemaddr.idx]==imemaddr.tag) && valid[imemaddr.idx] && dpif.imemREN ? 1'b1:1'b0; //ihit

	typedef enum logic [2:0] {IDLE, FETCH, MISS} StateType;
        StateType state,  state_nxt; 

	int ind = 0;
	always_ff @(posedge CLK, negedge nRST) begin
		if (!nRST) begin
			state <= IDLE;
			valid <= '0;
			for (ind = 0; ind < 16; ind++) begin
				tag[ind] <= '0;
				block[ind] <= '0;
			end
		end
		else begin
			state <= state_nxt;
			valid[imemaddr.idx] <= valid_nxt;
			tag[imemaddr.idx] <= tag_nxt;
			block[imemaddr.idx] <= block_nxt;
		end		
	end

	always_comb begin
		state_nxt = state;
		valid_nxt = valid[imemaddr.idx];
		tag_nxt = tag[imemaddr.idx];
		block_nxt = block[imemaddr.idx];
		cif.iREN = 1'b0;
		dpif.ihit = 1'b0;
		
		case (state)
			IDLE: begin
				if ((tag[imemaddr.idx]==imemaddr.tag) && valid[imemaddr.idx] && dpif.imemREN) begin
					state_nxt = FETCH;
				end
				else
					state_nxt = MISS;
			end
			FETCH: begin
				dpif.ihit = 1'b1;
				state_nxt = IDLE;
				dpif.imemload = block[imemaddr.idx];			
			end
			MISS: begin
				cif.iREN = 1'b1; //enable memory
				if (!cif.iwait) begin
					valid_nxt = 1'b1;
					tag_nxt = imemaddr.tag;
					block_nxt = cif.iload;					
					state_nxt = FETCH;
				end
				else 
					state_nxt = MISS;					
			end
		endcase
	end
endmodule */


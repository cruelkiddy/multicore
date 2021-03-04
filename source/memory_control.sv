// interface include
`include "cache_control_if.vh"


// memory types
`include "cpu_types_pkg.vh"

module memory_control (
		       input CLK, nRST,
		       cache_control_if.cc ccif
		       );
   // type import
   import cpu_types_pkg::*;

   //declaration
   logic 			     instr, instr_nxt;


   logic dREN_m,dwait_m;//dcache

   word_t final_iaddr, daddr_m;
   logic final_iREN;//icache
     
   assign ccif.ramREN = ((final_iREN && !ccif.ramWEN) || dREN_m); 
   assign ccif.ramaddr = (dREN_m|| ccif.ramWEN) ? daddr_m : final_iaddr;  
   assign dwait_m = (ccif.ramstate == ACCESS) ? ((dREN_m)? 0 : ((ccif.ramWEN) ? 0 : 1)):1;

   //mem to cache
   assign ccif.iload[0] = ccif.ramload;
   assign ccif.iload[1] = ccif.ramload;

	typedef enum logic [4:0] {IDLE, READ0, WRITE0, READ1, WRITE1, C2C_RD0, MEM2C_RD0, WRITECA0, READCA0, READ_MEM0, WRITE_BACK0, BusRdx0, WRITE_NEW0, C2C_RD1, MEM2C_RD1, WRITECA1, READCA1, RREAD_MEM1, WRITE_BACK1, BusRdx1, WRITE_NEW1} cstate;
   cstate state, n_state;

   logic 	arb, arb_nxt;
   assign ccif.ccsnoopaddr[0] = ccif.daddr[1];
   assign ccif.ccsnoopaddr[1] = ccif.daddr[0];
   
   always_ff @(posedge CLK, negedge nRST)  begin   
	if(!nRST)begin
	     state <= IDLE;
	     arb <= 0;
	end else begin
	     state <= n_state;
	     arb <= arb_nxt;
	  end
     end 

   
   
   always_comb begin
     
	ccif.ccwait = 0;
	ccif.ccinv = 0;
	ccif.dload = 0;
	dREN_m= 0;
	ccif.ramWEN = 0;
	daddr_m = 0;
	ccif.ramstore = 0;
	ccif.dwait = '1;
	
	n_state = state;
	arb_nxt = arb;

	case(state)
	  IDLE: begin	    
	       if(!arb) begin		 
		    if(ccif.dREN[0]) begin		      
			 n_state = READ0;
			 ccif.ccwait[1] = 1;
			 arb_nxt = 1;		      
		    end else if(ccif.dWEN[0]) begin		      
			 n_state = WRITE0;
			 ccif.ccwait[1] = 1;
			 arb_nxt = 1;		      
		    end else if(ccif.dREN[1]) begin		      
			 n_state = READ1;
			 ccif.ccwait[0] = 1;
			 arb_nxt = 0;		      
		    end else if(ccif.dWEN[1]) begin
			 n_state = WRITE1;
			 ccif.ccwait[0] = 1;
			 arb_nxt = 0;
		    end
	       end else begin
		    if(ccif.dREN[1])begin		      
			 n_state = READ1;
			 ccif.ccwait[0] = 1;
			 arb_nxt = 0;		      
		    end else if(ccif.dWEN[1]) begin		      
			 n_state = WRITE1;
			 ccif.ccwait[0] = 1;
			 arb_nxt = 0;		      
		    end else if(ccif.dREN[0]) begin		      
			 n_state = READ0;
			 ccif.ccwait[1] = 1;
			 arb_nxt = 1;		      
		    end else if(ccif.dWEN[0]) begin		      
			 n_state = WRITE0;
			 ccif.ccwait[1] = 1;
			 arb_nxt = 1;
		    end
		end
	    end 
	  READ0: begin	    
	       arb_nxt = 1;
	       ccif.ccwait[1] = 1;
	       if((ccif.cctrans[1] && ccif.ccwrite[1]) || (ccif.cctrans[1] && !ccif.ccwrite[1]))
		 n_state = C2C_RD0;
	       else
		 n_state = MEM2C_RD0;
	  end 
	  C2C_RD0: begin	    
	       ccif.ccwait[1] = 1;
	       if(ccif.cctrans[1] && ccif.ccwrite[1]) begin		 
		    ccif.ramWEN = 1;
		    daddr_m = ccif.ccsnoopaddr[1];
		    ccif.ramstore = ccif.dstore[1];
		    if(!dwait_m) begin		      
			 n_state = WRITECA0;
			 ccif.dwait[0] = 0;
			 ccif.dload[0] = ccif.dstore[1];
			 ccif.dwait[1] = 0;
		   end
	       end 
	       else begin		 
		    ccif.dwait[0] = 0;
		    ccif.dload[0] = ccif.dstore[1];
		    n_state = READCA0;
	       end
	  end
	  WRITECA0: begin	    
	       ccif.ccwait[1] = 1;
	       ccif.ramWEN = 1;
	       daddr_m = ccif.ccsnoopaddr[1];
	       ccif.ramstore = ccif.dstore[1];
	       if(!dwait_m) begin		 
		    n_state = IDLE;
		    ccif.dwait[1] = 0;
		    ccif.dwait[0] = 0;
		    ccif.dload[0] = ccif.dstore[1];
	       end
	  end 
	  READCA0:begin 
	       ccif.ccwait[1] = 1;
	       ccif.dwait[0] = 0;
	       ccif.dload[0] = ccif.dstore[1];
	       n_state = IDLE;
	       ccif.ccwait[1] = 0;
	  end
	  MEM2C_RD0: begin
	       dREN_m= 1;
	       daddr_m = ccif.daddr[0];
	       if(!dwait_m) begin		 
		    ccif.dload[0] = ccif.ramload;
		    ccif.dwait[0] = 0;
		    n_state = READ_MEM0;
	       end
	  end 
	  READ_MEM0: begin  
	       dREN_m= 1;
	       daddr_m = ccif.daddr[0];
	       if(!dwait_m) begin
		    ccif.dload[0] = ccif.ramload;
		    ccif.dwait[0] = 0;
		    n_state = IDLE;
	       end
	  end 
	  WRITE0: begin  
	       arb_nxt = 1;
	       ccif.ccwait[1] = 1;
	       if((ccif.cctrans[0] && ccif.ccwrite[0]))
		  n_state = WRITE_BACK0;
	       else
		  n_state = BusRdx0;
	  end
	  BusRdx0: begin 
	       ccif.ccwait[1] = 1;
	       if(((ccif.cctrans[1] && ccif.ccwrite[1]) || (ccif.cctrans[1] && !ccif.ccwrite[1])) && (!ccif.cctrans[0] && !ccif.ccwrite[0])) begin
		    ccif.dload[0] = ccif.dstore[1];
		    ccif.dwait[1] = 0;
		    ccif.dwait[0] = 0;
		    ccif.ccinv[1] = 1;
		    n_state = IDLE;
		 
	       end else if(ccif.cctrans[0] && !ccif.ccwrite[0]) begin	 
		    ccif.dwait[0] = 0;
		    ccif.ccinv[1] = 1;
		    n_state = IDLE;
		 
	       end else if((!ccif.cctrans[0] && !ccif.ccwrite[0]) && (!ccif.cctrans[1] && !ccif.ccwrite[1])) begin		 
		    dREN_m= 1;
		    daddr_m = ccif.daddr[0];
		    if(!dwait_m) begin
			 ccif.dload[0] = ccif.ramload;
			 ccif.dwait[0] = 0;
			 n_state = IDLE;
		    end
	       end 
	  end 
	  WRITE_BACK0: begin  
	       ccif.ramWEN = 1;
	       ccif.ramstore = ccif.dstore[0];
	       daddr_m = ccif.daddr[0];
	       if(!dwait_m) begin	 
		    n_state = WRITE_NEW0;
		    ccif.dwait[0] = 0;
	       end
	  end 
	  WRITE_NEW0: begin   
	       ccif.ramWEN = 1;
	       ccif.ramstore = ccif.dstore[0];
	       daddr_m = ccif.daddr[0];
	       if(!dwait_m) begin		 
		    n_state = IDLE;
		    ccif.dwait[0] = 0;
	       end
	    end 
	  
	  //Cache 1
	  READ1: begin	    
	       arb_nxt = 0;
	       ccif.ccwait[0] = 1;
	       if((ccif.cctrans[0] && ccif.ccwrite[0]) || (ccif.cctrans[0] && !ccif.ccwrite[0]))
		 n_state = C2C_RD1;
	       else
		 n_state = MEM2C_RD1;
	  end
	  C2C_RD1: begin 
	       ccif.ccwait[0] = 1;
	       if(ccif.cctrans[0] && ccif.ccwrite[0]) begin	 
		    ccif.ramWEN = 1;
		    daddr_m = ccif.ccsnoopaddr[0];
		    ccif.ramstore = ccif.dstore[0];
		    if(!dwait_m) begin  
			 n_state = WRITECA1;
			 ccif.dwait[1] = 0;
			 ccif.dwait[0] = 0;
			 ccif.dload[1] = ccif.dstore[0];
		    end
	       end else begin		 
		    ccif.dwait[1] = 0;
		    ccif.dload[1] = ccif.dstore[0];
		    n_state = READCA1;
	       end
	  end
	  WRITECA1: begin	    
	       ccif.ccwait[0] = 1;
	       ccif.ramWEN = 1;
	       daddr_m = ccif.ccsnoopaddr[0];
	       ccif.ramstore = ccif.dstore[0];
	       if(!dwait_m) begin	 
		    n_state = IDLE;
		    ccif.dwait[0] = 0;
		    ccif.dwait[1] = 0;
		    ccif.dload[1] = ccif.dstore[0];
	       end
	  end 
	  READCA1: begin	    
	       ccif.ccwait[0] = 1;
	       ccif.dwait[1] = 0;
	       ccif.dload[1] = ccif.dstore[0];
	       n_state = IDLE;
	       ccif.ccwait[0] = 0;
	  end
	  MEM2C_RD1: begin	    
	       dREN_m= 1;
	       daddr_m = ccif.daddr[1];
	       if(!dwait_m) begin		 
		    ccif.dload[1] = ccif.ramload;
		    ccif.dwait[1] = 0;
		    n_state = RREAD_MEM1;
	       end
	  end 
	  RREAD_MEM1: begin	    
	       dREN_m= 1;
	       daddr_m = ccif.daddr[1];
	       if(!dwait_m) begin		 
		    ccif.dload[1] = ccif.ramload;
		    ccif.dwait[1] = 0;
		    n_state = IDLE;
	       end
	  end 
	  WRITE1:begin	    
	       arb_nxt = 1;
	       ccif.ccwait[0] = 1;
	       if((ccif.cctrans[1] && ccif.ccwrite[1]))
		 n_state = WRITE_BACK1;
	       else
		 n_state = BusRdx1;
	  end
	  BusRdx1: begin	    
	       ccif.ccwait[0] = 1;
	       if(((ccif.cctrans[0] && ccif.ccwrite[0]) || (ccif.cctrans[0] && !ccif.ccwrite[0])) && (!ccif.cctrans[1] && !ccif.ccwrite[1])) begin		 
		    ccif.dload[1] = ccif.dstore[0];
		    ccif.dwait[1] = 0;
		    ccif.dwait[0] = 0;
		    ccif.ccinv[0] = 1;
		    n_state = IDLE;
		
	       end else if(ccif.cctrans[1] && !ccif.ccwrite[1]) begin
		    ccif.dwait[1] = 0;
		    ccif.ccinv[0] = 1;
		    n_state = IDLE;
		 
	       end else if((!ccif.cctrans[1] && !ccif.ccwrite[1]) && (!ccif.cctrans[0] && !ccif.ccwrite[0])) begin		 
		    dREN_m= 1;
		    daddr_m = ccif.daddr[1];
		    if(!dwait_m) begin		      
			 ccif.dload[1] = ccif.ramload;
			 ccif.dwait[1] = 0;
			 n_state = IDLE;
		      end
		 end 
	  end 
	  WRITE_BACK1:begin	    
	       ccif.ramWEN = 1;
	       ccif.ramstore = ccif.dstore[1];
	       daddr_m = ccif.daddr[1];
	       if(!dwait_m)begin		 
		    n_state = WRITE_NEW1;
		    ccif.dwait[1] = 0;
	       end
	  end 
	  WRITE_NEW1: begin	    
	       ccif.ramWEN = 1;
	       ccif.ramstore = ccif.dstore[1];
	       daddr_m = ccif.daddr[1];
	       if(!dwait_m) begin		
		    n_state = IDLE;
		    ccif.dwait[1] = 0;
	       end
	    end
	endcase 
     end
   
   //insturction
   always_ff @(posedge CLK, negedge nRST) begin    
	if(!nRST)
	  instr <= 0;
	else
	  instr <= instr_nxt;
     end
   
   always_comb begin   
	instr_nxt = instr;
	final_iaddr = 0;
	final_iREN = 0;
	ccif.iwait = '1;

	if(ccif.iREN[1] && ccif.iREN[0]) begin	  
	     if(instr) begin	      
		  final_iaddr = ccif.iaddr[1];
		  if((ccif.ramstate == ACCESS) && (ccif.iREN[1] == 1) && (ccif.ramWEN == 0) && (dREN_m== 0)) begin		   
		       instr_nxt = 0;
		       ccif.iwait[1] = 0;
		  end
	       
	     end else begin	       
		  final_iaddr = ccif.iaddr[0];
		  if((ccif.ramstate == ACCESS) && (ccif.iREN[0] == 1) && (ccif.ramWEN == 0) && (dREN_m== 0)) begin		   
		       instr_nxt = 1;
		       ccif.iwait[0] = 0;
		  end
	       end
	     final_iREN = 1;
	  end
	else if(ccif.iREN[0]) begin	  
	     final_iREN = 1;
	     final_iaddr = ccif.iaddr[0];
	     if((ccif.ramstate == ACCESS) && (ccif.iREN[0] == 1) && (ccif.ramWEN == 0) && (dREN_m== 0)) begin	       
		  instr_nxt = 1;
		  ccif.iwait[0] = 0;
	     end
	  
	end else if(ccif.iREN[1]) begin	  
	     final_iREN = 1;
	     final_iaddr = ccif.iaddr[1];
	     if((ccif.ramstate == ACCESS) && (ccif.iREN[1] == 1) && (ccif.ramWEN == 0) && (dREN_m== 0)) begin	       
		  instr_nxt = 0;
		  ccif.iwait[1] = 0;
	     end
	end
     end   
endmodule

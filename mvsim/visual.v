/*
Function:
 Running XOR of a stream of bytes.
 Number of bytes indicated by first byte (not included in XOR).
 Eg:
 Bytestream: 0x04,0x16,0x5,0x8,0xFF,    0x3,0x44,0x76,0x65
              ^     <----------->       <-- Next set of 3 bytes->
              |           |     |
             Number  XOR these  |
             bytes   4 bytes    |
                                |-> Push to output fifo                  
*/

module xorexec #(parameter int dwidth=8)
   ( input logic clk, rst,

     //ififo interface
     output logic  ififo_pop,
     input  logic ififo_rdy,
     input  logic [dwidth-1:0] idata,

     //ofifo interface
     input  logic  ofifo_not_full,
     output logic ofifo_push,
     output logic [dwidth-1:0] odata,

     output logic exec_idle
     );

/*
Pseudocode:
 1. If entry in ififo (indicated by ififo_rdy), pop & load into byte_cnt
 2. Loop byte_cnt times, popping data from ififo and XORing
 3. Push result to output fifo
*/
   logic [7:0] byte_cnt_wd, byte_cnt_rd;
   logic pop_wc, pop_rc ;
   logic push_wc, push_rc ;
   logic [2:0] fsm_cs, fsm_nxt ;
   logic [7:0] odata_wd, odata_rd ;

   assign      ofifo_push = push_rc ;
   assign      ififo_pop = pop_rc;
   assign      odata = odata_rd;

   localparam int init=0,load_cnt=1,proc_data=2,wait_data=3,push_result=4;

   assign      exec_idle = ( fsm_cs == init );
   
   always @*
     begin
	pop_wc = 0;
	push_wc = 0;
	byte_cnt_wd = byte_cnt_rd;
	fsm_nxt = fsm_cs ;
	
	case (fsm_cs)
	  init : 
	  if ( ififo_rdy )
	    begin
	       pop_wc = 1 ;
	       odata_wd = 0;
	       fsm_nxt = load_cnt;
	    end

	  load_cnt: begin
	     //load count and pop next data word
	     byte_cnt_wd = idata ;
	     if ( ififo_rdy )
	      begin
		 pop_wc = 1;
		 fsm_nxt = proc_data;
	      end
	     else
	       fsm_nxt = wait_data ;
	  end

	  proc_data: //
	    //Decrement cnt, XOR next data byte from ififo
	    //do until count reaches 1.
	    begin
	       byte_cnt_wd = byte_cnt_rd - 8'h1 ;
	       odata_wd = odata_rd ^ idata ;

	       if ( byte_cnt_rd == 1 )
		 begin
		    fsm_nxt = push_result ;
		 end
	       else
		 if ( ififo_rdy )
		   begin
		      pop_wc = 1;
		   end
		 else
		   fsm_nxt = wait_data ;

	    end // case: s2

	  wait_data:
	    if ( ififo_rdy )
	      begin
		 pop_wc = 1;
		 fsm_nxt = proc_data;
	      end

	  push_result:
	    begin
	       //Push result to output fifo
	       //stay in this state if fifo is full,
	       //waiting for a free entry.
	       if ( ofifo_not_full )
		 begin
		    push_wc = 1;
		    if ( ififo_rdy )
		      begin
			 pop_wc = 1;
			 fsm_nxt = load_cnt;
		      end
		    else
		      fsm_nxt = init   ;
		 end
	    end // case: s2
	  
	endcase // case(fsm_cs)
     end // always @ *
   
//Infer registers
always @(posedge clk)
  if (rst)
    begin
       pop_rc <= 0;
       push_rc <= 0;
       byte_cnt_rd <= 0;
       odata_rd <= 0;
       fsm_cs <= init;
    end
  else
    begin
       pop_rc <= pop_wc ;
       push_rc <= push_wc;
       byte_cnt_rd <= byte_cnt_wd;
       odata_rd <= odata_wd;
       fsm_cs <= fsm_nxt;
    end
   
endmodule // xorexec
//----------------------------------------------
//----------------------------------------------
// SVA assumptions and cover properties to
// visualize RTL
//----------------------------------------------
module xorexec_sva #(parameter int dwidth=8)
   ( input clk, rst,

     //ififo interface
     input ififo_pop,
     input ififo_rdy,
     input [dwidth-1:0] idata,

     //ofifo interface
     input ofifo_not_full,
     input ofifo_push,
     input [dwidth-1:0] odata,

     input [1:0] fsm_cs 
     );

default clocking cb @(posedge clk);  endclocking

//If ififo_pop is active, ififo_rdy should be true
as_ififo_data: assume property ( idata >= 8'h4 );
as_ififo_pop: assume property ( disable iff(rst) ififo_pop |-> ififo_rdy  );
//as_ofifo_not_full: assume property( disable iff(rst) ofifo_push |-> (fsm_cs_2_cnt == 4) );
   
logic [3:0] fsm_cs_2_cnt ;
   
always @(posedge clk)
  if (rst)
    fsm_cs_2_cnt <= 0;
  else
    if ( fsm_cs == 2 )
      fsm_cs_2_cnt <= fsm_cs_2_cnt + 1;
    
cp_push: cover property ( disable iff(rst) ofifo_push |-> (fsm_cs_2_cnt == 4) );
endmodule // xorexec

bind xorexec xorexec_sva sva_inst( .* );
//------------------------------------------------
//------------------------------------------------
analyze -clear
analyze -sva top_xorexec.v hfifo.v xorexec.v
analyze -sva top_xorexec_sva.sv

elaborate -top top_xorexec

clock clk
reset rst

prove -bg -all
//------------------------------------------------
//------------------------------------------------  

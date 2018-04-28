//------------------------------------------------------------
//------------------------------------------------------------
`timescale 1ns/1ns

module tb ;

`ifdef UPF_1_0
   import UPF::*;
`endif
   
   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg clk ;
   reg		[7:0]	idata;			// To dut of top_xorexec.v
   reg			ififo_push;		// To dut of top_xorexec.v
   reg			ofifo_pop;		// To dut of top_xorexec.v
   reg			rst;			// To dut of top_xorexec.v
   // End of automatics
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			ififo_not_full;		// From dut of top_xorexec.v
   wire		[7:0]	odata;			// From dut of top_xorexec.v
   wire			ofifo_rdy;		// From dut of top_xorexec.v
   // End of automatics

   //clkgen
   initial clk=0;
   always #5 clk = ~clk ;

   reg 			pwr_on ;
   
   initial
     begin
	$vcdpluson;
	pwr_on = 1;
	
	rst = 1;
	ififo_push =0;
	ofifo_pop = 0;
	idata = 0;
	
	#100;
	rst = 0;
	#100;

	send_xaction;

	#10000;

	send_xaction;	

	#10000;
	
	$finish;
	
     end
   
   top_xorexec dut(/*AUTOINST*/
		   // Outputs
		   .pwr_on              (pwr_on),
		   .ififo_not_full	(ififo_not_full),
		   .ofifo_rdy		(ofifo_rdy),
		   .odata		(odata),
		   // Inputs
		   .clk                 (clk),
		   .rst			(rst),
		   .ififo_push		(ififo_push),
		   .idata		(idata),
		   .ofifo_pop		(ofifo_pop));


   always @(posedge clk)
     if ( !rst & ofifo_rdy )
       ofifo_pop <= 1;
     else
       ofifo_pop <= 0;

   integer 		num ;
   
   task send_xaction ;
      num = $random() % 8 ;
      
      @(posedge clk);
      ififo_push <= 0;
      
      if ( ififo_not_full )
	begin
	   idata <= num ;
	   ififo_push <= 1;
	end

      repeat(num)
	begin
	   @(posedge clk);
	   if ( ififo_not_full )
	     begin
		idata <= $random();
		ififo_push <= 1;
	     end
	end
      @(posedge clk);
      ififo_push <= 0;
      
   endtask // send_
   
endmodule // tb
//------------------------------------------------------------
//------------------------------------------------------------
  module top_xorexec #(parameter int dwidth=8)
   (
    //clk and rst (active high)
    input clk,rst,
    
    //ififo interface
    input ififo_push,
    output ififo_not_full,
    input [7:0] idata,

    input pwr_on ,
    
    //ofifo interface
    input ofifo_pop,
    output ofifo_rdy,
    output [7:0] odata
    
    );

   logic [7:0] exec_idata , exec_odata ;
   wire 	 pwr_down ,pwron_reset;
   
   hfifo #(.size(8), .dwidth(8)) ififo (
	       .clk			(clk),
	       .reset			(rst),
	       
	       //output interface to exec unit
	       .dout			(exec_idata[dwidth-1:0]),
	       .rdy			(exec_rdy),
	       .pop			(exec_pop),

               //input interface
	       .not_full		(ififo_not_full),
	       .din			(idata[dwidth-1:0]),
	       .push			(ififo_push)
	       );

   hfifo #(.size(8), .dwidth(8)) ofifo(
	       .clk			(clk),
	       .reset			(rst),
	       
	       // Outputs
	       .dout			(odata[dwidth-1:0]),
	       .rdy			(ofifo_rdy),
	       .pop			(ofifo_pop),
	       .not_full		(exec_not_full),
	       
	       // push interface from exec unit
	       .din			(exec_odata[dwidth-1:0]),
	       .push			(exec_push)
	       );

   xorexec exec_unit(
		     // Outputs
		     .ififo_pop		(exec_pop),
		     .ofifo_push	(exec_push),
		     .odata		(exec_odata),
		     // Inputs
		     .clk               (clk),
		     .rst		(rst | pwron_reset),
		     .ififo_rdy		(exec_rdy),
		     .idata		(exec_idata),
		     .ofifo_not_full	(exec_not_full),
		     .exec_idle         (exec_idle)
		     );

   pmu pmu_i (
	      // Outputs
	      .pwr_down			(pwr_down),
	      .iso_enable		(iso_enable),
	      .pwron_reset              (pwron_reset),

	      // Inputs
	      .clk                      (clk),
	      .rst			(rst),
	      .ififo_rdy		(exec_rdy),
	      .exec_idle		(exec_idle));
   
endmodule // top_xorexec
//------------------------------------------------------------
//------------------------------------------------------------
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
//------------------------------------------------------------
//------------------------------------------------------------
//Power management unit
//Turns power off to execution unit if
//1. Exec unit is in Idle state AND 
//2. Input fifo has been empty for IDLE_LIMIT or more cycles
//   IDLE_LIMIT < 16
//
//Turns power back on, once entry shows up in input fifo
//

module pmu #(parameter int IDLE_LIMIT=10 )
  ( input clk ,
    input rst ,
    input ififo_rdy,
    input exec_idle,
    output logic pwr_down,
    output logic iso_enable
    );

   localparam init=0,start_cntdown=1,begin_pwrdown=2,pwroff=3;
   
   logic iso_enable_wc, iso_enable_rc;
   logic pwr_down_wc, pwr_down_rc;
   logic [2:0] state, next_state;
   logic [4:0] timer_cnt_wc, timer_cnt_rc ;

   assign  pwr_down = pwr_down_rc;
   assign  iso_enable = iso_enable_rc;
   
   always @*
     begin
	//Power control is sticky !
	iso_enable_wc = iso_enable_rc ;
	pwr_down_wc = pwr_down_rc ;
	
	next_state = state ;
	
	case( state ):
	  init:
	  begin
	     iso_enable_wc = 0;
	     pwr_down_wc =0;
	     if ( exec_idle )
	       next_state = start_cntdown ;
	  end

	  start_cntdown: begin
	     if ( ~ififo_rdy && timer_cnt < IDLE_LIMIT )
	       timer_cnt_wc = timer_cnt_rc + 1 ;

	     if (timer_cnt_rc == IDLE_LIMIT)
	       next_state = begin_pwrdown ;
	  end

	  begin_pwrdown: //isolate then poweroff
	    begin
	       iso_enable_wc = 1;
	       if ( ~ififo_rdy )
		 next_state = pwroff ;
	       else
		 next_state = init;
	    end
	  
	  pwroff:
	    begin
	       pwr_down_wc = 1;
	       if ( ififo_rdy )
		 next_state = init ;
	    end

	endcase // case( state )

     end // UNMATCHED !!

   always @(posedge clk)
     if (rst)
       begin
	  iso_enable_rc <= 0;
	  pwr_down_rc <= 0;
	  timer_cnt_rc <= 0;
	  state <= init;
       end
     else
       begin
	  iso_enable_rc <= iso_enable_wc;
	  pwr_down_rc <= pwr_down_wc;
	  timer_cnt_rc <= timer_cnt_wc ;
	  state <= next_state ;
       end
   
endmodule // pmu
//------------------------------------------------------------
//------------------------------------------------------------
`timescale 1ns/1ns

/*
 * Output valid if not_empty is high, use like a valid
 */

module hfifo #(parameter int size=256, dwidth=8 )

   (/*AUTOARG*/
   // Outputs
   dout, rdy, not_full, 
   // Inputs
   clk, reset, din, push, pop
   );

   localparam pwidth = $clog2(size);//log2(size)
   localparam swidth = pwidth + 1 ;//log2(size)+1
   
   input     clk ;
   input     reset;
   input [dwidth-1:0] din;
   input 	      push ;
   input 	      pop;
   
   output [dwidth-1:0] dout;
   output 	       rdy ;
   output 	       not_full ;
   
   reg [dwidth-1:0]    fmem [size-1:0];
   reg [pwidth-1:0]    wr_ptr ;
   reg [pwidth-1:0]    rd_ptr;
   reg [swidth-1:0]    cnt ;
   reg 		       not_empty ;
   reg 		       not_full ;

   wire 	       rdy = not_empty ;
   
   wire [dwidth-1:0]   dout = fmem[rd_ptr];

   always @(cnt or push or pop)
     begin
	not_empty = 0 ;
	if ( cnt != 0 | push)
	  not_empty = 1;

	if (cnt == 1 & pop)
	  not_empty = 0 ;

	not_full = 0;
	if (cnt != size | pop)
	  not_full = 1 ;

	if (cnt == size-1 & push)
	    not_full = 0;
     end
   
   always @(posedge clk or posedge reset)
     if (reset == 1'b1)
       begin
	  wr_ptr <= 0;
	  rd_ptr <= 0;
	  cnt <= 0;
       end
     else
       begin
	  if ( push )
	    begin
	       fmem[wr_ptr] <= din ;
	       wr_ptr <= wr_ptr+1 ;
	    end

	  if ( pop )
	    begin
	       rd_ptr <= rd_ptr+1 ;
	    end

	  case ({push,pop})
	    2'b00: cnt <= cnt ;
	    2'b01: cnt <= cnt-1;
	    2'b10: cnt <= cnt+1;
	    2'b11: cnt <= cnt;
	  endcase // case({push,pop})
       end
   
endmodule // rel_fifo
//------------------------------------------------------------
//------------------------------------------------------------
# Top UPF
set_design_top tb/dut

create_power_domain TOP
create_power_domain EXEC -elements exec_unit

create_supply_port VDD
create_supply_port VSS
create_supply_port VDDG

create_supply_net VDD   -domain TOP
create_supply_net VSS   -domain TOP
create_supply_net VDDG  -domain TOP

create_supply_net VDDG  -domain EXEC -reuse
create_supply_net VSS   -domain EXEC -reuse
#create_supply_net VDDGS -domain TOP
create_supply_net VDDGS -domain EXEC 

connect_supply_net VDD -ports {VDD}
connect_supply_net VSS -ports {VSS}
connect_supply_net VDDG -ports VDDG

set_domain_supply_net TOP   -primary_power_net VDD   -primary_ground_net VSS
set_domain_supply_net EXEC  -primary_power_net VDDGS -primary_ground_net VSS

create_power_switch exec_sw \
  -domain EXEC  \
  -input_supply_port { in VDDG } \
  -output_supply_port { out VDDGS } \
  -control_port { pwr_down pwr_down } \
  -on_state { exec_on_state in  {!pwr_down}}

# ISO
#set_isolation exec_iso_in \
  -domain EXEC \
  -isolation_power_net VDD -isolation_ground_net VSS \
  -clamp_value 0 \
  -applies_to inputs

#set_isolation_control exec_iso_in \
  -domain EXEC \
  -isolation_signal inst_iso_in \
  -isolation_sense high \
  -location parent

set_isolation exec_iso_out \
  -domain EXEC \
  -isolation_power_net VDD -isolation_ground_net VSS \
  -clamp_value 0 \
  -applies_to outputs

set_isolation_control exec_iso_out \
  -domain EXEC \
  -isolation_signal  iso_enable \
  -isolation_sense high \
  -location parent
//--------------------------------------------
//--------------------------------------------
vcs -sverilog -upf top.upf +define+UPF_1_0 -f tb.f -debug_pp 
//--------------------------------------------
//--------------------------------------------

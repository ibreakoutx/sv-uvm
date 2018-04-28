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
    output logic iso_enable,
    output logic pwron_reset
    );

   localparam init=0,start_cntdown=1,begin_pwrdown=2,pwroff=3,pwron=4;
   
   logic iso_enable_wc, iso_enable_rc;
   reg pwr_down_wc, pwr_down_rc;
   logic [2:0] state, next_state;
   logic [4:0] timer_cnt_wc, timer_cnt_rc ;

   assign  iso_enable = iso_enable_rc;
   assign  pwr_down = pwr_down_wc ;
   
   always @*
     begin
	//Power control is sticky !
	iso_enable_wc = iso_enable_rc ;
	pwr_down_wc = pwr_down_rc ;
	pwron_reset = 0;
	
	next_state = state ;
	timer_cnt_wc = timer_cnt_rc ;
	
	case( state )
	  init:
	  begin
	     iso_enable_wc = 0;
	     pwr_down_wc =0;
	     timer_cnt_wc =0;
	     if ( exec_idle )
	       next_state = start_cntdown ;
	  end

	  start_cntdown: begin
	     if ( ififo_rdy )
	       next_state = init ;
	     else
	       begin
		  if ( ~ififo_rdy && timer_cnt_rc < IDLE_LIMIT )
		    timer_cnt_wc = timer_cnt_rc + 1 ;

		  if (timer_cnt_rc == IDLE_LIMIT)
		    next_state = begin_pwrdown ;
	       end
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
	       pwron_reset = 1;
	       if ( ififo_rdy )
		 //Begin pwrup sequence
		 next_state = pwron ;
	    end

	  pwron:
	    begin
	       pwr_down_wc = 0;
	       pwron_reset = 1;
	       next_state = init;
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

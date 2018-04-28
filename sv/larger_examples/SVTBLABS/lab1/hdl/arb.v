/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


module arb ( clk, reset, request, grant);
  input [1:0] request;
  output [1:0] grant;
  input  reset;
  input  clk;

  parameter IDLE = 2, GRANT0 = 0, GRANT1 = 1;

  reg  last_winner;
  reg winner;
  reg [1:0] grant;
  reg [1:0] next_grant;

  reg [1:0] state, nxState;
  
  always @(state or request or last_winner or grant)
  begin
     nxState = state;		// hold state by default  
     winner = last_winner;	// hold its value 
     next_grant = grant;

     case(state)
     IDLE: begin
	next_grant[0] = request[0] & ~(request[1] & ~last_winner);
	next_grant[1] = request[1] & ~(request[0] &  last_winner);
	if(next_grant[0])
	   winner = 1'b0;
	if(next_grant[1])
	   winner = 1'b1;
        if(next_grant[0] == 1'b1)
	   nxState = GRANT0;
	if(next_grant[1] == 1'b1)
	   nxState = GRANT1;
	if(next_grant[1:0] == 2'b11)
	   $display("ERROR: two grants asserted simultaneously");
     end      

     GRANT0: begin
	if(~request[0]) begin
	   next_grant[0] = 1'b0;
	   nxState = IDLE;
        end
     end

     GRANT1: begin
	if(~request[1]) begin
	   next_grant[1] = 1'b0;
	   nxState = IDLE;
	end
     end
     endcase
  end

  always @(posedge clk) begin
     if (reset) begin
        state <= IDLE;
	last_winner <= 1'b0;
	grant <= 2'b00;
     end
     else begin    
        state <= nxState;
        last_winner <= winner;
        grant <= next_grant;
     end
  end

endmodule

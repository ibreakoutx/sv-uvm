/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



module test_top;
  parameter simulation_cycle = 100 ;
  
  reg  SystemClock ;
  wire dsp_clk ;
  assign dsp_clk = SystemClock ;

  test tb(dsp_clk  );

  initial begin
    SystemClock = 0 ;

    forever begin
      #(simulation_cycle/2) 
        SystemClock = ~SystemClock ;
    end
  end

endmodule  

program test (input dsp_clk); 
  int temp;
  `include "Packet.v"

   Packet p2, p = new();

   initial begin
	p2 = new p;
	$display("%0d",p2.child_obj.t);

	temp = p.fact(5);

	$display("%0d \n",temp );
	p.fork_join();
	@(posedge dsp_clk);
   end
endprogram





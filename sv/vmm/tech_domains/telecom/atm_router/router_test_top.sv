/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`timescale 1ns/100ps
module router_test_top;
  parameter simulation_cycle = 100 ;
  reg  SystemClock ;
  router_io top_io(SystemClock);
  test tb(top_io);
  router dut(
    .reset_n ( top_io.reset_n ),
    .clock ( top_io.clock ),
    .frame_n ( top_io.frame_n ),
    .valid_n ( top_io.valid_n ),
    .din ( top_io.din ),
    .dout ( top_io.dout ),
    .busy_n ( top_io.busy_n ),
    .valido_n ( top_io.valido_n ),
    .frameo_n ( top_io.frameo_n )
  );

  initial begin
    $timeformat(-9, 1, "ns", 10);
    $vcdpluson;
    SystemClock = 0 ;
    forever begin
      #(simulation_cycle/2) 
        SystemClock = ~SystemClock ;
    end
  end
  
endmodule  

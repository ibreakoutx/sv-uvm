/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

module arb_test_top;
  parameter clock_cycle = 100 ;
  
  reg clk ;
  wire  reset ;
  wire  [1:0]  request ;
  wire  [1:0]  grant ;

  arb dut(
    .clk ( clk ),
    .reset ( reset ),
    .request ( request ),
    .grant ( grant )
  );

  arb_test testbench( 
    .clk( clk ),
    .reset_p( reset ),
    .request_p( request ),
    .grant_p( grant )
  );

  initial begin
    clk = 1'b0;
    forever begin
      #(clock_cycle/2)
        clk = ~clk ;
    end
  end
endmodule


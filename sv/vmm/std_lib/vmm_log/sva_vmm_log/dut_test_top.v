/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

module dut_test_top;
  parameter simulation_cycle = 100 ;
  
  reg  clk ;

  test u_test (
    .clk ( clk )
  );


  dut dut(
    .clk ( clk )
  );


  initial begin
    clk = 0 ;
    forever begin
      #(simulation_cycle/2) 
        clk = ~clk ;
    end
  end
  
endmodule  

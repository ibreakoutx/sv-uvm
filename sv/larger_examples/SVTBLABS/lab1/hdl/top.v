/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`timescale 1ns/1ns

module arb_top;
  bit  clk;
  always #5 clk = !clk; 

  arb_if arbif(clk); 
  arb a1 (.clk(clk),
          .reset(arbif.reset),
          .request(arbif.request),
          .grant(arbif.grant) );
  test t1(arbif);

endmodule

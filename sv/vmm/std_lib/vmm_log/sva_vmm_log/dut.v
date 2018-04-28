/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

// Goals: filter messages based on origin
//      common format - ERROR
`timescale 1ns/1ns

module dut(clk);
   input clk;
   
   reg 		 parity = 1;
 


   initial
     begin
	#100;
	parity = 0;
	#200;
	parity = 1;
	#1000;
     end // initial begin

   assert_never a1(clk, 1'b1, !parity);
   // Same checker, to illustrate the difference between  common/unique logger
   assert_never a2(clk, 1'b1, !parity);
  
endmodule



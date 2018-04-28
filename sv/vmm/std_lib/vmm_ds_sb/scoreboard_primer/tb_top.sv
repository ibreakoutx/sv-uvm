/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`include "soc_bus.sv"

module tb_top;
   bit clk = 0;

   apb_if m(clk);
   apb_if s0(clk);
   apb_if s1(clk);
   apb_if s2(clk);

   soc_bus dut_slv(.m  (m  ),
                   .s0 (s0 ),
                   .s1 (s1 ),
                   .s2 (s2 ),
                   .clk(clk));

   always #10 clk = ~clk;
endmodule: tb_top

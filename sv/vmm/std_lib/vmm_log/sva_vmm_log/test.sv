/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


program test (input clk);
 `include "vmm.sv"
   
 initial begin
   vmm_log tb_log;

   tb_log = new("Testbench", "top");

   repeat (10000) @(posedge clk);
   tb_log.report();
 end
endprogram

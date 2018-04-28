/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

interface arb_if(input bit clk); 
  logic [1:0] grant, request; 
  logic reset; 

  clocking cb @(posedge clk); 
    output request; 
    input grant; 
  endclocking

  modport DUT (input request, reset,
               output grant);

  modport TEST (clocking cb,
                output reset);

endinterface

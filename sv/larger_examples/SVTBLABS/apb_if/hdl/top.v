/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

/*******************************************************************************
 *
 * File:        $RCSfile: top.v,v $
 * Revision:    $Revision: 1.7 $  
 * Date:        $Date: 2003/07/15 15:18:31 $
 *
 *******************************************************************************
 *
 * Top level SystemVerilog file that instantiates the APB interface, testbench
 * and design under test
 *
 *******************************************************************************
 */

module top;
  parameter simulation_cycle = 100;
  
  bit clk;
  always #(simulation_cycle/2) 
    clk = ~clk;

  apb_if apb(clk); // APB interafce
  test   t1(apb);  // Testbench program
  mem    m1(apb);  // Memory device

endmodule  

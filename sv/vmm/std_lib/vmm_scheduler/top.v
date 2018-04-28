/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

//-----------------------------------------------------------------------------
//
// SYNOPSYS CONFIDENTIAL - This is an unpublished, proprietary work of
// Synopsys, Inc., and is fully protected under copyright and trade secret
// laws. You may not view, use, disclose, copy, or distribute this file or
// any information contained herein except pursuant to a valid written
// license from Synopsys.
//
//-----------------------------------------------------------------------------
//
// Filename    : $Id: top.v,v 1.5 2005/10/27 16:06:08 alexw Exp $
//
// Created by  : Synopsys Inc. 09/01/2004
//               $Author: alexw $
//
// Description : APB Testbench vmm_environment class
//
// This class instantiates all the permanent testbench top-level components
//
// After all the labs have been completed, this will include:
//   * APB Atomic Generator
//   * APB Master
//   * APB Monitor
//   * Scoreboard
//
//-----------------------------------------------------------------------------

module top;
  parameter simulation_cycle = 100;
  
  bit clk;
  always #(simulation_cycle/2)
    clk = ~clk;

  apb_if apb(clk);                     // APB interafce
  test   t1(apb);                      // Testbench program
  mem    m1(apb);                      // Memory device

  initial $vcdpluson();                // Dump Waves
   
endmodule  

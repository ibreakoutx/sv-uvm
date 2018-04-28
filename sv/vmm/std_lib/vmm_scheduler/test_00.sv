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
// Filename    : $Id: test_04.sv,v 1.4 2005/10/27 16:09:06 alexw Exp $
//
// Created by  : Synopsys Inc. 09/01/2004
//               $Author: alexw $
//
// Description : Simple Test, run all steps
//
//-----------------------------------------------------------------------------

`include "apb_if.sv"

program test(apb_if ifc);

`include "vmm.sv"
`include "apb_cfg.sv"
`include "apb_trans.sv"
`include "apb_master.sv"
  `include "my_scheduler_election.sv"
`include "dut_env.sv"

  dut_env env;                     // DUT Environment

  initial begin
    env = new(ifc);                // Create the environment
    env.build();                   // Build the environment 
    env.gen2mas.tee_mode(1);       // Enable Tee mode for thread below
    env.run();                     // Run all steps
  end 

  // Tee all elements from the generator, and print them
  initial fork
    forever begin
      apb_trans tr;
      env.gen2mas.get(tr); // since no consumer use get vs. sink for proper DONE indicator
      tr.display("To Mst ==> ");
    end
  join_none

  
endprogram

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
`include "my_apb_scenario.sv"
`include "apb_gen.sv"
`include "apb_master.sv"
`include "my_scheduler_election.sv"
`include "my_scheduler2.sv"  // choosing scheduler here execute all generated from 1 source
    // before switching to another
`include "dut_scen_env.sv"

   
  dut_env env;                     // DUT Environment
   my_apb_scenario my_scenario;
   
  
  
  initial begin
    $vcdpluson;
     my_scenario  = new();

    
    env = new(ifc);                // Create the environment
     env.gen_cfg();

     // overriding cfg constraint
     env.cfg.trans_cnt = 7;
     $display ("overriding cfg trans_cnt, it is now %0d", env.cfg.trans_cnt);
     
     env.build();                   // Build the environment
     env.scen_gen.scenario_set[0] = my_scenario;  // replace round robin default scenario
     env.scen_gen.scenario_set.push_back(my_scenario);  // replace round robin default scenario

    env.gen2mas.tee_mode(1);       // Enable Tee mode for thread below
    env.run();                     // Run all steps
     
  end 

  // Tee all elements from the generator, and print them
  initial 
    fork
      begin
        forever begin
          apb_trans tr;
          env.gen2mas.get(tr); // since no consumer use get vs. sink for proper DONE indicator
          tr.display("To Mst ==> ");
        end
      end
// using User generated notifier here
      begin
        env.my_apb_gen.notify.wait_for(env.my_apb_gen.DONE_WITH_3RW);
         $display ("FROM TEST: Got notifier that GEN FINISHED 3RW SEQUENCE ");
      end
      
  join_none

    // use notifier to generate message:
  
endprogram

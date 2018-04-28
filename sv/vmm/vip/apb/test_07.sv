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
`include "apb_monitor.sv"
`include "dut_sb.sv"
`include "sb_callbacks.sv"
`include "cov_callbacks.sv"
`include "dut_env.sv"
  
//  - Create a constrained apb_trans class called my_abp_trans
//  - class my_apb_trans extends apb_trans;
//  -   constraint  {
//  -    addr inside {0, 100, 1024};
//  -    data inside {0, 100, 1024};
//  -   }
//  - endclass
  class my_apb_trans extends apb_trans;                      //
    constraint  cst {                                        //
      addr inside {0, 100, 1024};                            //
      data inside {0, 100, 1024};                            //
    }                                                        //
  endclass                                                   //
                                                             //   
  dut_env env;                     // DUT Environment

  initial begin
    env = new(ifc);                // Create the environment
    env.build();                   // Build the environment
//  - Create an my_apb_trans object.  trans = new
//  - Place the trans into the apb atomic generator (gen) object
//  - begin
//  -   my_apb_trans trans = new();
//  -   env.gen.randomized_obj = trans;
//  - end
  begin                                                      //
    my_apb_trans trans = new();                              //
    env.gen.randomized_obj = trans;                          //
  end                                                        //
                                                             //
    env.run();                     // Run all steps
  end 

endprogram

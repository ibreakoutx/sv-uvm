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
// Description : APB Testbench vmm_environment class
//
// This class instantiates all the permanent testbench top-level components
//
// After all the  have been completed, this will include:
//   * APB Atomic Generator
//   * APB Master
//   * APB Monitor
//   * Scoreboard
//
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// dut_env class
//-----------------------------------------------------------------------------

class dut_env extends vmm_env ;

  // APB Master/Monitor Virtual Interface
  virtual apb_if  ifc;

  // : Add a VMM logger for messages  (vmm log log)
  vmm_log log;                                                           //
  
  // : Add an apb_cfg data member here with name "cfg"
  apb_cfg cfg;                                                           //
                                                                         //
  // : Add a channel here for the output generator called gen2mas
  apb_trans_channel gen2mas;                                             //
                                                                         //
  // : Add a channel here for the output monitor mon2scb
  apb_trans_channel mon2scb;                                             //
                                                                         //
  // : Add a data member here for apb_trans_atomic_gen called gen
  apb_trans_atomic_gen gen;                                              //
                                                                         //
  // : Add a data member here for apb_master called mst    
  apb_master            mst;                                             //
                                                                         //
  // : Add a data member here for apb_monitor called mon
  apb_monitor           mon;                                             //
                                                                         //
  // : Add a data member here for dut_sb called scb
  dut_sb                scb;                                             //
                                                                         //
  // Constructor
  extern function new(virtual apb_if ifc);

  // VMM Environment Steps
  extern virtual function void gen_cfg();
  extern virtual function void build();
  extern virtual task reset_dut();
  extern virtual task cfg_dut();
  extern virtual task start();
  extern virtual task wait_for_end();
  extern virtual task stop();
  extern virtual task cleanup();
  extern virtual task report();

endclass: dut_env

//-----------------------------------------------------------------------------
// new() - constructor, pass in any virtual ports needed to connect to DUT
//-----------------------------------------------------------------------------
  
  function dut_env::new(virtual apb_if ifc);

    // Pass in the name of the environment to the VMM-Env logger class
    super.new("DUT_ENV");
    
    // Save a copy of the virtual interfaces
    this.ifc = ifc;

    //  - Allocate/new() the log using new("dut", "env")
    log = new("dut", "env");                                             //
  
    //  -  Allocate/new() the cfg object here
    this.cfg = new() ;                                                   //

endfunction

//-----------------------------------------------------------------------------
// gen_cfg() - Generate a randomized testbench configuration
//-----------------------------------------------------------------------------
    
function void dut_env::gen_cfg() ;

  super.gen_cfg() ;

  //  - Randomize the cfg object here, print a fatal message if the
  //  - randomization fails (returns 0)
  if (cfg.randomize() == 0)                                              //
    `vmm_fatal(log, "Failed to randomize testbench configuration");      //
                                                                         // 
  //  - Add a `vmm_note print statement here to display the cfg.trans_cnt
  `vmm_note(log, $psprintf("cfg.trans_cnt = %d", cfg.trans_cnt));        //
                                                                         // 
endfunction

//-----------------------------------------------------------------------------
// build() - Build the testbench, xactors, scoreboard, callbacks
//-----------------------------------------------------------------------------
    
function void dut_env::build() ;

  super.build() ;

  //  - Create a channel to connect the atomic generator to the master
  //  - new(), gen2mas, "APB Trans Channel", "gen2mas"     
  gen2mas = new ("APB Trans Channel", "gen2mas") ;                       //
                                                                         //
  // - Create a channel to connect the monitor to scoreboard
  //  - new(), mon2scb, "APB Trans Channel", "mon2scb"     
  mon2scb = new ("APB Trans Channel", "mon2scb") ;                       //
                                                                         //
  //  - Create the gen data member by calling new here
  //  - "APB Atomic Gen", instance = 1, channel = gen2mas
  gen = new ("APB Atomic Gen", 1, gen2mas) ;                             //
                                                                         //     
  //  - Create the mst object by calling new() with arguments:
  //  - "APB trans master", 1, ifc, gen2mas
  mst = new ("APB trans master", 1, ifc, gen2mas );                      //
                                                                         //
  //  - Create the mon object by calling new with arguments:
  //  - "APB trans monitor", 1, ifc, mon2scb
  mon = new ("APB trans monitor", 1, ifc, mon2scb);                      //
                                                                         //
  //  - Create the scb transactor instance
  scb = new(cfg.trans_cnt, mon2scb) ;                                    //
                                                                         //
  //  - Integrate the scoreboard using callbacks
  //  - Enclose the following 2 lines in a begin/end block
  //  - Create a new apb_master_sb_callbacks object apb_mst_sb_cb
  //  - Append this using mst.append_callback(apb_mst_sb_cb)
  begin                                                                  //
    apb_master_sb_callbacks  apb_mst_sb_cb  = new(scb);                  //  
    mst.append_callback(apb_mst_sb_cb);                                  //
  end                                                                    //
                                                                         //
  //  - Integrate the functional coverage using a callback object
  //  - The code will be very similar to the master scoreboard 
  //  - integration code above, except the class name is 
  //  - apb_master_cov_callbacks, and the new() has no argument
  begin                                                                  //
    apb_master_cov_callbacks cov_cb = new();                             //   
    mst.append_callback(cov_cb);                                         //   
  end                                                                    //

  //  - Configure the generator to stop after cfg.trans_cnt instances
  //  - use the gen.stop_after_n_insts data member
  gen.stop_after_n_insts = cfg.trans_cnt ;                               //
                                                                         //
endfunction: build

//-----------------------------------------------------------------------------
// reset_dut() - Reset the DUT
//-----------------------------------------------------------------------------
  
task dut_env::reset_dut();

  super.reset_dut();

  //  - Reset the APB master by calling mst.reset()
  mst.reset();                                                           //
                                                                         //
endtask:reset_dut

//-----------------------------------------------------------------------------
// cfg_dut() - Configure the DUT
//-----------------------------------------------------------------------------

task dut_env::cfg_dut();
    
  super.cfg_dut() ;

endtask: cfg_dut

//-----------------------------------------------------------------------------
// start() - Start each of the xactors
//-----------------------------------------------------------------------------
    
task dut_env::start();

  super.start();

  //  - Add call to start_xactor for gen
  gen.start_xactor();                                                    //
  //  - Add call to start_xactor for mst
  mst.start_xactor();                                                    //
  //  - Add call to start_xactor for mon
  mon.start_xactor();                                                    //
  //  - Add call to start_xactor for scb
  scb.start_xactor();                                                    //
                                                                         //
endtask: start

//-----------------------------------------------------------------------------
// wait_for_end() - Wait until the test completes
//-----------------------------------------------------------------------------

task dut_env::wait_for_end();

  super.wait_for_end();

  //  - wait for notification from gen and scoreboard
  //  - fork, then gen.notify.wait_for(apb_trans_atomic_gen::DONE) 
  //  - then scb.notify.wait_for(scb.DONE), join_any
  //  - Note vmm builtin notify is enum int, so has class::enum
  //  - User notify is int so has class.datamember
  fork                                                                   //
    gen.notify.wait_for(apb_trans_atomic_gen::DONE);                     //
    scb.notify.wait_for(scb.DONE);                                       //
  join_any                                                               //
                                                                         //
endtask: wait_for_end
            
//-----------------------------------------------------------------------------
// stop() - Stop each of the xactors
//-----------------------------------------------------------------------------
    
task dut_env::stop();

  super.stop() ;

  //  - Add call to stop_xactor for gen
  gen.stop_xactor();                                                     //
  //  - Add call to stop_xactor for mst
  mst.stop_xactor();                                                     //
  //  - Add call to stop_xactor for mon
  mon.stop_xactor();                                                     //
  //  - Add call to stop_xactor for scb
  scb.stop_xactor();                                                     //
                                                                         //
endtask: stop

//-----------------------------------------------------------------------------
// report() - Report Statistics from the testbench
//-----------------------------------------------------------------------------

task dut_env::report() ;
    
  super.report() ;

  //  - Add a call to the scb.report() task here
  scb.report();                                                          //
                                                                         //    
endtask

//-----------------------------------------------------------------------------
// cleanup() - Cleanup the testbench, report any scoreboard errors etc.
//-----------------------------------------------------------------------------

task dut_env::cleanup();

  super.cleanup() ; 

  //  - Add a call to the scb.cleanup() task here
  scb.cleanup();                                                         //
                                                                         //
endtask


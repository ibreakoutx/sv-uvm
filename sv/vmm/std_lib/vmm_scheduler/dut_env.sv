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
// dut_env class
//-----------------------------------------------------------------------------

class dut_env extends vmm_env ;

  // APB Master/Monitor Virtual Interface
  virtual apb_if  ifc;

  // Lab1: Add a VMM logger for messages  (vmm log log)
  vmm_log log;                                                           //LAB1
  
  // Lab1: Add an apb_cfg data member here with name "cfg"
  apb_cfg cfg;                                                           //LAB1


  // adding array of channels to attach to scheduler
  apb_trans_channel gen2schd[8];

  // adding channel to master xactor
  apb_trans_channel gen2mas;

  // adding scheduler


`ifdef def
  vmm_scheduler sched;
 `else 
  my_scheduler sched;
`endif


  // add my scheduler_election

  my_scheduler_election elect;
  
  //adding array of  atomic generators
  apb_trans_atomic_gen gen[8];
  int num_gen_obj[];
  

  // Lab4: Add a data member here for apb_master called mst    
  apb_master mst;
  

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

    // Lab1 - Allocate/new() the log using new("dut", "env")
    log = new("dut", "env");                                             //LAB1
  
    // Lab1 -  Allocate/new() the cfg object here
    this.cfg = new() ;                                                   //LAB1

endfunction

//-----------------------------------------------------------------------------
// gen_cfg() - Generate a randomized testbench configuration
//-----------------------------------------------------------------------------
    
function void dut_env::gen_cfg() ;

  super.gen_cfg() ;

  // Lab1 - Randomize the cfg object here, print a fatal message if the
  // Lab1 - randomization fails (returns 0)
  if (cfg.randomize() == 0)                                              //LAB1
    `vmm_fatal(log, "Failed to randomize testbench configuration");      //LAB1
                                                                         //LAB1 
  // Lab1 - Add a `vmm_note print statement here to display the cfg.trans_cnt
  `vmm_note(log, $psprintf("cfg.trans_cnt = %d", cfg.trans_cnt));        //LAB1
                                                                         //LAB1 
endfunction

//-----------------------------------------------------------------------------
// build() - Build the testbench, xactors, scoreboard, callbacks
//-----------------------------------------------------------------------------
    
function void dut_env::build() ;

  super.build() ;

  //  - Create a channels

  foreach (gen2schd[i]) begin
    string temp;
    temp = {"gen2shd",i};
    gen2schd[i] = new ("APB Trans Channel", temp);
  end 
  

  //  Create the gen data members by calling new here

  foreach(gen[i]) begin
  gen[i] = new ("APB Atomic Gen", i, gen2schd[i]) ;
  end 

 // Lab3 - Configure the generator to stop after cfg.trans_cnt instances
  // Lab3 - use the gen.stop_after_n_insts data member
  num_gen_obj = new[$size(gen)];

  
  
  foreach(gen[i]) begin
    gen[i].stop_after_n_insts = cfg.trans_cnt ;
    num_gen_obj[i]= gen[i].stop_after_n_insts;
    
  end 
  
  // create gen2mas channel
  gen2mas = new("APB master channel", "gen2mas");
  
  // Create scheduler
  
`ifdef def
              sched = new("SCHEDULER", "inp_schd", gen2mas);
  `else
      sched = new("SCHEDULER", "inp_schd", gen2mas, -1, num_gen_obj);
  `endif

`ifdef elect    
  elect = new;
  sched.randomized_sched = elect;
`endif
  
  // pass input channels to scheduler
  foreach(gen2schd[i]) begin
    sched.new_source(gen2schd[i]);
  end 
  

// Lab4 - Create the mst object by calling new() with arguments:
  // Lab4 - "APB trans master", 1, ifc, gen2schd

  mst = new("APB trans master", 1, ifc, gen2mas);
 

 
  
endfunction: build

//-----------------------------------------------------------------------------
// reset_dut() - Reset the DUT
//-----------------------------------------------------------------------------
  
task dut_env::reset_dut();

  super.reset_dut();

  // Lab4 - Reset the APB master by calling mst.reset()

  mst.reset();
  
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

  // start scheduler
  sched.start_xactor();

  // Add call to start_xactor for gen
  foreach(gen[i]) begin
  gen[i].start_xactor();
  end


  // Lab4 - Add call to start_xactor for mst
  mst.start_xactor();
  
endtask: start

//-----------------------------------------------------------------------------
// wait_for_end() - Wait until the test completes
//-----------------------------------------------------------------------------

task dut_env::wait_for_end();

  super.wait_for_end();

foreach (gen[i]) begin
  fork
   gen[i].notify.wait_for(apb_trans_atomic_gen::DONE);
  join
end


endtask: wait_for_end
            
//-----------------------------------------------------------------------------
// stop() - Stop each of the xactors
//-----------------------------------------------------------------------------
    
task dut_env::stop();

  super.stop() ;

  // Lab3 - Add call to stop_xactor for gen
  foreach(gen[i]) begin
  gen[i].stop_xactor();
  end
  
  // Lab4 - Add call to stop_xactor for mst
  mst.stop_xactor();
  
endtask: stop

//-----------------------------------------------------------------------------
// report() - Report Statistics from the testbench
//-----------------------------------------------------------------------------

task dut_env::report() ;
    
  super.report() ;

endtask

//-----------------------------------------------------------------------------
// cleanup() - Cleanup the testbench, report any scoreboard errors etc.
//-----------------------------------------------------------------------------

task dut_env::cleanup();

  super.cleanup() ; 

endtask


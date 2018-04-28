/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`include "cpu_subenv.sv"
`include "cpu_cfg.sv"
`include "memsys_scenario.sv"

class memsys_env extends vmm_env;
  // log handle
  vmm_log                          log;

  // test configuration handle
  cpu_cfg                          test_cfg;

  // cpu0 instance
  cpu_subenv                       cpu0;
  // cpu1 instance
  cpu_subenv                       cpu1;

  // top level scenario object
  memsys_scenario                 memsys_scn;

  // multi stream scenario generator handle
  vmm_ms_scenario_gen             gen;

  
  //extern methods
  extern  function new();
  extern  virtual function void gen_cfg();
  extern  virtual function void build();
  extern  virtual task reset_dut();
  extern  virtual task start();
  extern  virtual task wait_for_end();
  extern  virtual task stop();

endclass

function memsys_env::new();
  log = new("memsys_env", "class");
  test_cfg = new;
  log.stop_after_n_errors(0); //Simulation doesnt stop for errors
endfunction

function void memsys_env::gen_cfg();
   super.gen_cfg();
   assert(test_cfg.randomize());

endfunction

function void memsys_env::build();
   super.build();

  `vmm_trace(log, "Building components...");
   
   //Building the components
   cpu0 = new("CPU0", test_top.port0,end_vote);
   cpu1 = new("CPU1", test_top.port1,end_vote);
   memsys_scn = new();
   gen = new("MS-Generator");
   cpu0.enable_gen = 0;
   cpu1.enable_gen = 0;
   gen.register_channel("cpu0_chan", cpu0.gen_to_drv_chan);
   gen.register_channel("cpu1_chan", cpu1.gen_to_drv_chan);
   gen.register_ms_scenario( "memsys_scn", memsys_scn);
   gen.stop_after_n_scenarios = test_cfg.num_scenarios;
endfunction

task memsys_env::reset_dut();
  super.reset_dut();
  `vmm_verbose(this.log,"Resetting DUT...");
  test_top.reset <= 1'b0;
  repeat(1) @(test_top.port0.cb)
  test_top.reset <= 1'b1;
  repeat(10) @(test_top.port0.cb)
  test_top.reset <= 1'b0;
  `vmm_verbose(this.log,"RESET DONE...");
endtask


task memsys_env::start();
  super.start();
  cpu0.start();
  cpu1.start();
		gen.start_xactor();
endtask


task memsys_env::wait_for_end();
  super.wait_for_end();
  `vmm_verbose(this.log,"About to end simulation...");
		gen.notify.wait_for(vmm_ms_scenario_gen::DONE);
endtask


task memsys_env::stop();
  super.stop();
  cpu0.stop();
  cpu1.stop();
		gen.stop_xactor();
endtask



/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`include "cpu_trans.sv"
`include "cpu_driver.sv"
`include "cpu_scenario.sv"

class cpu_subenv extends vmm_subenv;

  // Virtual interface instance
  virtual cpu_if.drvprt      vip;

  // driver instance
  cpu_driver                 drv;

  // generator instance
   cpu_trans_scenario_gen    gen;

  // scenario handle
  cpu_scenario               scn;

  // generator to driver channel
  cpu_trans_channel          gen_to_drv_chan;

  // transaction blueprint;
  cpu_trans                  blueprint;

  // driver callback instance
  cpu_driver_callbacks       drv_cb;

  // flag to enable/disable scenario generator
  bit                        enable_gen = 1;

   extern function new(string inst, virtual cpu_if.drvprt iport, vmm_consensus end_test);
   extern virtual task start();
   extern virtual task stop();
endclass

/*******************************************************************************
  new() :  constructor
*******************************************************************************/
function cpu_subenv::new(string inst, virtual cpu_if.drvprt iport,vmm_consensus end_test);
  super.new("cpu_subenv",inst, end_test);
  this.vip = iport;
  this.scn = new();
  this.gen_to_drv_chan = new("Gen2DrvChan", {inst, "Chan"});
  this.drv = new({inst, "Drv"}, gen_to_drv_chan,vip);
  this.gen = new({inst, "Gen"},0,gen_to_drv_chan);
  this.gen.scenario_set[0] = scn;
  super.configured();
endfunction

/*******************************************************************************
  start() :  transactors are started
*******************************************************************************/
task cpu_subenv::start();
   super.start();

   //`vmm_trace(log, $psprintf("Starting %s %s...", CPU,cpuinst));
   if (enable_gen)
     gen.start_xactor();

   if (drv != null)
     drv.start_xactor();

   `vmm_trace(log, "cpu started");

endtask

/*******************************************************************************
  stop() :  transactors are stopped
*******************************************************************************/
task cpu_subenv::stop();
   super.stop();
   if (enable_gen) gen.stop_xactor();
   if (drv != null) drv.stop_xactor();
   `vmm_trace(log, "cpu stopped");
endtask


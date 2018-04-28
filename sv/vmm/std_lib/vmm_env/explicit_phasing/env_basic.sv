/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

//
// SYNOPSYS CONFIDENTIAL - SYNOPSYS CONFIDENTIAL - SYNOPSYS CONFIDENTIAL
//
// This is an unpublished, proprietary work of Synopsys, Inc., and is
// fully protected under copyright and trade secret laws. You may not
// view, use, disclose, copy, or distribute this file or any information
// contained herein except pursuant to a valid written license from
// Synopsys.
//
// SYNOPSYS CONFIDENTIAL - SYNOPSYS CONFIDENTIAL - SYNOPSYS CONFIDENTIAL
//

`include "vmm.sv"

program test;

class my_vmm_env extends vmm_env;


   integer step;

   event end_test;

  
  function new();
   super.new();
   step = 0;
   this.log.start_msg(vmm_log::NOTE_TYP);
   this.log.text("new() executed");
   this.log.text();
endfunction : new


function void gen_cfg();
   super.gen_cfg();
   if (step !== 0) begin
      this.log.start_msg(vmm_log::FAILURE_TYP);
      this.log.text("gen_cfg() executed at the wrong step");
      this.log.text();
   end // if
   step++;
   this.log.start_msg(vmm_log::NOTE_TYP);
   this.log.text("gen_cfg() executed");
   this.log.text();
endfunction  : gen_cfg


function void build();
   super.build();
   if (step !== 1) begin
      this.log.start_msg(vmm_log::FAILURE_TYP);
      this.log.text("build() executed at the wrong step");
      this.log.text();
   end // if
   step++;
   this.log.start_msg(vmm_log::NOTE_TYP);
   this.log.text("build() executed");
   this.log.text();
endfunction : build


task reset_dut();
   super.reset_dut();
   if (step !== 2) begin
      this.log.start_msg(vmm_log::FAILURE_TYP);
      this.log.text("reset_dut() executed at the wrong step");
      this.log.text();
   end // if
   step++;
   this.log.start_msg(vmm_log::NOTE_TYP);
   this.log.text("reset_dut() executed");
   this.log.text();
endtask : reset_dut


task cfg_dut();
   super.cfg_dut();
   if (step !== 3) begin
      this.log.start_msg(vmm_log::FAILURE_TYP);
      this.log.text("cfg_dut() executed at the wrong step");
      this.log.text();
   end // if
   step++;
   this.log.start_msg(vmm_log::NOTE_TYP);
   this.log.text("cfg_dut() executed");
   this.log.text();
endtask : cfg_dut


task start();
   super.start();
   if (step !== 4) begin
      this.log.start_msg(vmm_log::FAILURE_TYP);
      this.log.text("start() executed at the wrong step");
      this.log.text();
   end // if
   step++;
   this.log.start_msg(vmm_log::NOTE_TYP);
   this.log.text("start() executed");
   this.log.text();
endtask : start


task wait_for_end();
   super.wait_for_end();
   this.log.start_msg(vmm_log::NOTE_TYP);
   this.log.text("wait_for_end() going to be executed");
   this.log.text();
   @ this.end_test;
endtask : wait_for_end


task stop();
   super.stop();
   if (step !== 5) begin
      this.log.start_msg(vmm_log::FAILURE_TYP);
      this.log.text("stop() executed at the wrong step");
      this.log.text();
   end // if
   step++;
   this.log.start_msg(vmm_log::NOTE_TYP);
   this.log.text("stop() executed");
   this.log.text();
endtask : stop


task cleanup();
   super.cleanup();
   if (step !== 6) begin
      this.log.start_msg(vmm_log::FAILURE_TYP);
      this.log.text("cleanup() executed at the wrong step");
      this.log.text();
   end // if
   step++;
   this.log.start_msg(vmm_log::NOTE_TYP);
   this.log.text("cleanup() executed");
   this.log.text();
endtask : cleanup

task report();
   if (step !== 7) begin
      this.log.start_msg(vmm_log::FAILURE_TYP);
      this.log.text("report() executed at the wrong step");
      this.log.text();
   end // if
   step++;
   this.log.start_msg(vmm_log::NOTE_TYP);
   this.log.text("report() executed");
   this.log.text();
endtask : report

endclass // my_vmm_env

initial begin : pgm
   my_vmm_env env = new;
  $display("starting test..");
   env.log.start_msg(vmm_log::NOTE_TYP);
   env.log.text("Verifying run flow...");
   env.log.text();

   fork
      env.run();
   join_none
   
   repeat (10) begin
     #0;
   end // if
   if (env.step !== 5) begin
      env.log.start_msg(vmm_log::FAILURE_TYP);
      env.log.text("run() not running at step #5");
      env.log.text();
   end // if

   -> env.end_test;
   repeat (10) begin
     #0;
   end // if
   if (env.step !== 8) begin
      env.log.start_msg(vmm_log::FAILURE_TYP);
      env.log.text("run() did not run to completion");
      env.log.text();
   end // if

   env.log.report("/./", "/./");
   end : pgm

endprogram : test

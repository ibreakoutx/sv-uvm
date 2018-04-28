/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`ifndef TB_ENV__SV
`define TB_ENV__SV

typedef class config_mam;

`include "vmm_ral.sv"
`include "ral_slave.sv"
`include "apb_rw_xlate.sv"
`include "tb_top.sv"
`include "tb_subenv.sv"

class config_mam;
  rand vmm_mam_cfg mam_cfg;
  
  constraint c {
    mam_cfg.n_bytes == 4; //CAUTION : Same as "bits" in slave.ralf
    mam_cfg.start_offset == 0; //CAUTION : Same as "bits" in slave.ralf
    mam_cfg.end_offset == 1023; //CAUTION : Same as "bits" in slave.ralf
    mam_cfg.mode == vmm_mam::GREEDY;
    mam_cfg.locality == vmm_mam::BROAD;
  }
  
  function new();
    this.mam_cfg = new();
  endfunction
endclass


class tb_env extends vmm_ral_env;
   tb_subenv subenv;
   ral_block_slave ral_model;
   apb_master   mst;
   apb_rw_xlate apb;
   config_mam cfg;
   int run_for;   

   function new(string name = "Verif Env");
      super.new(name);
      cfg = new();
      this.run_for = 10;
   endfunction: new

   function void gen_cfg();
      super.gen_cfg();
      cfg.randomize();
   endfunction

   virtual function void build();
      super.build();
      this.ral_model = new(1);
      this.mst = new("APB", 0, tb_top.apb0);
      this.apb = new("APB", 0, this.mst);
      this.ral.set_model(this.ral_model);
      this.ral.default_path = vmm_ral::BFM;
      this.ral.add_xactor(this.apb);
      this.subenv =new("SUBENV", this.end_vote, this.ral_model, this.cfg);
   endfunction: build

   virtual task hw_reset();
      tb_top.rst <= 1'b1;
      repeat (3) @ (negedge tb_top.clk);
      tb_top.rst <= 1'b0;
      repeat (3) @ (negedge tb_top.clk);
   endtask: hw_reset

   virtual task cfg_dut();
      super.cfg_dut();
      subenv.configure();
    endtask: cfg_dut

   virtual task start();
      super.start();
      subenv.start();
   endtask: start

   virtual task wait_for_end();
      super.wait_for_end();
      `vmm_note(this.log, "WAITING FOR END... ");
      this.end_vote.wait_for_consensus();
      `vmm_note(this.log, "RECEIVED CONSENSUS");
      repeat (this.run_for) @ (posedge tb_top.clk);
   endtask: wait_for_end

   virtual task stop();
      super.stop();
      subenv.stop();
   endtask: stop

   virtual task cleanup();
      super.cleanup();
      subenv.cleanup();
   endtask: cleanup

   virtual task report();
      super.report();
   endtask: report

endclass: tb_env


`endif

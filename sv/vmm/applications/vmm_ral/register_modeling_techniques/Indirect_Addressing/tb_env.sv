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

`include "vmm.sv"
`include "vmm_ral.sv"
`include "apb.sv"
`include "ral_slave.sv"
`include "apb_rw_xlate.sv"

//Step 1: Add frontdoor extension to vmm_ral_reg_frontdoor, and
//        implement the constructor and read method.

class indexed extends vmm_ral_reg_frontdoor;
   bit [7:0] idx;
   vmm_ral_reg INDEX;
   vmm_ral_reg RIdx;

   //Step 1a: Constructor: pass and keep a copy of handles.
   function new ( bit [7:0] idx, 
                  vmm_ral_reg INDEX,
                  vmm_ral_reg RIdx);
      this.idx   = idx;
      this.INDEX = INDEX;
      this.RIdx  = RIdx;
   endfunction

   //Step 1b: implement read virtual method
   virtual task read(output vmm_rw::status_e              status,
                     output bit [`VMM_RAL_DATA_WIDTH-1:0] data,
                     input  int                           data_id = -1,
                     input  int                           scenario_id = -1,
                     input  int                           stream_id = -1);
      this.INDEX.write(status, this.idx, vmm_ral::BFM, "", data_id, scenario_id, stream_id);
      this.RIdx.read(status, data, vmm_ral::BFM, "", data_id, scenario_id, stream_id);
   endtask: read

endclass: indexed

class tb_env extends vmm_ral_env;

   ral_block_slave ral_model;  // define the RAL model

   apb_master   mst;
   apb_rw_xlate ral2apb;  // translate from RAL to APB BFM

   int run_for;
   int total;

   // new
   function new();
      `ifdef RAL_COVERAGE
        ral_model = new(vmm_ral::REG_BITS); //enable ral coverage
      `else
        ral_model = new(vmm_ral::NO_COVERAGE); //disable ral coverage
      `endif
      super.ral.set_model(this.ral_model);
      this.run_for = 1000;
   endfunction: new

   // gen_cfg
   function void gen_cfg();
     super.gen_cfg();
     `vmm_note(log, "Randomizing ral_model.............");
     if (!(this.ral_model.randomize() ))  
       `vmm_error(log, "ral_model could not be randomized");
   endfunction

   // build
   virtual function void build();
      super.build();
      this.mst = new("APB", 0, tb_top.apb0);
      this.ral2apb = new("APB", 0, this.mst);
      // Attach ral2apb to ral.  Note: ral2apb.start_xactor will also be called
      // If your xactor main() depends on hw_reset, move this
      // to the end of the hw_reset task. 
      this.ral.add_xactor(this.ral2apb);    

      //Step 2: register frontdoor callbacks to COUNTERS register array
      begin
         indexed idx;
         foreach (ral_model.COUNTERS[i]) begin
            //Step 2a:create a frontdoor for each COUNTER
            idx = new(i, ral_model.INDEX, ral_model.RIdx);

            //Step 2b:install frontdoor for each COUNTER 
            ral_model.COUNTERS[i].set_frontdoor(idx);
         end
      end
   endfunction: build

   // hw_reset
   virtual task hw_reset();
      tb_top.rst <= 1'b1;
      repeat (3) @ (negedge tb_top.clk);
      tb_top.rst <= 1'b0;
      repeat (3) @ (negedge tb_top.clk);
   endtask: hw_reset

   // cfg_dut
   virtual task cfg_dut();
      vmm_rw::status_e status;
      super.cfg_dut();
      `vmm_note(log, "Configuring DUT.............");
      // Use the backdoor to update the status of the dut to match the 
      // randomized values in gen_cfg.   Backdoor access is much faster 
      // since it runs in 0 simulation cycles
      ral_model.update(status, vmm_ral::BACKDOOR);   // backdoor    
      //ral_model.update(status);  // frontdoor alternative
      `vmm_note(log, "Dut Configuration done..........\n");
   endtask: cfg_dut

   // start
   virtual task start();
      super.start();
   endtask: start

   // wait_for_end
   virtual task wait_for_end();
      super.wait_for_end();
      repeat (this.run_for) @ (posedge tb_top.clk);
   endtask: wait_for_end

   // stop
   virtual task stop();
      super.stop();
   endtask: stop

   // cleanup
   virtual task cleanup();
      super.cleanup();

    endtask: cleanup

   // report
   virtual task report();
      super.report();
   endtask: report

endclass: tb_env

`endif

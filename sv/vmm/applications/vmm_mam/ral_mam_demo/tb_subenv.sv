/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`ifndef TB_SUBENV__SV
`define TB_SUBENV__SV

class tb_subenv extends vmm_subenv;
   ral_block_slave ral_model;
   config_mam cfg;
   vmm_mam_cfg prev_mam_cfg;
   vmm_voter vote;

   function new(string inst, vmm_consensus end_test, ral_block_slave ral_model, config_mam cfg);
      super.new("TB SubEnv", inst, end_test);
      this.ral_model=ral_model;
      this.cfg=cfg;
      vote = end_test.register_voter("TB_SUBENV_VOTER");
      prev_mam_cfg=this.ral_model.DMA_RAM.mam.reconfigure(this.cfg.mam_cfg);
      `vmm_trace(this.log, $psprintf("Previous mem config : "));
      `vmm_trace(this.log, $psprintf("Previous mem config n_bytes : %0d",prev_mam_cfg.n_bytes));
      `vmm_trace(this.log, $psprintf("Previous mem config mode : %0s",prev_mam_cfg.mode.name));
      `vmm_trace(this.log, $psprintf("Previous mem config locality : %0s",prev_mam_cfg.locality.name));
      `vmm_trace(this.log, $psprintf("Previous mem config start_offset : %0d",prev_mam_cfg.start_offset));
      `vmm_trace(this.log, $psprintf("Previous mem config end_offset : %0d",prev_mam_cfg.end_offset));
   endfunction

   task configure();
      super.configured();
   endtask

   virtual task start();
      vmm_rw::status_e status;
      super.start();
      `vmm_note(this.log, "STARTING....");
      vote.oppose("NOT DONE");

      begin
        bit [63:0] value;
        bit is_ok; 
        vmm_mam_region region;
        vmm_rw::status_e status;

        // Initialize memory  //Provide backdoor path in slave.ralf
//        this.ral_model.DMA_RAM.init(is_ok, vmm_ral_mem::VALUE, 5);
//        `vmm_note(this.log, $psprintf("Memory initilization : %0d",is_ok));

        repeat(10) begin
          // Request region
          region=this.ral_model.DMA_RAM.mam.request_region($urandom_range(1,20));
          `vmm_note(this.log, $psprintf("LEN: %d, BYTES: %d, MEM_REGION is:\n %s", region.get_len(), region.get_n_bytes(), this.ral_model.DMA_RAM.mam.psdisplay()));

          // Memory write
          for(int i=0; i<region.get_len(); i++) begin
            value=$urandom_range(1,20);
	           region.write(status, i, value);
            `vmm_note(this.log, $psprintf("Memory write status : %0s",status.name));
            `vmm_note(this.log, $psprintf("Value written @ offset[%0d]: %0d",i, value));
          end

          // Memory read
          for(int i=0; i<region.get_len(); i++) begin
	           region.read(status, i, value);
            `vmm_note(this.log, $psprintf("Memory read status : %0s",status.name));
            `vmm_note(this.log, $psprintf("Value read @ offset[%0d]: %0d",i, value));
          end
        end
      end   
      vote.consent("DONE"); 
   endtask: start

   virtual task stop();
      super.stop();
      `vmm_note(this.log, "STOPPING....");
   endtask

   virtual task cleanup();
      super.cleanup();
      `vmm_note(this.log, "CLEANUP....");
   endtask

endclass: tb_subenv

`endif

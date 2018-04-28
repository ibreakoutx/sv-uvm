/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`include "vmm_ral.sv"
`include "ec_bfm.sv"

class ec_ral_bfm extends vmm_rw_xactor ;

   vmm_log log = new("ec_ral_bfm", "log");
   ec_bfm ec_bfm_0;


   function  new();
      super.new("ec_bfm", "ec_bfm_0", 0);
      ec_bfm_0 = new();
      ec_bfm_0.start_xactor();
   endfunction


   virtual task execute_single(vmm_rw_access tr) ;
      ec_trans ec_trans_0;
      `vmm_debug(log, "ec_ral_bfm::execute_single start");
      if (tr.kind == vmm_rw::WRITE) begin
         `vmm_debug(log, "ec_ral_bfm::execute_single-WRITE");
         ec_trans_0 = new();
         ec_trans_0.addr = tr.addr;
         ec_trans_0.data = tr.data;
         ec_trans_0.rw = ec_trans::WRITE;
	 ec_bfm_0.ch_in.put(ec_trans_0); 
      end      
      if (tr.kind == vmm_rw::READ) begin
         `vmm_debug(log, "ec_ral_bfm::execute_single-READ");
         ec_trans_0 = new();
         ec_trans_0.addr = tr.addr;
         ec_trans_0.rw = ec_trans::READ;
	 ec_bfm_0.ch_in.put(ec_trans_0);  
	 ec_trans_0.notify.wait_for(vmm_data::ENDED);
         `vmm_debug(log, "*** ec_ral_bfm::execute_single-READ got ***");
	 tr.data = ec_trans_0.data;
      end
      `vmm_debug(log, "ec_ral_bfm::execute_single end");
   endtask // task

endclass // class

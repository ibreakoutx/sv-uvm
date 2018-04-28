/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`ifndef apb_master_apb_RAL_BFM__SV
`define apb_master_apb_RAL_BFM__SV

`include "apb_master.sv"
`include "vmm_ral.sv"

class apb_rw_xlate extends vmm_rw_xactor;
   apb_master bfm;


   function new(string        inst,
                int unsigned  stream_id,
                apb_master          bfm);
      super.new("APB RAL Master", inst, stream_id);

      this.bfm = bfm;
   endfunction: new

   
   virtual function void start_xactor();
      super.start_xactor();
      this.bfm.start_xactor();
   endfunction

   
   virtual function void stop_xactor();
      super.stop_xactor();
      this.bfm.stop_xactor();
   endfunction

   
   virtual function void reset_xactor(vmm_xactor::reset_e rst_typ = vmm_xactor::SOFT_RST);
      super.reset_xactor(rst_typ);
      this.bfm.reset_xactor(rst_typ);
   endfunction

   
   virtual task execute_single(vmm_rw_access tr);
      apb_rw cyc;
      
      cyc = new;

      // DUT uses BYTE granularity addresses - but with a DWORD datapath
	  `vmm_trace(log,$psprintf("tr addr = %h",tr.addr));
      cyc.addr = {tr.addr, 2'b00};
	  `vmm_trace(log,$psprintf("cyc addr = %h",cyc.addr));

      if (tr.kind == vmm_rw::WRITE) begin
         // Write cycle
         cyc.kind = apb_rw::WRITE;
         cyc.data = tr.data;
      end
      else begin
         // Read cycle
         cyc.kind = apb_rw::READ;
      end

      this.bfm.in_chan.put(cyc);


      if (tr.kind == vmm_rw::READ)
        tr.data = cyc.data;

      assert(!($isunknown(tr.data))) 
        tr.status = vmm_rw::IS_OK; 
      else begin
        `vmm_error(log, "Data Contains X Value");
        tr.status = vmm_rw::ERROR;
      end
   endtask: execute_single
endclass: apb_rw_xlate

`endif

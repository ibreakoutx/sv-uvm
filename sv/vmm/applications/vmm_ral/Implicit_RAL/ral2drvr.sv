/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class ral2drvr extends vmm_rw_xactor;
  tb_data_channel ral2drvr_chan;
  tb_driver drvr;
  function new(string instance, 
               tb_data_channel chan,
               virtual dut_if.mst iport,
               vmm_rw_access_channel exec_chan=null);
    super.new("ral2drvr", instance, 0, exec_chan);
    this.ral2drvr_chan = chan;
    drvr = new("drvr", iport, this.ral2drvr_chan);
  endfunction
               
  virtual task execute_single(vmm_rw_access tr);
    if (tr.kind == vmm_rw::WRITE) begin
      tb_data wtr = new;
      wtr.randomize() with {
        kind == WRITE;
        addr == tr.addr;
        data == tr.data;
      };
      ral2drvr_chan.put(wtr);
      tr.status = vmm_rw::IS_OK;
    end
    else begin
      tb_data rtr = new;
      rtr.randomize() with {
        kind == READ;
        addr == tr.addr;
      };
      ral2drvr_chan.put(rtr);
      tr.data = rtr.data;
      tr.status = vmm_rw::IS_OK;
    end
  endtask

   virtual function void start_xactor();
      super.start_xactor();
      this.drvr.start_xactor();
   endfunction: start_xactor

   virtual function void stop_xactor();
      super.stop_xactor();
      this.drvr.stop_xactor();
   endfunction: stop_xactor
	 
endclass



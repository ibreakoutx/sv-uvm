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

  function new(string instance, 
               tb_data_channel chan,
               vmm_rw_access_channel exec_chan=null);
    super.new("ral2drvr", instance, 0, exec_chan);
    this.ral2drvr_chan = chan;
  endfunction
               
  virtual task execute_single(vmm_rw_access tr);
    `vmm_trace(log, tr.psdisplay("Converting RAL txn to tb_data"));
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

	 function void reset_xactor(reset_e rst_typ);
    super.reset_xactor(rst_typ);
  endfunction: reset_xactor


endclass



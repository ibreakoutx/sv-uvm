
class ral2drvr extends vmm_rw_xactor;
  tb_data_channel ral2drvr_chan;
  tb_data_channel mon2ral_chan;
  event tmp;
		vmm_rw_access tr1;
		

  function new(string instance, 
               tb_data_channel chan,
															tb_data_channel mon_chan,
               vmm_rw_access_channel exec_chan=null);
    super.new("ral2drvr", instance, 0, exec_chan);
    this.ral2drvr_chan = chan;
				this.mon2ral_chan = mon_chan;
  endfunction
		
  virtual task observe_single(output vmm_rw_access tr);
    //------------------------------------------------
    tb_data data_tr;
    vmm_rw_access local_tr;

    mon2ral_chan.get(data_tr);  
    `vmm_trace(log, data_tr.psdisplay("Converting tb_data to RAL txn "));

   local_tr = new;
    
   if(data_tr.kind == tb_data :: WRITE)
      local_tr.kind = vmm_rw :: WRITE;
   else if ( data_tr.kind == tb_data :: READ)
      local_tr.kind = vmm_rw :: READ;
    
   local_tr.addr = data_tr.addr;   
   local_tr.data = data_tr.data;

   tr = local_tr;
   //------------------------------------------------
  endtask

  virtual task execute_single(vmm_rw_access tr);
    `vmm_trace(log, tr.psdisplay("Converting RAL txn to tb_data"));
    if (tr.kind == vmm_rw::WRITE) begin
      tb_data wtr = new;
      wtr.kind = tb_data::WRITE ;
      wtr.addr = tr.addr;
      wtr.data = tr.data;
      ral2drvr_chan.put(wtr);
      tr.status = vmm_rw::IS_OK;
    end
    else begin
      tb_data rtr = new;
      rtr.kind = tb_data::READ ;
      rtr.addr = tr.addr;
      ral2drvr_chan.put(rtr);
      tr.data = rtr.data;
      tr.status = vmm_rw::IS_OK;
    end
  endtask

endclass



/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class tb_driver extends vmm_xactor;
  virtual dut_if.mst iport;
  tb_data_channel    chan;

  function new(string instance, virtual dut_if.mst iport, tb_data_channel chan);
    super.new("tb_driver", instance);
    this.iport = iport;
    this.chan  = chan;
  endfunction

 task main();
   tb_data tr;
   super.main();
   forever begin
     chan.peek(tr);
     case (tr.kind)
       tb_data::WRITE : write(tr);
       tb_data::READ  : read(tr);
     endcase 
     chan.get(tr);
   end
 endtask

 task write(tb_data tr);
   `vmm_note(log, tr.psdisplay("Executing"));
   @(iport.cb);
   iport.cb.addr <= tr.addr;
   iport.cb.wdata <= tr.data;
   iport.cb.direction <= tr.kind;
   iport.cb.enable <= 1;
   @(iport.cb);
   iport.cb.enable <= 0;
 endtask

 task read (tb_data tr);
   iport.cb.addr <= tr.addr;
   iport.cb.direction <= tr.kind;
   iport.cb.enable <= 1;
   @(iport.cb);
   iport.cb.enable <= 0;
   @(iport.cb);
   tr.data = iport.cb.rdata;
   `vmm_note(log, tr.psdisplay("Executing"));
 endtask

endclass


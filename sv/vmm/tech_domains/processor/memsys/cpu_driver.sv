/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


typedef class cpu_driver;

class cpu_driver_callbacks extends vmm_xactor_callbacks;
    virtual task pre_trans  (cpu_driver driver,
                               cpu_trans tr,
                               bit drop);
    endtask


   virtual task post_trans  (cpu_driver driver,
                               cpu_trans tr
                               );
   endtask
endclass

class cpu_driver extends vmm_xactor;
  virtual cpu_if.drvprt  iport;
  cpu_trans_channel in_chan;
  cpu_trans   tr;

  extern function new(string inst, cpu_trans_channel in_chan, virtual cpu_if.drvprt iport);
  extern task main();
  extern task write_op();
  extern task read_op();
endclass

function cpu_driver::new(string inst, cpu_trans_channel in_chan, virtual cpu_if.drvprt iport);
  super.new("cpu_driver", inst);
  this.in_chan = in_chan;
  this.iport = iport;
endfunction

task cpu_driver::main();
fork 
 super.main();
join_none
while (1) begin : w0
  this.in_chan.peek(tr);
  `vmm_note (this.log, $psprintf ("Driver received a transaction: %s", tr.psdisplay()));
  if (tr.kind == cpu_trans::WRITE) begin
    write_op();
  end
  if (tr.kind == cpu_trans::READ) begin
    read_op();
  end
  tr.notify.indicate(vmm_data::ENDED);
  this.in_chan.get(tr);
  
end : w0
endtask

task cpu_driver::write_op();
    iport.cb.request <= 1'b1;
    wait (iport.cb.grant == 1'b1);
    @(iport.cb);
    iport.cb.busAddr <= tr.address;
    iport.cb.busData <= tr.data; 
    iport.cb.busRdWr_N <= 1'b0; 
    iport.cb.adxStrb <= 1'b1; 
    @(iport.cb);
    iport.cb.busRdWr_N <= 1'b1; 
    iport.cb.busData <= 8'bzzzzzzzz; 
    iport.cb.adxStrb <= 1'b0;    
    @(iport.cb);
    iport.cb.request <= 1'b0;
endtask

task cpu_driver::read_op();
    iport.cb.request <= 1'b1;
    wait (iport.cb.grant == 1'b1);
    @(iport.cb);
    iport.cb.busAddr <= tr.address;
    iport.cb.busRdWr_N <= 1'b1;
    iport.cb.adxStrb <= 1'b1; 
    @(iport.cb);
    iport.cb.adxStrb <= 1'b0;
    repeat (tr.trans_delay) @(iport.cb);
    iport.cb.busData <= tr.data;
    @(iport.cb);
    iport.cb.request <= 1'b0;
endtask

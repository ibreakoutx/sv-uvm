/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


typedef class alu_mon;

class alu_mon_callbacks extends vmm_xactor_callbacks;
   // Called after a new transaction has been observed
   virtual task post_mon(alu_mon   mon,
                         alu_data tr,
                         ref bit          drop);
   endtask
endclass

class alu_mon extends vmm_xactor;

   // Factory instance for transaction descriptors
   alu_data allocated_tr;

   // Interface to Intel Bus HDL signals
   virtual alu_if.monprt iport;

   // Output channel of observed transactions
   alu_data_channel out_chan;

   // Are transactions put into the output channel?
   local bit is_sink;

   integer n_trans = 0;

   // Constructor
   extern function new(string                   instance,
            integer                  stream_id,
            virtual alu_if.monprt          iport,
            alu_data_channel out_chan=null,
            bit                      is_sink=0);

   extern protected virtual task main();

   // Monitors the bus and returns whenver a new transaction
   // has been observed
   extern virtual task monitor_t(ref alu_data received_mt);

endclass


function alu_mon::new(string                   instance,
                         integer                  stream_id,
                         virtual alu_if.monprt          iport,
                         alu_data_channel out_chan = null,
                         bit                      is_sink  = 0);
  super.new("ALU Monitor", instance, stream_id);

   this.allocated_tr = new;

   this.iport = iport;
   if (out_chan == null)
      out_chan = new({this.log.get_name(), " Output Channel"}, instance);
   this.out_chan = out_chan;
   this.is_sink = is_sink;

endfunction


task alu_mon::main();
   fork
      super.main();
   join_none

   while (1) begin
      alu_data tr;
      bit              drop = is_sink;

      super.wait_if_stopped();

      $cast(tr, this.allocated_tr.allocate());
      this.monitor_t(tr);

      `vmm_debug(log, "Observed transaction...");
      `vmm_debug(log, tr.psdisplay("monitor"));
      `vmm_callback(alu_mon_callbacks, post_mon(this, tr, drop));
   end
endtask

task alu_mon::monitor_t(ref alu_data received_mt);
  bit en;
   wait (iport.mon_cb.en);
   $cast (received_mt.kind, this.iport.mon_cb.sel);
   received_mt.a    = this.iport.mon_cb.a;
   received_mt.b    = this.iport.mon_cb.b;
   @(iport.mon_cb); 
   received_mt.y    = this.iport.mon_cb.y;
   `vmm_note(log, received_mt.psdisplay("Received Transaction:"));
endtask



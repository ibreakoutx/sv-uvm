/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

typedef class alu_driver;

class alu_driver_callbacks extends vmm_xactor_callbacks;
    virtual task pre_trans_t  (alu_driver driver,
                               alu_data tr,
                               bit drop);
    endtask

                               
   virtual task post_trans_t  (alu_driver driver,
                               alu_data tr
                               );
   endtask
endclass
    

class alu_driver extends vmm_xactor;
  alu_data_channel in_chan;

  virtual alu_if.drvprt iport;

  static integer TRANS_DONE;

  function new(string           instance,
           integer          stream_id,
           virtual alu_if.drvprt iport,
           alu_data_channel in_chan = null);

      super.new("ALU Driver", instance, stream_id);
      if (in_chan == null)
         in_chan = new("ALU Driver input channel", instance);
      this.iport = iport;
      this.in_chan = in_chan;

      this.TRANS_DONE = this.notify.configure(, vmm_notify::ON_OFF);

   endfunction


  protected virtual task main();
    alu_data tr;
    fork
      super.main();
    join_none

    this.iport.cb.en <= 0;
    this.iport.cb.sel <= 0;
    this.iport.cb.a <= 4'bx;
    this.iport.cb.b <= 4'bx;

    while(1) begin
       bit drop = 0;

       this.in_chan.get(tr);
       `vmm_callback(alu_driver_callbacks, pre_trans_t(this, tr, drop));

       if (drop) begin
         `vmm_debug(log, "Dropping transaction...");
         tr.display("alu_driver");
         continue;
       end

        tr.notify.indicate(vmm_data::STARTED); 

         this.iport.cb.sel <= tr.kind;
         this.iport.cb.en <= 1'b1;
         this.iport.cb.a <= tr.a;
         this.iport.cb.b <= tr.b;
         
         @(iport.cb);
            this.iport.cb.en <= 1'b0;       
         `vmm_callback(alu_driver_callbacks, post_trans_t(this, tr));
         this.notify.indicate(this.TRANS_DONE, tr);
         this.notify.indicate(vmm_data::ENDED);
         @(iport.cb);
      end
  endtask

endclass



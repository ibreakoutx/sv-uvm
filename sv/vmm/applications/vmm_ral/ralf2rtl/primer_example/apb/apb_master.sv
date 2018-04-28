/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



`ifndef APB_MASTER__SV
`define APB_MASTER__SV

`include "apb_if.sv"
`include "apb_rw.sv"


typedef class apb_master;
class apb_master_cbs extends vmm_xactor_callbacks;
   virtual task pre_cycle(apb_master xactor,
                          apb_rw     cycle,
                          ref bit    drop);
   endtask: pre_cycle

   virtual task post_cycle(apb_master xactor,
                           apb_rw     cycle);
   endtask: post_cycle
endclass: apb_master_cbs


class apb_master extends vmm_xactor;
   apb_rw_channel        in_chan;
   virtual apb_if.master sigs;

   function new(string                name,
                int unsigned          stream_id,
                virtual apb_if.master sigs,
                apb_rw_channel        in_chan = null);
      super.new("APB Master", name, stream_id);
      this.sigs = sigs;
      if (in_chan == null)
         in_chan = new("APB Master Input Channel", name);
      this.in_chan = in_chan;
      this.sigs.mck.psel   <= '0;
      this.sigs.mck.penable <= '0;
   endfunction: new

   virtual function void reset_xactor(reset_e rst_typ = SOFT_RST);
      super.reset_xactor(rst_typ);
      this.in_chan.flush();
      this.sigs.mck.psel    <= '0;
      this.sigs.mck.penable <= '0;
   endfunction: reset_xactor

   virtual protected task main();
      super.main();
      @ (this.sigs.mck);
      forever begin
         apb_rw tr;
         bit drop;

         this.wait_if_stopped_or_empty(this.in_chan);
         this.in_chan.activate(tr);
         // Align to clock edge if no longer aligned
         if (!this.sigs.mck.at_posedge.triggered)  @ (this.sigs.mck);

         drop = 0;
         `vmm_callback(apb_master_cbs, pre_cycle(this, tr, drop));
         if (drop) begin
            `vmm_debug(log, {"Dropping transaction...\n",
                             tr.psdisplay("   ")});
            this.in_chan.remove();
            continue;
         end

         `vmm_trace(log, {"Starting transaction...\n",
                          tr.psdisplay("   ")});

         this.in_chan.start();
         case (tr.kind)
         apb_rw::READ : this.read(tr.addr, tr.data);
         apb_rw::WRITE: this.write(tr.addr, tr.data);
         endcase
         this.in_chan.complete();

         `vmm_trace(log, {"Completed transaction...\n",
                          tr.psdisplay("   ")});

         `vmm_callback(apb_master_cbs, post_cycle(this, tr));

         this.in_chan.remove();
      end
   endtask: main

   virtual protected task read(input  bit   [31:0] addr,
                               output logic [31:0] data);
      this.sigs.mck.paddr   <= addr;
      this.sigs.mck.pwrite  <= '0;
      this.sigs.mck.psel    <= '1;
      @ (this.sigs.mck);
      this.sigs.mck.penable <= '1;
      @ (this.sigs.mck);
      data = this.sigs.mck.prdata;
      this.sigs.mck.psel    <= '0;
      this.sigs.mck.penable <= '0;
   endtask: read

   virtual protected task write(input bit [31:0] addr,
                                input bit [31:0] data);
      this.sigs.mck.paddr   <= addr;
      this.sigs.mck.pwdata  <= data;
      this.sigs.mck.pwrite  <= '1;
      this.sigs.mck.psel    <= '1;
      @ (this.sigs.mck);
      this.sigs.mck.penable <= '1;
      @ (this.sigs.mck);
      this.sigs.mck.psel    <= '0;
      this.sigs.mck.penable <= '0;
   endtask: write

endclass: apb_master

`endif

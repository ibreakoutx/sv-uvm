/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


`ifndef SIMPLE__SV
`define SIMPLE__SV

`include "vmm.sv"


interface simple_if;
  wire        cfg;   // In-band device configuration
  wire [19:0] addr;  // Address
  wire [15:0] data;  // R/W data
  wire        rd;    // Read strobe
  wire        wr;    // Write strobe

  modport master(output cfg, addr, rd, wr,
                 inout  data);
endinterface: simple_if


class simple_tr extends vmm_data;

   static vmm_log log = new("simple_tr", "class");

   typedef enum {READ, WRITE, CFG_RD, CFG_WR} cycle_e;
   rand cycle_e cycle;

   rand bit [ 3:0] dev;
   rand bit [15:0] addr;
   rand bit [15:0] data;

   function new();
      super.new(this.log);
   endfunction: new

endclass: simple_tr
`vmm_channel(simple_tr)


class simple_bfm extends vmm_xactor;

   simple_tr_channel in_chan;
   virtual simple_if.master sigs;

   extern function new(string                   instance,
                       int                      stream_id,
                       virtual simple_if.master sigs,
                       simple_tr_channel        in_chan = null);

   extern virtual task main();
                
endclass: simple_bfm


function simple_bfm::new(string                   instance,
                         int                      stream_id,
                         virtual simple_if.master sigs,
                         simple_tr_channel        in_chan);
   super.new("Simple BFM", instance, stream_id);

   this.sigs = sigs;

   if (in_chan == null) in_chan = new("Simple BFM Input Channel", instance);
   this.in_chan = in_chan;
endfunction: new


task simple_bfm::main();
   super.main();

   this.sigs.cfg = 1'b0;
   this.sigs.rd  = 1'b0;
   this.sigs.wr  = 1'b0;
   #10;

   forever begin
      simple_tr tr;

      this.sigs.data = 'z;
      #10;

      this.wait_if_stopped_or_empty(this.in_chan);
      this.in_chan.activate(tr);
      this.in_chan.start();

      case (tr.cycle)
        simple_tr::READ: begin
           this.sigs.addr = {tr.dev, tr.addr};
           this.sigs.rd   = 1'b1;
           #100;
           tr.data = this.sigs.data;
        end

        simple_tr::WRITE: begin
           this.sigs.addr = {tr.dev, tr.addr};
           this.sigs.wr   = 1'b1;
           this.sigs.data = tr.data;
           #100;
        end

        simple_tr::CFG_RD: begin
           this.sigs.addr = {16'b1 << tr.dev, tr.addr[3:0]};
           this.sigs.cfg  = 1'b1;
           this.sigs.rd   = 1'b1;
           #100;
           tr.data = this.sigs.data;
        end

        simple_tr::CFG_WR: begin
           this.sigs.addr = {16'b1 << tr.dev, tr.addr[3:0]};
           this.sigs.cfg  = 1'b1;
           this.sigs.wr   = 1'b1;
           this.sigs.data = tr.data;
           #100;
        end
      endcase

      this.sigs.cfg = 1'b0;
      this.sigs.rd  = 1'b0;
      this.sigs.wr  = 1'b0;
      #10;

      this.in_chan.complete();
      this.in_chan.remove();
   end
endtask: main

`endif

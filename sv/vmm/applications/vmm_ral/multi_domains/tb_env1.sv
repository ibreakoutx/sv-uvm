/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


`ifndef TB_ENV__SV
`define TB_ENV__SV

`include "simple.sv"
`include "vmm_ral.sv"

`define DROPSYS_TOP_PATH tb_top.dut
`include "ral_dropsys.sv"

class simple_ral_bfm extends vmm_rw_xactor;
   simple_bfm bfm;

   function new(string        instance,
                int unsigned  stream_id,
                simple_bfm    bfm);
      super.new("Simple RAL Master", instance, stream_id);

      this.bfm = bfm;
   endfunction: new

   
   virtual task execute_single(vmm_rw_access tr);
      simple_tr cyc;
      
      // Translate the generic RW into a simple RW
      cyc = new;
      {cyc.dev, cyc.addr} = tr.addr;
      if (tr.kind == vmm_rw::WRITE) begin
         cyc.cycle = simple_tr::WRITE;
         cyc.data  = tr.data;
      end
      else begin
         cyc.cycle = simple_tr::READ;
      end

      this.bfm.in_chan.put(cyc);

      // Send the result back to the RAL
      if (tr.kind == vmm_rw::READ) begin
         tr.data = cyc.data;
      end
   endtask: execute_single
endclass: simple_ral_bfm


class simple_ral_cfg extends vmm_rw_xactor;
   simple_bfm bfm;

   function new(string        instance,
                int unsigned  stream_id,
                simple_bfm    bfm);
      super.new("Simple RAL Master", instance, stream_id);

      this.bfm = bfm;
   endfunction: new

   
   virtual task execute_single(vmm_rw_access tr);
      simple_tr cyc;
      
      // Translate the generic RW into a configuration RW
      cyc = new;
      {cyc.dev, cyc.addr} = tr.addr;
      if (tr.kind == vmm_rw::WRITE) begin
         cyc.cycle = simple_tr::CFG_WR;
         cyc.data  = tr.data;
      end
      else begin
         cyc.cycle = simple_tr::CFG_RD;
      end

      this.bfm.in_chan.put(cyc);

      // Send the result back to the RAL
      if (tr.kind == vmm_rw::READ) begin
         tr.data = cyc.data;
      end
   endtask: execute_single
endclass: simple_ral_cfg


class tb_env extends vmm_ral_env;
   ral_block_dropbox ral_model;
   simple_bfm     bfm[2];
   simple_ral_cfg cfg;
   simple_ral_bfm up;
   simple_ral_bfm dn;

   function new();
      super.new();
      ral_model = new;
      this.ral.set_model(ral_model);
   endfunction: new

   virtual function void build();
      super.build();

      this.bfm[0] = new("Up BFM", 0, tb_top.left);
      this.bfm[1] = new("Down BFM", 1, tb_top.right);

      this.cfg = new("Cfg", 0, this.bfm[0]);
      this.up = new("Up", 0, this.bfm[0]);
      this.dn = new("Down", 0, this.bfm[1]);

      // super.ral.add_xactor(this.cfg, "cfg");
`ifdef NO_DOMAINS
      super.ral.add_xactor(this.up);
`else
      super.ral.add_xactor(this.up, "left");
      super.ral.add_xactor(this.dn, "right");
`endif

      this.bfm[0].start_xactor();
      this.bfm[1].start_xactor();
   endfunction: build

   virtual task hw_reset();
      tb_top.rst <= 1;
      repeat (3) @ (posedge tb_top.clk);
      tb_top.rst <= 0;
   endtask: hw_reset

endclass: tb_env

`endif

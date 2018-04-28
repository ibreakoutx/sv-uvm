/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`include "vmm.sv"
`include "phy_tb_config.sv"
`include "phy_color.sv"
`include "phy_burst.sv"
`include "phy_zone.sv"
`include "phy_super_zone.sv"
`include "phy_frame.sv"
`include "phy_generator.sv"


class phy_env extends vmm_env;

 phy_tb_config phy_cfg;
 phy_frame_atomic_gen phy_gen;
 phy_frame_channel chan;
 phy_frame         blueprint_frame;

 function new();
   phy_cfg = new;
 endfunction
 
 virtual function void gen_cfg();
   super.gen_cfg();
   phy_cfg.randomize();
 endfunction

 virtual function void build();
   super.build();
   chan = new("phychan", "chan");
   phy_gen = new("PhyGen", 0, chan);
   blueprint_frame = new(phy_cfg);
   phy_gen.randomized_obj = blueprint_frame;
   phy_gen.stop_after_n_insts = 1;
 endfunction

 virtual task start();
   super.start();
   phy_gen.start_xactor();
   //popping the contents of the channel
   fork
     while (1) begin
        phy_frame frm;
        chan.get(frm);
        `vmm_note(log, frm.psdisplay());
        #1;
     end
   join_none
 endtask
 
 virtual task wait_for_end();
   super.wait_for_end();
   #5;
 endtask

endclass


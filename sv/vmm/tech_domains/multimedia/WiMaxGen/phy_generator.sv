/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

typedef class phy_generator;

class phy_generator_callbacks extends vmm_xactor_callbacks;
endclass

class phy_generator extends vmm_xactor;

 int unsigned      stop_after_n_frames = 1;
 phy_tb_config     phy_cfg;
 phy_frame         frame;

 function new(string instance, 
              phy_tb_config phy_cfg);
   super.new("PhyGen", instance);
   this.phy_cfg = phy_cfg;
   this.frame = new(phy_cfg);
   this.stop_after_n_frames = phy_cfg.num_of_frames;
 endfunction

 virtual protected task main();
   int unsigned frames_id = 0;
   string unix_command;
   phy_frame frm;
   integer fin;
   fork
     super.main();
   join_none

   while (frames_id < stop_after_n_frames) begin
      $cast (frm, frame.allocate());
      frm.frame_index = frames_id;
      frm.randomize();
      `vmm_note(log, $psprintf("Frame %0d is built successfully", frames_id));
      `vmm_note(log, frm.psdisplay());
      frames_id++;
   end
 endtask

endclass


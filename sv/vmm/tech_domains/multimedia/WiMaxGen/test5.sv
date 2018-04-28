/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

program P;

`include "phy_env.sv"

constraint phy_tb_config::cst_user {
   num_of_frames == 1;
}

constraint phy_frame::cst_phy_frame_user {
   bursts_per_frame == 64;
}
/*
constraint phy_frame::cst_phy_frame_user {
  // num_of_super_zones == 2;
   foreach (super_zone_lengths[i]) {
     super_zone_lengths[i] == 12; 
   }

   foreach (super_zone_list[i]) {
     (i==0) -> super_zone_list[i].super_zone_direction == phy_super_zone::RX_SUPER_ZONE;
     (i==1) -> super_zone_list[i].super_zone_direction == phy_super_zone::TX_SUPER_ZONE;
     (i==0) -> super_zone_list[i].super_zone_mode == phy_super_zone::DOWNLINK;
     (i==1) -> super_zone_list[i].super_zone_mode == phy_super_zone::UPLINK;
   }
}
*/

constraint phy_super_zone::cst_phy_super_zone_user {
   
   foreach (permutations[i])
     permutations[i] inside { phy_zone::PUSC, phy_zone::FUSC};

}

phy_env env;

initial begin
  env = new;
  env.run();
end

endprogram


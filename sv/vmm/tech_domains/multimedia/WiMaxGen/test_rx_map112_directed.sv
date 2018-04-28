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
   num_of_super_zones == 1;
}

constraint phy_super_zone::cst_phy_super_zone_user {
   num_of_zones == 1;
   super_zone_length == 4;
   super_zone_direction == RX_SUPER_ZONE;
   super_zone_mode == DOWNLINK;
   
   foreach (permutations[i])
     (i==0) -> permutations[i] == phy_zone::PUSC;

   foreach (bursts_per_zone[i])
     bursts_per_zone[i] == 3;

   foreach (zone_list[i]) {
     zone_list[i].data_rotation_assist_table_ptr == 0;
     zone_list[i].antenna_coef_ptr == 0;
     zone_list[i].beam_select == 0;
     zone_list[i].power_boosting == 0;
     zone_list[i].stc_mode == 0;
     zone_list[i].matrix == phy_zone::MATRIX_A;
     zone_list[i].mac_report_gen_intrpt == 0;
     zone_list[i].phy_report_gen_intrpt == 0;
     zone_list[i].disable_rotation_scheme == 0;
     zone_list[i].color_map_continue == 0;
     zone_list[i].throwing_samples == 0;
     zone_list[i].dedicated_pilots == 0;
     zone_list[i].use_sub_chan == 0;
     zone_list[i].dl_preamble_en == 1;
     zone_list[i].dl_perm_base == 0;
     zone_list[i].prbs_id == 0;
     zone_list[i].padding_samples == 0;
     zone_list[i].burst_buffer_index == 0;
     zone_list[i].rotation_buffer_index == 0;
     zone_list[i].permutation_table_index == 0;
     zone_list[i].antenna_coef_ptr == 0;
   }
}

constraint phy_zone::cst_phy_zone_user {
   foreach (burst_slots[i]) {
     burst_slots[i] == 20;
     (i == 0) -> start_subchan[i] == 0;
     (i == 1) -> start_subchan[i] == 10;
     (i == 2) -> start_subchan[i] == 20;
   }
   foreach (burst_list[i]) {
     burst_list[i].burst_type == phy_burst::REGULAR_BURST;
     burst_list[i].repetition == 0;
     burst_list[i].coding_type == phy_burst::CC_CODING;
     burst_list[i].interleaver_bypass == 0;
     burst_list[i].scrambler_bypass == 0;
     burst_list[i].boosting   == phy_burst::NORMAL;
     (i == 0) -> burst_list[i].modulation_type == phy_burst::QPSK;
     (i == 1) -> burst_list[i].modulation_type == phy_burst::QAM_16;
     (i == 2) -> burst_list[i].modulation_type == phy_burst::QAM_64;
     (i == 0) -> burst_list[i].coding_rate == 0;
     (i == 1) -> burst_list[i].coding_rate == 2;
     (i == 2) -> burst_list[i].coding_rate == 1;
   }
}

phy_env env;

initial begin
  env = new;
  env.run();
end

endprogram


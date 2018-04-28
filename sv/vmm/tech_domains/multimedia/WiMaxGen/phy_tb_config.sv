/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


`define PHY_DL_SUBCHANS_PER_MAJOR_GROUP 6
`define PHY_DL_SUBCHANS_PER_MINOR_GROUP 4

`define PHY_10MHZ_UL_NUM_OF_SUBCHANNELS 35
`define PHY_10MHZ_DL_PUSC_NUM_OF_SUBCHANNELS 30
`define PHY_10MHZ_DL_FUSC_NUM_OF_SUBCHANNELS 16

class phy_tb_config;
  rand int num_of_frames;
  int BW_MHz = 10;
  int frame_length  = 48;
  int IDcell = 0;

  rand int unsigned num_of_dl_pusc_subchannels;
  rand int unsigned num_of_dl_fusc_subchannels;
  rand int unsigned num_of_ul_subchannels;

  default constraint cst_phy_tb_config_default {
    num_of_frames == 2;

  }

  constraint cst_phy_tb_config_valid {
     if (BW_MHz == 10) {
	num_of_dl_pusc_subchannels == `PHY_10MHZ_DL_PUSC_NUM_OF_SUBCHANNELS;
	num_of_dl_fusc_subchannels == `PHY_10MHZ_DL_FUSC_NUM_OF_SUBCHANNELS;
	num_of_ul_subchannels == `PHY_10MHZ_UL_NUM_OF_SUBCHANNELS;
     }
  }

  constraint cst_user;


endclass


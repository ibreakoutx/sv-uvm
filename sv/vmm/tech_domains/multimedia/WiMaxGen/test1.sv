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

initial begin
    phy_env env = new;
    env.run();
    $display("--------------------------------------------------------");
end

endprogram


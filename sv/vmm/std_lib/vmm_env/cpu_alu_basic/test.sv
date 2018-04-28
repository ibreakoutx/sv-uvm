/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


program alu_test(alu_if.drvprt alu_drv_port, alu_if.monprt alu_mon_port);

`include "alu_env.sv"

alu_env env;
initial begin
  env = new(alu_drv_port, alu_mon_port);
  env.run();
end

endprogram

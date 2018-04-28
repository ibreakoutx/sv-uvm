/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


module tb_top;

simple_if left(), right();
bit clk = 0;
bit rst = 0;

dropsys dut(left.cfg, left.addr[19:0], left.data, left.rd, left.wr,
            right.addr[19:0], right.data, right.rd, right.wr,
            clk, rst);

always #5 clk = ~clk;

endmodule

/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                      			     *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 ********************************************************************/

`define M1 1000
`include "macro_addon.svh"
module top;
reg [`M1-1:0] r1;
        initial begin
                #100 assert($size(r1) == 100) $display("Test `undefineall passed"); else $display("test failed");
        end
endmodule


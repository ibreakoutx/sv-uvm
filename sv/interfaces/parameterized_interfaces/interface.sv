/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

interface Bus #(A_WIDTH = 32, D_WIDTH = 32) (input bit clk);  // Parameters address and data widths
  logic [A_WIDTH - 1:0] Addr;
  logic [D_WIDTH - 1:0] Data;
  logic RW;

  clocking send_cb @(posedge clk);
    output Addr;
    inout  Data;
    output RW;
  endclocking 

  clocking receive_cb @(posedge clk);
    input  Addr;
    inout  Data;
    input  RW;
  endclocking

  modport sender(clocking send_cb);
  modport receiver(clocking receive_cb);
endinterface

/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


`ifndef DROPSYS__SV
`define DROPSYS__SV

module dropsys(
  // Left side interface
  input        lcfg,   // In-band device configuration
  input [19:0] laddr,  // Address
  inout [15:0] ldata,  // R/W data
  input        lrd,    // Read strobe
  input        lwr,    // Write strobe

  // Right side interface
  input [19:0] raddr,  // Address
  inout [15:0] rdata,  // R/W data
  input        rrd,    // Read strobe
  input        rwr,    // Write strobe

  input        clk, rst);

wire lcs0 = (lcfg) ? laddr[16] : (laddr[19:16] == 4'b0);
wire lcs1 = (lcfg) ? laddr[17] : (laddr[19:16] == 4'b1);

wire rcs0 = raddr[19:16] == 4'b0;
wire rcs1 = raddr[19:16] == 4'b1;

dropbox u0(lcfg, lcs0, laddr[15:0], ldata, lrd, lwr,
           rcs0, raddr[15:0], rdata, rrd, rwr,
           clk, rst);
dropbox u1(lcfg, lcs1, laddr[15:0], ldata, lrd, lwr,
           rcs1, raddr[15:0], rdata, rrd, rwr,
           clk, rst);

endmodule

`endif

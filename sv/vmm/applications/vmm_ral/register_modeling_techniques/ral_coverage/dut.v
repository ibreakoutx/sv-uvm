/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

module dut(input  [7:0] wdata, 
           output [7:0] rdata, 
           input  [31:0] addr, 
           input  direction, 
           input  enable,
           input  clk,
           input  rst_n);
initial $dumpvars;

wire[7:0] rdata1, rdata2;

assign rdata = addr[8]?rdata2:rdata1;

  dut_block b1(wdata, rdata1, addr[7:0], direction, (!addr[8] & enable), clk, rst_n);
  dut_block b2(wdata, rdata2, addr[7:0], direction, (addr[8] & enable), clk, rst_n);

   
endmodule

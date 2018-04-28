/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

interface cpu_if (input bit clk,
  output bit		busRdWr_N,
  output bit		adxStrb,
  output bit[7:0]	busAddr,
  output bit 	request,
  inout wire [7:0]	busData,
  input  bit	grant);

  clocking cb @(posedge clk);
    input grant;
    output request;
    output busAddr;
    inout  busData;
    output adxStrb;
    output busRdWr_N;
  endclocking

  modport drvprt(clocking cb);
endinterface


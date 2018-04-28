/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`ifndef __ALU_IF__
`define __ALU_IF__

  interface alu_if (input bit clk);
    logic  [6:0]  y ;
    logic  [3:0]  a ;
    logic  [3:0]  b ;
    logic  [2:0]  sel ;
    logic  rst_n ;
    logic  en ;

    clocking cb @(posedge clk);
      input y;
      output a;
      output b;
      output sel;
      output en;
    endclocking

    clocking mon_cb @(posedge clk);
      input y;
      input a;
      input b;
      input sel;
      input en;
    endclocking

    //modport dutprt(output y, input a, input b, input sel, input rst_n, input en);
    modport drvprt(clocking cb, output rst_n);
    modport monprt(clocking mon_cb);

  endinterface

`endif // __ALU_IF__

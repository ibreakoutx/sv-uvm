/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/




interface dut_if(input bit clk);

 reg [15:0] wdata;
 reg [15:0] rdata;
 reg [31:0] addr;
 reg direction;
 reg enable;
  
 clocking cb @(posedge clk);
   output wdata;
   output addr;
   output direction;
   output enable;
   input  rdata;
 endclocking

 modport mst(clocking cb);
endinterface


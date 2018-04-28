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

 logic [15:0] wdata;
 logic [15:0] rdata;
 logic [7:0] addr;
 logic [1:0] byte_en;
 logic direction;
 logic enable;
  
 clocking cb @(posedge clk);
   output wdata;
   output addr;
			output byte_en;
   output direction;
   output enable;
   input  rdata;
 endclocking

 modport mst(clocking cb);
endinterface


/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

module sram_test;
 reg ce_N, rdWr_N;
 reg [5:0] ramAddr;
 wire [7:0] ramData;

 sram sram1(.ce_N(ce_N), .rdWr_N(rdWr_N), .ramAddr(ramAddr), .ramData(ramData));

 initial begin
    ce_N = 1;
    rdWr_N = 1;
    ramAddr = 0;
    
    #10;
    ce_N = 0;
    rdWr_N = 0;
    ramAddr = 5;

    #10;
    ce_N = 1;
    rdWr_N = 1;
    ramAddr = 0;

    #10;
    ce_N = 0;
    rdWr_N = 1;
    ramAddr = 5;
    
    #10
    ce_N = 1;
    rdWr_N = 1;
    ramAddr = 0;
    
    #25;
    ce_N = 1;
    rdWr_N = 1;
    ramAddr = 0;
    
   end 

   assign ramData = (~ce_N & ~rdWr_N) ?  10 : 8'bzzzzzzzz;
 endmodule


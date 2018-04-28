/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


module sram(ce_N, rdWr_N, ramAddr, ramData);

input ce_N, rdWr_N;
input [5:0] ramAddr;
inout [7:0] ramData;

logic [7:0] chip[63:0];

assign ramData = (~ce_N & rdWr_N) ?  chip[ramAddr] : 8'bzzzzzzzz;

always @(ce_N or rdWr_N)
begin
   if(~ce_N && ~rdWr_N)
     chip[ramAddr] = ramData;
end

endmodule

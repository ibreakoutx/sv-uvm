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

read : assert property (@( posedge ce_N ) rdWr_N |-> (~ce_N && rdWr_N));
write : assert property (@( posedge ce_N ) (~rdWr_N) |->  (~ce_N && ~rdWr_N));


covergroup addr_cov @ (negedge ce_N);
    addr: coverpoint ramAddr {
              bins small_range = {[0:10]};
              bins big_range = {[11:100]};
          }
endgroup    

initial begin
    addr_cov sram_addr_cov = new;
    $display ("a\$b");
end    

endmodule

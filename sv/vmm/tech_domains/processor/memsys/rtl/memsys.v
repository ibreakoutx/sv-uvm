/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


module memsys(clk, reset, busAddr, busData, busRdWr_N, adxStrb, request, grant);

input clk, reset, busRdWr_N, adxStrb;
input [7:0] busAddr;
input [1:0] request;
output [1:0] grant;
inout [7:0] busData;

wire [5:0] ramAddr;
wire [7:0] ramData;
wire rdWr_;

cntrlr Umem(clk, reset, busAddr, busData, busRdWr_N, adxStrb, rdWr_,ce0_,
         ce1_, ce2_, ce3_, ramAddr, ramData);

arb Urrarb(clk, reset, request, grant) ;

sram u0(ce0_, rdWr_, ramAddr, ramData);
sram u1(ce1_, rdWr_, ramAddr, ramData);
sram u2(ce2_, rdWr_, ramAddr, ramData);
sram u3(ce3_, rdWr_, ramAddr, ramData);

initial 
begin
//   $display("reset, request, grant, adxStrb, busAddr, busData, rdWr_");
//   $monitor($time," %b %b %b %b %h %h %b",reset, request, grant, adxStrb, busAddr, busData, busRdWr_);
end

endmodule

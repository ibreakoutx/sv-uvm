/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

module ec(
   input clk,
   input  [15:0] addr,
   input rd,
   input wr,
   inout [63:0] data, // inout
   input ale,
   input rst_,
   input sot
);
   reg [63:0] register [0:127];
   reg [15:0] taddr;
   reg [63:0] tmp_data;
   assign data = (rd) ? tmp_data : 64'hZ;

   // initial begin
   //    $display("module ec started ");
   //  end

   always @(posedge rst_)
      begin
         register[0] = 64'h10;
         register[1] = 64'h11;
         register[2] = 64'h12;
         register[3] = 64'h13;
         register[4] = 64'h14;
      end
	
   always @(negedge ale)
      begin
        taddr = addr[15:3]; 
      end
	
   always @(posedge rd)
      begin
         $display("ec.v is being read from addr=%h, data = %h \n", addr, register[taddr]);
         tmp_data = register[taddr]; 
      end

   always @(posedge wr)
      begin
         $display("ec.v is being written to  addr=%h, data = %h \n", addr, data); 
         register[taddr] = data; 
      end


endmodule

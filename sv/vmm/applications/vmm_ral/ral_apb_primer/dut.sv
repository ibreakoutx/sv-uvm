/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

// 
// -------------------------------------------------------------
//    Copyright 2004-2008 Synopsys, Inc.
//    All Rights Reserved Worldwide
// 
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
// 
//        http://www.apache.org/licenses/LICENSE-2.0
// 
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
// 


module slave(input  [15:2] paddr,
             input         psel,
             input         penable,
             input         pwrite,
             output [31:0] prdata,
             input  [31:0] pwdata,
             input         clk,
             input         rst);

reg [31:0] pr_data;
assign prdata = (psel && penable && !pwrite) ? pr_data : 'z;

reg BUSY, TXEN, RDY;
reg [2:0] MODE;
reg RDY_MSK;
reg [31:0] COUNTERS[256];
reg [31:0] DMA[1024];

always @ (posedge clk)
  begin
   if (rst) begin
      BUSY <= 1'b0;
      TXEN <= 1'b0;
      MODE <= 3'b000;
      RDY  <= 1'b0;
      RDY_MSK <= 1'b0;
      foreach (COUNTERS[i]) begin
         COUNTERS[i] <= 32'h0000_0000;
      end
   end
   else begin

      // Wait for a SETUP+READ or ENABLE+WRITE cycle
      if (psel == 1'b1 && penable == pwrite) begin
         if (pwrite) begin
            casex ({paddr, 2'b00})
              16'h0010: begin
                 if (pwdata[16]) RDY <= 1'b0;
                 TXEN <= pwdata[1];
                 MODE <= pwdata[4:2];
              end
              16'h0014: RDY_MSK <= pwdata[16];
              16'h2XXX: DMA[paddr[11:2]] <= pwdata;
            endcase
         end
         else begin
            casex ({paddr, 2'b00})
              16'h0000: pr_data <= {4'h0, 10'h176, 8'h5A, 8'h03};
              16'h0010: pr_data <= {15'h0000, RDY, 11'h0000, MODE, TXEN, BUSY};
              16'h0014: pr_data <= {15'h0000, RDY_MSK, 16'h0000};
              16'b0001_00xx_xxxx_xxxx: pr_data <= COUNTERS[paddr[9:2]];
              16'h2XXX: pr_data <= DMA[paddr[11:2]];
            endcase
         end
      end
   end
end

endmodule


/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

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
reg RDY_MSK;
reg [31:0] COUNTERS[256];
reg [31:0] DMA[1024];

always @ (posedge clk)
  begin
   if (rst) begin
      BUSY <= 1'b0;
      TXEN <= 1'b0;
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
                 RDY <= pwdata[1];
              end
              16'h0014: RDY_MSK <= pwdata[16];
              16'h2XXX: DMA[paddr[11:2]] <= pwdata;
            endcase
         end
         else begin
            casex ({paddr, 2'b00})
              16'h0000: pr_data <= {4'h0, 10'h176, 8'h5A, 8'h03};
              16'h0010: pr_data <= {15'h0000, RDY, 14'h0000, TXEN, BUSY};
              16'h0014: pr_data <= {15'h0000, RDY_MSK, 16'h0000};
              16'b0001_00xx_xxxx_xxxx: pr_data <= COUNTERS[paddr[9:2]];
              16'h2XXX: pr_data <= DMA[paddr[11:2]];
            endcase
         end
      end
   end
end

endmodule


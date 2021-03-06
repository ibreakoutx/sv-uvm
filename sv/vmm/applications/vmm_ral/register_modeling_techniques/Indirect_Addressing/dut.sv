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

logic [31:0] CHIP_ID;
reg BUSY, TXEN, RDY;
logic [2:0] MODE;
reg RDY_MSK;
reg PROTECTED;
reg [31:0] COUNTERS[256];
reg [31:0] DMA[1024];
reg [31:0] CONFIG0, CONFIG1, CONFIG2;

reg [31:0] COUNTER_INDEX;
reg [31:0] RIdx;

//CHIP ID
assign CHIP_ID = {4'h0, 10'h176, 8'h5A, 8'h03};

always @ (posedge clk)
  begin
   if (rst) begin
      BUSY <= 1'b0;
      TXEN <= 1'b0;
      MODE <= 3'b000;
      RDY  <= 1'b0;
      RDY_MSK <= 1'b0;
      PROTECTED <= 1'b0;
      foreach (COUNTERS[i]) begin
         COUNTERS[i] <= 32'hdead_dead;
      end
      CONFIG0 <= 32'hdead_beef;
      CONFIG1 <= 32'hdead_beef;
      CONFIG2 <= 32'hdead_beef;
      COUNTER_INDEX <= 32'h0;
      RIdx <= 32'h0;
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
              16'h0014: begin
                 RDY_MSK  <= pwdata[16]; PROTECTED <= pwdata[0];
              end
              16'h0018: CONFIG0 <= pwdata;
              16'h001a: CONFIG1 <= pwdata;
              16'h001c: CONFIG2 <= pwdata;
              16'h0024: COUNTER_INDEX <= pwdata;
              16'h2XXX: DMA[paddr[11:2]] <= pwdata;
            endcase
         end
         else begin
            casex ({paddr, 2'b00})
              16'h0000: pr_data <= CHIP_ID;
              16'h0010: pr_data <= {15'h0000, RDY, 11'b0, MODE, TXEN, BUSY};
              16'h0014: pr_data <= {15'h0000, RDY_MSK, 16'h0000};
              16'h0018: pr_data <= CONFIG0;
              16'h001a: pr_data <= CONFIG1;
              16'h001c: pr_data <= CONFIG2;
              16'h0024: pr_data <= COUNTER_INDEX;
              16'h0028: pr_data <= COUNTERS[COUNTER_INDEX[7:0]];
              16'h2XXX: pr_data <= DMA[paddr[11:2]];
            endcase
         end
      end
   end
end

endmodule


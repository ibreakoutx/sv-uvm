/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/




module dut(input  [7:0] wdata, 
           output reg [7:0] rdata, 
           input  [31:0] addr, 
           input  direction, 
           input  enable,
           input  clk,
           input  rst_n);
  
reg [7:0] ctrl_reg;
reg [7:0] data_reg;
reg [7:0] status_reg;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    ctrl_reg <= 8'hXX;
    data_reg <= 8'hZZ;
				status_reg <= 8'hFF;
  end
  else begin
    if (enable && ~direction) begin //read
      case (addr)
        8'h00 : rdata <= ctrl_reg;
        8'h01 : rdata <= data_reg;
        default : rdata <= status_reg;
      endcase
    end
  end
end   


endmodule


/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/




module dut(input  [15:0] wdata, 
           output reg [15:0] rdata, 
           input  [31:0] addr, 
           input  direction, 
           input  enable,
           input  clk,
           input  rst_n);
  
reg [15:0] vreg [512:0];
reg [15:0] reg1;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
				rdata <= 16'h00;
  end
  else begin
    if (enable && direction) begin //write
						if(addr[31:0] == 'h100)
								reg1 <= wdata;
						else
								vreg[addr] = wdata;
    end
    else if (enable && ~direction) begin //read
						if(addr[31:0] == 'h100)
								rdata <= reg1;
						else
								rdata <= vreg[addr];
    end
  end
end   


endmodule


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
  
reg [15:0] vreg [1023:0];
always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
				rdata <= 16'h00;
  end
  else begin
    if (enable && direction) begin //write
      case (addr[9:8])
        2'h0 : begin
											vreg[addr[9:0]] <= wdata; 
								end	
        2'h1 : begin
											vreg[addr[9:0]][7:0]  <= wdata[7:0];  
											vreg[addr[9:0]][15:8]  <= 8'hFF;  
								end			
        2'h2 : begin
											vreg[addr[9:0]][7:0]  <= wdata[7:0];  
										 if(wdata[15]) vreg[addr[9:0]][15] <= 1'b0;
										 if(wdata[14]) vreg[addr[9:0]][14] <= 1'b0;
										 if(wdata[13]) vreg[addr[9:0]][13] <= 1'b0;
										 if(wdata[12]) vreg[addr[9:0]][12] <= 1'b0;
										 if(wdata[11]) vreg[addr[9:0]][11] <= 1'b0;
										 if(wdata[10]) vreg[addr[9:0]][10] <= 1'b0;
										 if(wdata[9]) vreg[addr[9:0]][9] <= 1'b0;
										 if(wdata[8]) vreg[addr[9:0]][8] <= 1'b0;
								end	
        default : vreg[29] <= 16'hFFFF;  
      endcase
    end
    else if (enable && ~direction) begin //read
      case (addr[9:8])
        2'h0 : begin
											rdata <= vreg[addr[9:0]];  
						     vreg['h200][15:8] <= 8'hFF;
								end	
        2'h1 : begin
											rdata <= vreg[addr[9:0]];
						     vreg['h201][15:8] <= 8'hFF;
								end			
        2'h2 : begin
											rdata <= vreg[addr[9:0]];  
								end	
        default : rdata <= 16'h0000;
      endcase
    end
  end
end   


endmodule

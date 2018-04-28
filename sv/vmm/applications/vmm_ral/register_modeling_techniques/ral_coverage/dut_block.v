/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

module dut_block(input  [7:0] wdata, 
           output reg [7:0] rdata, 
           input  [7:0] addr, 
           input  direction, 
           input  enable,
           input  clk,
           input  rst_n);
  
reg [7:0] ctrl_reg;
logic [7:0] data_reg;
reg [7:0] status_reg;
reg [3:0] tmp1,tmp2;
reg [0:7] temp_reg;
   integer i;
   
   
always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    ctrl_reg <= 8'hAA;
    data_reg <= 8'b10X0_Z00Z;
    status_reg <= 8'h00;
				tmp1       <= 4'b0;
				tmp2       <= 4'b0;
     temp_reg <= 8'b0;
     
  end
  else begin
     if (enable && direction) begin //write
      status_reg[0] <= 0;
      case (addr)
        8'h00 : ctrl_reg <= ~(wdata); 
        8'h01 : data_reg <=  wdata;
        default: begin status_reg[0] <= 1; temp_reg <= 1; end
	   
      endcase
    end
    else if (enable && ~direction) begin //read
      status_reg[1] <= 0;
      case (addr)
        8'h00 : rdata <= ctrl_reg;
        8'h01 : rdata <= 8'bX0X0_100Z; //data_reg;
        8'h02 : rdata <= status_reg;
        default: status_reg[1] <= 1;
      endcase
    end
  end
end   

   always @(posedge clk)
   begin
      if(enable && ~direction)
	begin
	   for(i=0;i<7;i=i+1)
	     temp_reg[i] = 1'b0;
	end
   end
   
endmodule

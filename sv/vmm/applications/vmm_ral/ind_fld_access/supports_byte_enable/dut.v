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
           input  [7:0] addr, 
											input  [1:0] byte_en,
           input  direction, 
           input  enable,
           input  clk,
           input  rst_n);
  
reg [3:0] a; 
reg [3:0] b;
reg [4:0] c;
reg [16:0] d;
reg [32:0] e;
reg [24:0] f;
reg [16:0] g;
reg [23:0] h;


always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
  end
  else begin
    if (enable && direction) begin //write
      case (addr)
        00 : begin if(byte_en[1]) c <= wdata[15:12]; if(byte_en[0]) {b,a} <= wdata[7:0]; end
        01 : begin if(byte_en[0]) d <= wdata[7:0]; end
        02 : begin if(byte_en[1]) e[15:8] <= wdata[15:8]; if(byte_en[0]) e[15:8] <= wdata[7:0]; end
        03 : begin if(byte_en[1]) e[31:24] <= wdata[15:8]; if(byte_en[0]) e[23:16] <= wdata[7:0]; end
        04 : begin if(byte_en[1]) f[15:8] <= wdata[15:8]; if(byte_en[0]) f[15:8] <= wdata[7:0]; end
        05 : begin if(byte_en[1]) g[7:0] <= wdata[15:8]; if(byte_en[0]) f[23:16]<= wdata[7:0]; end
        06 : begin if(byte_en[1]) h[7:0] <= wdata[15:8]; if(byte_en[0]) g[15:8] <= wdata[7:0]; end
        07 : begin if(byte_en[1]) h[23:16]<= wdata[15:8]; if(byte_en[0]) h[15:8] <= wdata[7:0]; end
        default: ;
      endcase
    end
    else if (enable && ~direction) begin //read
      case (addr)
        00 : begin if(byte_en[1]) rdata[15:12] <= c; if(byte_en[0]) rdata[7:0] <= {b,a} ; end
        01 : begin if(byte_en[0]) rdata[7:0] <= d; end
        02 : begin if(byte_en[1]) rdata[15:8] <= e[15:8] ; if(byte_en[0]) rdata[7:0] <= e[15:8] ; end
        03 : begin if(byte_en[1]) rdata[15:8]<= e[31:24] ; if(byte_en[0]) rdata[7:0] <= e[23:16]; end
        04 : begin if(byte_en[1]) rdata[15:8]<= f[15:8]  ; if(byte_en[0]) rdata[7:0] <= f[15:8] ; end
        05 : begin if(byte_en[1]) rdata[15:8]<= g[7:0]   ; if(byte_en[0]) rdata[7:0] <= f[23:16]; end
        06 : begin if(byte_en[1]) rdata[15:8]<= h[7:0]   ; if(byte_en[0]) rdata[7:0] <= g[15:8] ; end
        07 : begin if(byte_en[1]) rdata[15:8]<= h[23:16] ; if(byte_en[0]) rdata[7:0] <= h[15:8] ; end
        default: ;
      endcase
    end
  end
end   
endmodule

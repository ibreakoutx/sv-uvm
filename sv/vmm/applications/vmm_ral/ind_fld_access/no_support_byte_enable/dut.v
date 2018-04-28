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
        00 : begin {b,a} <=  {wdata[7:4],wdata[3:0]};  c <= wdata[15:12]; end
        01 : d <= wdata[7:0]; 
        02 : e[15:0] <= wdata;
        03 : e[31:16]<= wdata;
        04 : f[15:0] <= wdata;
        05 : {g[7:0],f[23:16]} <= wdata; 
        06 : {h[7:0],g[15:8]} <= wdata ;
        07 : {h[23:8]} <= wdata ; 
        default: ;
      endcase
    end
    else if (enable && ~direction) begin //read
      case (addr)
        00 : rdata <= {c,4'h0,b,a} ;
        01 : rdata <= d ;
        02 : rdata <= e[15:0]; 
        03 : rdata <= e[31:16];
        04 : rdata <= f[15:0]; 
        05 : rdata <= {g[7:0],f[23:16]};  
        06 : rdata <= {h[7:0],g[15:8]}; 
        07 : rdata <= {h[23:8]};
        default: ;
      endcase
    end
  end
end   
endmodule


module dut(input  [7:0] wdata, 
output reg [7:0] rdata, 
input  [7:0] addr, 
input  direction, 
input  enable,
input  clk,
input  rst_n);

reg [3:0] cntr; 
reg [3:0] cnt1, cnt2;
reg [7:0] reg1, reg2;

always @(posedge clk or negedge rst_n)
begin
if (!rst_n) begin
 cntr <= 'h00;
 cnt2 <= 'h0;
end
else begin
 cntr <= cntr + 3;
 cnt2 <= cnt2 + 1;
end
end		


always @(posedge clk or negedge rst_n)
begin
if (!rst_n) begin
 reg1 <= 'h00;
 reg2 <= 'h00;
 cnt1 <= 'h0;
end
else begin
 if (cntr == 'hF) reg1 <= reg1 + 1;
 if (cnt2 == 'hF) cnt1 <= cnt1 + 1;
 if (enable && direction) begin 
  case (addr)
   00 : reg1  <= wdata;
   01 : reg2  <= wdata;
   02 : cnt1  <= wdata[3:0];
   default: ;
  endcase
 end
 else if (enable && ~direction) begin //read
  case (addr)
   00 : rdata <= reg1 ;
   01 : rdata <= reg2 ;
   02 : rdata <= {cnt2,cnt1};
   default: ;
  endcase
 end
end
end   
endmodule


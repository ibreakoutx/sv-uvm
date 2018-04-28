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
    ctrl_reg <= 8'h00;
    data_reg <= 8'h00;
    status_reg <= 8'h00;
  end
  else begin
    if (enable && direction) begin //write
      status_reg[0] <= 1;
      case (addr)
        8'h01 : ctrl_reg <= wdata; 
        8'h02 : data_reg <= wdata;
        default: data_reg <= wdata;
      endcase
    end
    else if (enable && ~direction) begin //read
      status_reg[4] <= 1;
      case (addr)
        8'h00 : rdata <= status_reg;
        8'h01 : rdata <= ctrl_reg;
        8'h02 : rdata <= data_reg;
        default: rdata <= 8'h00;
      endcase
    end
  end
end   

endmodule

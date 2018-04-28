module top;

  logic rst_n, clk;

  dut_if dif(clk);

  dut dut(dif.wdata, dif.rdata, dif.addr, dif.direction, dif.enable, clk, rst_n);

  test t(dif.mst);

initial begin
  clk = 0;
  forever begin
    #5 clk = ~clk;
  end
end
endmodule


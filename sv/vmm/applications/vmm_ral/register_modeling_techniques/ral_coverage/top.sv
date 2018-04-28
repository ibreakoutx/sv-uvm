/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


module top;

  logic rst_n, clk;

  dut_if dif(clk);

  dut dut(dif.wdata, dif.rdata, dif.addr, dif.direction, dif.enable, clk, rst_n);

  test t();

initial begin
  clk = 0;
  forever begin
    #5 clk = ~clk;
  end
end
endmodule


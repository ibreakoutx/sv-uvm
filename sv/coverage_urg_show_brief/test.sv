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

bit [3:0] v_a, v_b;
reg clk;

covergroup cg @(posedge clk);
  a: coverpoint v_a {
     bins a1 = {[0:3]};
     bins a2 = {[4:7]};
     bins a3 = {[8:11]};
     bins a4 = {[11:15]};
  }
  b: coverpoint v_b {
     bins b1 = {0};
     bins b2 = {[1:8]};
     bins b3 = {[9:13]};
     bins b4 = {[14:15]};
  }
  c: cross a, b {
     wildcard bins c1 = binsof(a) intersect {4'b11??};
     wildcard bins c2 = !binsof(b) intersect {4'b1?0?};
  }
endgroup

initial
begin
   clk = 0;
   forever #50 clk = ~clk;
end

initial
begin
   cg cg1 = new();
   v_a = 4;
   v_b = 0;
   @(posedge clk);
   v_a = 9;
   v_b = 14;
   @(posedge clk);
   #1000;
   $finish;
end
   
endmodule

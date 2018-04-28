/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



module A (a1,a2,a3);
input logic [3:0][1:0] a1;
input logic [3:0][1:0] a2;
output logic [3:0][1:0] a3;

always_comb
  a3 = a1 ^ a2;


endmodule

module B (b1,b2,b3);
input bit [3:0][1:0] b1;
input bit [3:0][1:0] b2;
output bit [3:0][1:0] b3;

always_comb
  b3 = b1 ~^ b2;

endmodule

module C (clk,c1,c2,c3);
input bit clk;
input logic [3:0][1:0] c1;
input bit [3:0][1:0] c2;
output reg [3:0][1:0] c3;

always_ff @(posedge clk)
  c3 <= c1 | c2;


endmodule


module top;
logic [3:0][1:0] t1;
logic [3:0][1:0] t2;
bit [3:0][1:0] t3;
bit [3:0][1:0] t4;
bit clk = 1'b0;
logic [3:0][1:0] t5;
bit [3:0][1:0] t6;
logic [3:0][1:0] t7;

A a_inst(t1,t2,t5);
B b_inst(t3,t4,t6);
C c_inst(clk,t5,t6,t7);

initial
begin
  clk = 'b0; t1 = {4'd0, 4'd0}; t2 = {4'd0, 4'd0}; t3 = {4'd0, 4'd0}; t4 = {4'd0, 4'd0};
  #5 t1 = {4'd5, 4'd9}; t2 = {4'd1, 4'd15}; t3 = {4'd10, 4'd8}; t4 = {4'd4, 4'd6};
  #5 t1 = {4'd10, 4'd7}; t2 = {4'd12, 4'd10}; t3 = {4'd15, 4'd10}; t4 = {4'd6, 4'd13};
  #10 $finish;
end


always @(clk)
   #2 clk <= ~clk;

initial begin
  $monitor("%0d : CLK=%b : T1=%b : T2=%b : T3=%b: T4=%b : T5=%b : T6=%b : T7=%b",$time,clk,t1,t2,t3,t4,t5,t6,t7);
  //$dumpvars;
end
  
endmodule

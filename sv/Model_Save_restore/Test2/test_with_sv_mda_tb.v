/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



`timescale 1ns/1ns

module tb ();

  logic  clk = 0;
  logic  rst = 0; 
  logic  [3:0] in0;
  logic  [3:0] in1;
  logic  [3:0] in2;
  logic  [3:0] in3;
  logic  [3:0] out1;
  logic  glb_clk = 0;
  logic [3:0] data1 [3:0];

  simple_2d u1 (.in0(in0), .in1(in1), .in2(in2), .in3(in3),
                .out1(out1), .clk(clk), .rst(rst), .data1(data1));
typedef struct {
  logic [3:0] struct_mda [3:0];
} str1;

function [3:0] my_xor (input [3:0] a, input [3:0] b);
  my_xor = a ^ b;
endfunction

str1 s1[3:0];

always @(clk)
  clk <= #5 ~clk;

always @(glb_clk)
  glb_clk <= #20 ~glb_clk;

  initial
  begin
    in0 = 0; in1 = 2; in2 = 4; in3 = 1;
    # 25 rst = 1;
  end

  always @(glb_clk)
    begin
      #5 in0 <= in0 + 1;
      #5 in1 <= in1 + 1;
      #5 in2 <= in2 + 1;
      #5 in3 <= in3 + 1;
    end

always @(glb_clk)
begin
  s1[0].struct_mda <= data1;
  s1[1].struct_mda <= data1;
  s1[2].struct_mda <= data1;
  s1[3].struct_mda <= data1;
  $display("Struct array = %p",s1);
end


initial
  #200 $finish;

initial 
  $monitor("%0d: CLK=%b : RST=%b :IN0=%b : IN1=%b : IN2=%b : IN3=%b : OUT1=%b : S1_MDA_DATA[0]=%d : S_MDA_DATA[1]=%d : S1_MDA_DATA[2]=%d : S1_MDA_DATA[3]=%d",$time,clk,rst,in0,in1,in2,in3,out1,s1[0].struct_mda[0],s1[0].struct_mda[1],s1[0].struct_mda[2],s1[0].struct_mda[3]);


endmodule


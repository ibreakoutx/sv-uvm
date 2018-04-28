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

module m1 (in0, in1, in2, in3, out1, clk, rst);

  input  clk, rst;
  input  [3:0] in0;
  input  [3:0] in1;
  input  [3:0] in2;
  input  [3:0] in3;
  output [3:0] out1;
  logic  [3:0] out1;
  logic  [3:0] data [3:0];

  always @ (posedge clk)
  begin
    if (rst == 0)
    begin
      out1 <= 0;
      data[0] <= -1;
      data[1] <= 1;
      data[2] <= 3;
      data[3] <= 5;
    end
    else
    begin
      data[3] <= data[0] + (in2 ^ in0);
      data[2] <= data[3] ^ in3;
      data[1] <= data[2] | in2;
      data[0] <= data[1] + in1;
      out1 <= out1 ^ (in0 + data[0]);
    end
  end

endmodule

module m2 (in0, in1, in2, in3, out1, clk, rst, data);

  input  clk, rst;
  input  [3:0] in0;
  input  [3:0] in1;
  input  [3:0] in2;
  input  [3:0] in3;
  output [3:0] out1;
  logic [3:0] out1;
  output logic [3:0] data [3:0];
  wire [3:0] t1;

  m1 u1 (.in0(in1), .in1(in2), .in2(in3), .in3(in0),
         .out1(t1), .clk(clk), .rst(rst));

  always @ (posedge clk)
  begin
    if (rst == 0)
    begin
      out1 <= -1;
      data[0] <= 0;
      data[1] <= 1;
      data[2] <= 2;
      data[3] <= 3;
    end
    else
    begin
      data[3] <= data[0] & (in2 + in0);
      data[2] <= data[3] | in3;
      data[1] <= data[2] ^ (in2 ^ t1);
      data[0] <= data[1] - in1;
      out1 <= out1 ^ (in1 + t1 + data[0]);
    end
  end

endmodule


module simple_2d (in0, in1, in2, in3, out1, clk, rst, data1);

  input  clk, rst;
  input  [3:0] in0;
  input  [3:0] in1;
  input  [3:0] in2;
  input  [3:0] in3;
  output [3:0] out1;
  logic [3:0] out1;
  logic [3:0] data [3:0];
  output logic [3:0] data1 [3:0];

  wire [3:0] t1;
  wire [3:0] t2;

  m1 u1 (.in0(in0), .in1(in1), .in2(in2), .in3(in3),
         .out1(t1), .clk(clk), .rst(rst));
  m2 u2 (.in0(t1), .in1(in0), .in2(in3), .in3(in1),
         .out1(t2), .clk(clk), .rst(rst), .data(data1));

  always @ (posedge clk)
  begin
    if (rst == 0)
    begin
      out1 <= 0;
      data[0] <= 0;
      data[1] <= 1;
      data[2] <= 2;
      data[3] <= 3;
    end
    else
    begin
      data[0] <= data[0] + t1;
      data[1] <= data[1] ^ t2;
      data[2] <= data[2] - in2;
      data[3] <= data[3] + in0;
      out1 <= out1 + (data[0] ^ data[1] ^ data[2] ^ data[3]);
    end
  end



endmodule


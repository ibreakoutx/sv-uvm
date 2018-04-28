/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`define ADD 3'b000
`define SUB 3'b001
`define MUL 3'b010
`define LS  3'b011
`define RS  3'b100

module alu(y, a, b, sel, clk, rst_n, en);
input [3:0] a,b;
input [2:0] sel;
input clk, rst_n, en;
output [6:0] y;
reg [6:0] y, y_temp;

always @(a or b or sel)
begin
  if (en)
    begin
      case (sel)
        `ADD : y_temp = a + b;
        `SUB : y_temp = a - b;
        `MUL : y_temp = a * b;
        `LS  : y_temp = a << 1;
        `RS  : y_temp = a >> 1;
       default : y_temp = 0;
      endcase 
    end
  else
     y_temp = 0;

end

always @(posedge clk or negedge rst_n)
  if (!rst_n)
     y <= 0;
  else 
     y = y_temp;


endmodule

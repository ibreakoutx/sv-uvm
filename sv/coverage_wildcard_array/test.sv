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
  reg clk;
  bit[2:0] signala;

  initial begin
     clk = 0;
     forever #50 clk = ~clk;
  end

  covergroup Foo;
     coverpoint signala {
        wildcard bins a1[] = {3'b00?};  // 3'b000, 3'b001
        wildcard bins a2[] = {4'b100?, 4'b11?1};
        wildcard bins a3[] = {3'b00x -> 3'b001};  // 3'b100=>3'b001 and 3'b000=>3'b001
     }
  endgroup
  
  initial begin
     Foo foo = new();
     signala = 0;	
     foo.sample();   // a1
     signala = 1;
     foo.sample();   // a2
     #1000; 
     $finish;
   end
     
endmodule

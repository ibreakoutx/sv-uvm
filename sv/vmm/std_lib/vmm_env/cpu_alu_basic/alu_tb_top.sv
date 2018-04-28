/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`include "alu_if.sv"

module alu_tb_top;
  parameter simulation_cycle = 100 ;
  
  reg  SystemClock ;
  wire  [6:0]  y ;
  wire  [3:0]  a ;
  wire  [3:0]  b ;
  wire  [2:0]  sel ;
  wire  clk ;
  wire  en ;
  assign  clk = SystemClock ;

  alu_if aluif(clk);
  alu_test tb (aluif.drvprt, aluif.monprt);

  alu dut(
    .y ( aluif.y ),
    .a ( aluif.a ),
    .b ( aluif.b ),
    .sel ( aluif.sel ),
    .clk ( clk ),
    .rst_n ( aluif.rst_n ),
    .en ( aluif.en )
  );

  initial begin
    $vcdpluson;
    SystemClock = 0 ;
    forever begin
      #(simulation_cycle/2) 
        SystemClock = ~SystemClock ;
    end
  end
  
endmodule  

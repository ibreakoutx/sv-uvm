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
  bit rst, clk;
  intf    i1(rst, clk);
  env     e1(i1);
  design  d1(i1);
  initial begin
    clk = 0;
    forever begin
      #5 clk = 1;
      #5 clk = 0;
    end
  end
endmodule



interface intf(input rst, clk);
  logic [1:2] select; // operation
  logic [1:4] dtoe; // dut to env data
  logic [1:4] etod; // env to dut data
  wire [1:4] bus; // bidirectional data
  modport env    (inout bus, 
                  output etod, select,
                  input dtoe, rst, clk);
  modport design (inout bus, 
                  output dtoe,
                  input etod, select, rst, clk);
endinterface



program env(intf.env if1);
  clocking cb @(posedge if1.clk);
    output select = if1.select;
    input  dtoe = if1.dtoe;
    output etod = if1.etod;
    inout bus = if1.bus;
  endclocking

  task doit(input logic [1:2] sel, input logic [1:4] toe, bd);
 	   cb.select <= sel;
 	   cb.etod <= toe;
 	    cb.bus <= bd;
  endtask
 

 initial begin
    cb.etod <= 4'b0000;
    cb.bus <= 4'bz;
    @cb doit(2'b00, 4'b1001, 4'bzzzz);
    @cb doit(2'b01, 4'b0110, 4'bzzzz);
    @cb doit(2'b10, 4'b0101, 4'b01x1);
    @cb doit(2'b11, 4'b0001, 4'bzzzz);
    @cb $finish(0);
  end

  initial forever @cb begin
    $display("at %0d, in %m: select=%b etod=%b dtoe=%b bus=%b", 
      $time, if1.select, if1.etod, if1.dtoe, if1.bus);
  end

endprogram


module design(intf.design if1);
  wire clk = if1.clk;
  wire [1:2] select = if1.select;
  reg [1:4] dtoe, busdrv;
  assign if1.dtoe = dtoe;
  assign if1.bus = busdrv;
  always @(posedge clk) begin
    dtoe <= 0;
    busdrv <= 'bz;
    case (select)
    2'b00: ;
    2'b01: dtoe <= if1.etod;
    2'b10: busdrv <= if1.etod;
    2'b11: dtoe <= if1.bus;
    endcase
  end
endmodule


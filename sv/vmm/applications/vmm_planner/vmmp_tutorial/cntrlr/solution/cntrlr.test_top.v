/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

interface cntrlr_intf(input clk); 
  wire  reset ;
  wire  [7:0]  busAddr ;
  wire  [7:0]  busData ;
  wire  busRdWr_N ;
  wire  adxStrb ;
  wire  rdWr_N ;
  wire  ce0_N ;
  wire  ce1_N ;
  wire  ce2_N ;
  wire  ce3_N ;
  wire  [5:0]  ramAddr ;
  wire  [7:0]  ramData ;

clocking CBcntrlr @(posedge clk);
  output reset,busAddr,busRdWr_N,adxStrb;
  input rdWr_N,ce0_N,ce1_N,ce2_N,ce3_N,ramAddr;
  inout busData,ramData; 
endclocking 
endinterface

module cntrlr_test_top;
  parameter clock_cycle = 100 ;
  bit   clk ;

  cntrlr_intf intf(clk); 

  cntrlr_test testbench(intf); 

  cntrlr dut(
    .clk ( clk ),
    .reset ( intf.reset ),
    .busAddr ( intf.busAddr ),
    .busData ( intf.busData ),
    .busRdWr_N ( intf.busRdWr_N ),
    .adxStrb ( intf.adxStrb ),
    .rdWr_N ( intf.rdWr_N ),
    .ce0_N ( intf.ce0_N ),
    .ce1_N ( intf.ce1_N ),
    .ce2_N ( intf.ce2_N ),
    .ce3_N ( intf.ce3_N ),
    .ramAddr ( intf.ramAddr ),
    .ramData ( intf.ramData )
  );

  initial begin
    clk = 1'b0;
    forever begin
      #(clock_cycle/2) 
        clk = ~clk;
    end
  end
endmodule  

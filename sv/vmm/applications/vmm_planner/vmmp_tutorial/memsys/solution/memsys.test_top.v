/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

interface memsys_intf(input clk); 
  wire  reset ;
  wire  [7:0]  busAddr ;
  wire  [7:0]  busData ;
  wire  busRdWr_N ;
  wire  adxStrb ;
  wire  [1:0]  request ;
  wire  [1:0]  grant ;

clocking CBmemsys @(posedge clk); 
output reset,busAddr;
inout busData; 
output busRdWr_N; 
output adxStrb; 
output request; 
input grant; 
endclocking

endinterface


module memsys_test_top;
  parameter clock_cycle = 100 ;
  bit   clk ;
  memsys_intf intf(clk); 

  memsys_test testbench(intf); 

  memsys dut(
	.clk ( clk ),
    	.reset ( intf.reset ),
   	.busAddr ( intf.busAddr ), 
	.busData ( intf.busData ),
    	.busRdWr_N ( intf.busRdWr_N ),
    	.adxStrb ( intf.adxStrb ),
    	.request ( intf.request ),
    	.grant ( intf.grant )
  );

  initial begin
    clk = 1'b0;
    forever begin
      #(clock_cycle/2) 
        clk = ~clk;
    end
  end
endmodule  

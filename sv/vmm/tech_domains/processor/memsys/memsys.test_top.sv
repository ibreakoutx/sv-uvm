/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`include "cpu_if.sv"
module test_top;
  parameter simulation_cycle = 100;

  reg  SystemClock;

  wire 		clk;
  logic 	reset;
  wire 		busRdWr_N;
  wire 		adxStrb;
  wire [7:0]	busAddr;
  wire [1:0]	request;
  wire [1:0]	grant;
  wire [7:0]	busData;
  assign clk = SystemClock;

  cpu_if port0(clk, busRdWr_N, adxStrb, busAddr, request[0], busData, grant[0]);
  cpu_if port1(clk, busRdWr_N, adxStrb, busAddr, request[1], busData, grant[1]);
   

  memsys_test tb();

  memsys dut(
    .clk	(clk),
    .reset	(reset),
    .busRdWr_N	(busRdWr_N),
    .adxStrb	(adxStrb),
    .busAddr	(busAddr),
    .request	(request),
    .busData	(busData),
    .grant	(grant)
  );


  initial begin
    SystemClock = 0;
    forever begin
      #(simulation_cycle/2)
        SystemClock = ~SystemClock;
    end
  end

  initial $vcdpluson;
endmodule

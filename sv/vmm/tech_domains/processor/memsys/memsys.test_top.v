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

module memsys_test_top;
  parameter simulation_cycle = 100;

  reg  SystemClock;

  wire 		clk;
  wire 		reset;
  wire 		busRdWr_N;
  wire 		adxStrb;
  wire [7:0]	busAddr;
  wire [1:0]	request;
  wire [1:0]	grant;
  wire [7:0]	busData;
  assign clk = SystemClock;

`ifdef SYNOPSYS_NTB
  memsys_test vshell(
    .SystemClock (SystemClock),
    .\memsys.clk	(clk),
    .\memsys.reset	(reset),
    .\memsys.busRdWr_N	(busRdWr_N),
    .\memsys.adxStrb	(adxStrb),
    .\memsys.busAddr	(busAddr),
    .\memsys.request	(request),
    .\memsys.busData	(busData),
    .\memsys.grant	(grant)
  );
`else

  vera_shell vshell(
    .SystemClock (SystemClock),
    .memsys_clk	(clk),
    .memsys_reset	(reset),
    .memsys_busRdWr_N	(busRdWr_N),
    .memsys_adxStrb	(adxStrb),
    .memsys_busAddr	(busAddr),
    .memsys_request	(request),
    .memsys_busData	(busData),
    .memsys_grant	(grant)
  );
`endif

  

`ifdef emu
/* DUT is in emulator, so not instantiated here */
`else
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
`endif

  initial begin
    SystemClock = 0;
    forever begin
      #(simulation_cycle/2)
        SystemClock = ~SystemClock;
    end
  end

endmodule

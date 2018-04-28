/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`include "apb_if.sv"
`include "dut.sv"

module tb_top;
   bit clk = 0;
   bit rst = 0;

   apb_if apb0(clk);

   slave dut(.paddr   (apb0.paddr[15:2] ),
             .psel    (apb0.psel        ),
             .penable (apb0.penable     ),
             .pwrite  (apb0.pwrite      ),
             .prdata  (apb0.prdata[31:0]),
             .pwdata  (apb0.pwdata[31:0]),
             .clk     (clk),
             .rst     (rst));

   always #10 clk = ~clk;

   initial begin
      if ($test$plusargs("dump")) $dumpvars;
   end
endmodule: tb_top

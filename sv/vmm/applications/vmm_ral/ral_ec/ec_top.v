/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

module ec_top_mod;


   reg clk;
   ec_intf ec_intf_0(clk);
   ec_test ec_test_0(ec_intf_0);
   /*
   wire [31:0] addr;
   wire rd;
   wire wr;
   wire [31:0] data;
   wire ale;
   wire rst_;
   wire sot;
   */

   ec      dc_dut(
        .clk(clk),
        .addr(ec_intf.addr),
        .rd(ec_intf.rd),
        .wr(ec_intf.wr),
        .data(ec_intf.data),
        .ale(ec_intf.ale),
        .rst_(ec_intf.rst_),
        .sot(ec_intf.sot)
   );

   initial begin
      $vcdpluson;
      // $vcdplusmemon;
      clk = 0;
   end

   always
      #5 clk = ~clk;

endmodule


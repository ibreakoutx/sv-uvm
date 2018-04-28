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
  bit clock;
    
  always #100  clock = ~clock;
  Bus #(.A_WIDTH(8),.D_WIDTH(8)) bus_intf (clock);
  test(bus_intf);
endmodule

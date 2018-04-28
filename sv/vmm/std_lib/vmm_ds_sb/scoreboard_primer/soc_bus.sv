/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

//
// 1-master, 3-slave SoC Bus
//
module soc_bus(apb_if m,
               apb_if s0,
               apb_if s1,
               apb_if s2,
               input  clk);

// Feed-throughs
assign s0.paddr   = m.paddr[7:0];
assign s0.penable = m.penable;
assign s0.pwrite  = m.pwrite;
assign s0.pwdata  = m.pwdata;

assign s1.paddr   = m.paddr[7:0];
assign s1.penable = m.penable;
assign s1.pwrite  = m.pwrite;
assign s1.pwdata  = m.pwdata;

assign s2.paddr   = m.paddr[7:0];
assign s2.penable = m.penable;
assign s2.pwrite  = m.pwrite;
assign s2.pwdata  = m.pwdata;

// Address decoder
// paddr[31..10|9..8|7..0]
//       Ignore  s#  addr

assign s0.psel = (m.paddr[9:8] == 2'b00 && m.psel);
assign s1.psel = (m.paddr[9:8] == 2'b01 && m.psel);
assign s2.psel = (m.paddr[9:8] == 2'b10 && m.psel);

assign m.prdata = (s0.psel) ? s0.prdata :
                   ((s1.psel) ? s1.prdata :
                    ((s2.psel) ? s2.prdata : 'z));

endmodule: soc_bus

/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



`include "vmm_ral_host_itf.sv"
`include "ral_blk_slave_rtl.sv"

module slave(input  [15:2] paddr,
             input         psel,
             input         penable,
             input         pwrite,
             output [31:0] prdata,
             input  [31:0] pwdata,
             input         clk,
             input         rstn);

vmm_ral_host_itf hst_bus(clk, rstn);
ral_blk_slave_itf ral_io();
ral_blk_slave_rtl ral(hst_bus.slave, ral_io.regs);

assign hst_bus.adr = paddr;
assign hst_bus.sel = psel;
assign hst_bus.wen = penable;
assign pwrite = hst_bus.ack;
assign hst_bus.wdat = pwdata[31:0];
assign prdata[31:0] = hst_bus.rdat;

endmodule


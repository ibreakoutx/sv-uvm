/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`ifndef _ROUTER_IO_IF
`define _ROUTER_IO_IF
interface router_io(input bit clock);
  logic  reset_n ;
  logic [15:0] frame_n ;
  logic [15:0] valid_n ;
  logic [15:0] din ;
  logic [15:0] dout ;
  logic [15:0] busy_n ;
  logic [15:0] valido_n ;
  logic [15:0] frameo_n ;

  clocking cb @(posedge clock);
    output  reset_n;
    output  frame_n;
    output  valid_n;
    output  din;
    input  dout;
    input  busy_n;
    input  valido_n;
    input  frameo_n;
  endclocking

  modport TB(clocking cb, output reset_n);
endinterface: router_io
`endif

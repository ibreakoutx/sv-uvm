/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

interface Bus_if(input logic clock);
  logic [1:0] mode;
  logic [7:0] addr;
  logic [7:0] data;
endinterface:Bus_if


interface Top_level_if(input logic clock);
  logic req, gnt;
  Bus_if bus_if(clock);

  function string psdisplay(string prefix = "");
    string msg;
    $write(psdisplay, "From interface - mode = %h, addr = %h, data = %h", bus_if.mode, bus_if.addr, bus_if.data);
  endfunction
endinterface:Top_level_if

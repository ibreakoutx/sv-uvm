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
  

  clocking cb @(posedge clock);
    output mode;
    output addr;
    inout data;
  endclocking

  modport DUT(input mode, input addr, inout data);
  modport TEST(clocking cb);

  function psdisplay(string prefix = "");
    $write(psdisplay, "From interface - mode = %h, addr = %h, data = %h", mode, addr, data);
  endfunction  
endinterface:Bus_if

interface Top_level_if(input logic clock);
  logic req, gnt;
  Bus_if bus_if(clock);
endinterface:Top_level_if

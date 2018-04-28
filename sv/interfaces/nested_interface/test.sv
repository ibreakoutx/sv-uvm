/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

program test(Top_level_if top_if);
  bit [7:0] addr, data;
  bit [1:0] mode;
  string str;
  initial
  begin
    repeat(3)
    begin
      data = $random();
      addr = $random();
      mode = $random();

      $display("from test - mode = %h, addr = %h, data = %h\n", mode, addr, data);
      top_if.bus_if.data = data;
      top_if.bus_if.addr = addr;
      top_if.bus_if.mode = mode;
      str = top_if.psdisplay();
      $display("%s\n", str);      
      @(posedge top_if.clock);
    end
  end
endprogram

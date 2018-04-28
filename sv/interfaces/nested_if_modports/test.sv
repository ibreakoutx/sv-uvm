/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class driver;
  bit [7:0] addr, data;
  bit [1:0] mode;
  string str;
  virtual Bus_if.TEST virt_if;

  function new(virtual Bus_if.TEST in_if);
    this.virt_if = in_if;
  endfunction:new

  task drive;
    data = $random();
    addr = $random();
    mode = $random();

    $write("from test - mode = %h, addr = %h, data = %h\n", mode, addr, data);
    @(virt_if.cb);
    virt_if.cb.data <= data;
    virt_if.cb.addr <= addr;
    virt_if.cb.mode <= mode;
    @(virt_if.cb);
  endtask
endclass

program automatic test(Top_level_if top_if);
  bit [7:0] addr, data;
  bit [1:0] mode;
  string str;

  initial
  begin
    driver drv;
    drv = new(top_if.bus_if.TEST);
    repeat(3)
    begin
      drv.drive();
      str = top_if.bus_if.psdisplay();
      $write("%s\n", str);
    end
  end
endprogram

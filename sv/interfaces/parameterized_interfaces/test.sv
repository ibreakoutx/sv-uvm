/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

program automatic test(Bus bus_intf);
bit [7:0] addr, data;
  initial 
  begin
    repeat(3)
    begin
      addr = $random();
      data = $random(); 
      $write("Generated write addr = %h, write data = %h\n", addr, data);      

      bus_intf.RW <= 0;
      bus_intf.Addr <= addr;
      bus_intf.Data <= data;

      @(bus_intf.receive_cb)
      $write("From within interface write addr = %h, write data = %h\n", bus_intf.Addr, bus_intf.Data);        
    end  
  end

endprogram

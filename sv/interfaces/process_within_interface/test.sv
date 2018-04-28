/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

/************************************************************************
 * Program block - this program pushes random data into the fifo 
 * and pops the same out of the fifo
 ***********************************************************************/
program automatic test(fifo_intf intf);
  data_type data_out, data_in;

  initial
  begin
      
    intf.reset();

    repeat(4)
    begin
      data_out = $random();
      $display("Write data	%h\n", data_out);
      intf.write(data_out);
      $display("Stack ptr	%h\n", intf.stack_ptr);      
      @(posedge intf.clk);
    end
    repeat(4)
    begin
      intf.read(data_in);
      $display("Read data	%h\n", data_in); 
      @(posedge intf.clk);
    end  
  end
endprogram

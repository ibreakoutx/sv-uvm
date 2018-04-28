/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/




// this is an example of using threads, same as 1 but using
// fork join_any and terminate


program example();


		// automatic tasks don't share common varibles
		// so its ok for multiple threads to access  them
		// without collision of data in the task

 task write_bus(int addr, int data);
	$display("here is a write to the bus at addr %d", addr);
 endtask




initial begin

  fork begin
   ///  here is one parallel thread competeing
	repeat (100) begin
			// wait for some random time
		#($random() % 100);
		write_bus(200, $random());
	end	
  end



   // here is a second parallel thread
  begin
	repeat (100) begin
			// wait for some random time
		#($random() % 100);
		write_bus(100, $random());
	end	
 end

  join_any


    // here we are back in the main thread, because one of the
    // threads running in parellel is finshed. So lets
    // terminate the other and keep going

    disable fork;


 $display ("done -- out\n");

end

endprogram


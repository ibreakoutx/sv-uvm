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
// fork join_none and terminate


program example();

		// semaphores are a unique datatype in SV
semaphore want_to_print;

		// this is the "shared resource", would be a bus,
		// but in this case its a $display 
task write_bus(int addr, int data);
	$display("here is a write to the bus at addr %d", addr);
	#100;
endtask




int done = 0, i = 0;



initial begin
		// here we initialize the semaphore with one token
		// availabe to share.  We could initialize
		// with more, if there were an interleaved bus, for
		// example
   want_to_print = new(1);




  fork begin
   ///  here is one parallel thread competeing

	while(1) begin
			// wait for some random time
		#($random() % 100);
			// attempt to get the one semaphore token
		want_to_print.get(1);
			// got it!, lets use the bus
		write_bus(200, $random());

		i++;
			// we must return the semaphore token
		want_to_print.put(1);
	end	
  end



   // here is a second parallel thread
  begin
	while(1) begin
			// wait for some random time
		#($random() % 100);
			// attempt to get the one semaphore token
		want_to_print.get(1);
			// got it!, lets use the bus to the exclusion of others
		write_bus(100, $random());
		i++;
			// we must return the semaphore token
		want_to_print.put(1);
	end	
 end

  join_none


   // this is main thread, running in parellel with the 2 others in
   // the fork join_none.

   while(i < 100) begin
       @(i);
    end
	// ok , now lets terminate the other 2 threads!
    disable fork;


 $display ("done -- out\n");

end

endprogram


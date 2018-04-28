/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


// this is an example of using the mailboxes  and events
// it presumes you know about fork join since mailboxes are 
// primarly used to pass data from one running thread to another.
// and to show event syncronization


program example();


mailbox xfer_data;


int done = 0, i = 0, j;
event handshake;


initial begin

   xfer_data= new();

  fork begin
   ///  here is one parallel thread

	while(!done) begin
		   xfer_data.put(i);	// you can put any datatype in a mailbox
					// including object handles
		   i++;	

		@(handshake);		// wait for a handshake  from other thead
	end	


  end

   // here is a second parallel thread
  begin
	while(!done) begin

	    xfer_data.get(j);	// here we get the data and put it into j (its a ref argument)

		if (j > 100)	// check to see we have got 101+ xfers 
			done = 1;

		// pull the handshake trigger
	    -> handshake;

        end
  end 
 
  join

 $display ("done -- sent %0d out\n", j);

end

endprogram

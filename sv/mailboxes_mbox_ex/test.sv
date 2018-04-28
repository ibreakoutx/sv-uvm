/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

program prog;

class A;
 rand bit[7:0] k;
endclass

A a = new;
mailbox mbx = new ();
bit[7:0] j;
integer i,k=0;

initial
begin
 repeat(256)
   begin
			 a.randomize();
				k = a.k;
    #5 mbx.put(k); ///fill the mailbox with randomly generated k
   end
    /// Display the number of messages in Mailbox using mbx.num()
    $display(" Total No. of msgs in mbx = %0d ",mbx.num());
			
    /// Display the first message in Mailbox using mbx.peek(j)
    #5 mbx.peek(j);
    $display("First Msg in mbx = %0d",j);

    /// Reading the Mailbox using mbx.get(j) till all the messages are read out. 
    repeat(256) 
					begin	
					 mbx.get(j);
      #5 $display("No. of msgs in mbx left = %0d; Message  = %0d at time %0t",mbx.num(),j,$time);
     end
					
					/// Check for the messagees left in the MBOX
					$display("No of Msgs Left in MBOX = %0d",mbx.try_peek(j));
					
					/// Try reading an Empty MBOX which will return 0
					if (mbx.try_get(j)==0)
      $display("CANNOT READ AS MAILBOX IS EXHAUSTED \n");

end

endprogram

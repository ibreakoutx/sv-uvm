/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


// This is an exmaple of a program generating data and passing it to a 
// a module via a shared mailbox

//  It is also possible for a module to send data to a Testbench 

// This can be interesting for modeling applications,  sending backdoor 
// trasnaction data from various modules or tb programs to other modules 
// or tb programs


	// a class to hold data in the mailbox. Could be a Transaction Level  Message 

class Transaction_Cl;
   	rand bit[14:0] da;
	rand bit[7:0] k;
 	rand bit[123:0] payl;
endclass


	// a shared mbx delcared in $root
mailbox mbx ;



program my_prog();

  Transaction_Cl a;

  initial
     begin
	mbx = new ();		// this is a SV Mailbox
        repeat(40)
           begin
	    	a = new();		// create a new transaction
		a.randomize();		// randomize it
        	mbx.put(a); 		// place into mailbox 
		$display("sending data from module to other module/program block via mbox\n");
   	   end
        #1000  $display ("\n\n\n"); // this ends the simulation after some time
     end
endprogram



	// here is a module, just happens to have no portlist/interface
	// it could -- this is just a small example ! 

module  my_module_block();

  Transaction_Cl b;			// here we just start using classes in module!

 initial
   begin
     repeat(40)
      begin
         /// Reading the Mailbox using mbx.get(j) till all the messages are read out. 
        #10  mbx.get(b);
	     $display("getting data  via mbox\n");
         #5  $display("Data contains: %0d, %0d\n", b.da  , b.k );
         #5  $display("No. of msgs in mbx left = %0d at time %0t",mbx.num(),$time);
     end
  end

endmodule


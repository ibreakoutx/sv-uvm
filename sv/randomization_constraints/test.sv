/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



// Example Intent :
// Shows the use of a default constraint and how to apply different
// constraints using the "randomze() with" construct

program test ;
   int i ;

   // Transaction class to generated data and addresses
   class Transaction;
      rand bit [15:0] addr, data;

      // Class Default constraint
      constraint c1 {addr inside{[0:100],[1000:2000]};}

      // Class methods
      task display () ;
        begin 
	   $write("Transaction : adr = %4d (b %b)    data = %8d (b %b)\n"
                 , addr, addr, data, data) ;
	end
      endtask : display

   endclass : Transaction

   // Begin testbench code
   initial begin
     Transaction t = new();

     // randomize with class default constraints which apply 
     // to all objects of this class
     t.randomize() ;
     t.display() ;

     // use randomize with to apply constraints to a specific object
     t.randomize() with {addr > 50; addr < 1500; data < 10;};
     t.display() ;

     t.randomize() with { addr == 2000; data > 10;};
     t.display() ;

     for (i=0; i<3; i++) begin
        t.randomize() with { addr == i ; data == 10 + i ;};
        t.display() ;
     end

   end
endprogram

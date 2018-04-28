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
// Shows the use of an aspect extension to refine the 
// constraint defined in the original class

// Transaction class to generate data and address
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

program test ;
   int i ;



   // Begin testbench code
   initial begin
     Transaction t = new();

     // randomize with class default constraints which apply 
     // to all objects of this class
     t.randomize() ;
     t.display() ;

     t.randomize() with { addr == 1000;};
     t.display() ;

     for (i=60; i<63; i++) begin
        t.randomize() with { addr == i ; } ; 
        t.display() ;
     end
   end
endprogram

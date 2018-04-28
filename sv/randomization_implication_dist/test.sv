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
// Shows the use of a default constraint and the use of implication
// operator to define address ranges and shows the use of the "dist"
// constraint to define address ranges

program test ;
   int i ;
   typedef enum {SHORT, MED, LONG} RANGE ;

   // Transaction class to generated data and addresses
   class Transaction;
      rand bit [15:0] addr, data;
      rand RANGE range ;

      // Class Default addr constraint using implication
      constraint addr_range {
	(range == SHORT ) -> addr inside { [ 0 :  5] } ;
	(range == MED   ) -> addr inside { [ 6 :  9] } ;
	(range == LONG  ) -> addr inside { [ 10: 15] } ;
      }
      // Class Default data constraint using distribution
      constraint data_con {
        data dist { [0:15] := 3, [15:127] :=1, [128:255] := 2} ;
      }

      // Class methods
      task display () ;
        begin 
	   $write("Transaction : adr = %2d   data = %3d      RANGE = %2d\n"
                 , addr, data, range) ;
	end
      endtask : display

      // post_randomize function here used to print results
      function void post_randomize () ;
           display () ;
      endfunction : post_randomize

   endclass : Transaction

   // Begin testbench code
   initial begin
     Transaction t = new();

     // randomize with class default constraints which apply 
     // to all objects of this class
     for (i=0; i<9; i++) begin
        t.randomize() ;
     end

   end
endprogram

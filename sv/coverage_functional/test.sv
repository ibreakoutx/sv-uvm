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
// Shows the use of functional coverage 


program test ;
   int i ;
   typedef enum {SHORT, MED, LONG} RANGE ;

   // Transaction class to generated data and addresses
   class Transaction;
      rand bit [3:0] addr ;
      rand bit [15:0] data;
      rand RANGE range ;
      
      event cover_it ;     // event used to trigger covergroup

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

      covergroup addr_cov ;
         // define coverage points of interest
         range_cp : coverpoint range ;
	 data_cp  : coverpoint data ;
	 addr_cp  : coverpoint addr ;

         // define cross-coverage samples of interest
	 cross_ad_rg : cross range_cp, addr_cp ;

         // Enable coverge on a per-instance basis. 
	 // Required to get coverage of the object
	 // Otherwise % coverage will be -1
	 option.per_instance=1;


      endgroup

         

      // Class methods
      task display () ;
        begin 
           $write("Transaction : adr = %3d (h %2h)    data = %3d (h %2h) RANGE = %0s\n"
                 , addr, addr, data, data, range.name()) ;
	end
      endtask : display

      // post_randomize function used to sample coverage
      function void post_randomize () ;

	   // use predefined coverage method to sample coverpoints
	   this.addr_cov.sample ;
	   // Note : this is not a best practice to put the coverage
	   // in the data object. See the RVM manual for best practices
      endfunction : post_randomize

      function new() ;
         addr_cov = new() ;
      endfunction

   endclass : Transaction


   // Begin testbench code
   initial begin
     Transaction t = new();

     // randomize with class default constraints which apply 
     // to all objects of this class

     // Query coverage; when Coverage hits 100% of all possible coverage points
     // terminate test. Note that a cross of addr and range can only produce
     // a maximum of 33% coverage, since the other 66% of possible hits are
     // excluded.
     while ( t.addr_cov.cross_ad_rg.get_inst_coverage <= 33.33 ) begin
        t.randomize() ;
	$write("cov = %3.5f ",  t.addr_cov.cross_ad_rg.get_inst_coverage() ) ;
        t.display() ;
     end  // while
     // see test.txt or urgReport for the text and html versions of the coverage report

   end
endprogram

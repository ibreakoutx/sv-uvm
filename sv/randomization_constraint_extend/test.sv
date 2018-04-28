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
// Shows the use of a default constraint in the base class and how
// to extend the class to apply different constrints
// Also post_randomize() is featured.


program test ;
   int i ;

   // Transaction base class to generate default data & addresses
   class Transaction;
      rand bit [15:0] addr, data;

      // Class Default constraint
      constraint c1 {addr inside{[0:100],[1000:2000]};}

      // Class methods
      task display () ;
        begin 
	   $write("Transaction : adr = %2d (b %b)    data = %3d (b %b)\n"
	         , addr, addr, data, data) ;
	end
      endtask : display

   endclass : Transaction

   // Extended class with additional constraints
   class Inc_trans extends Transaction ;
      bit [15:0] tmp_addr = 0 ;
      bit [15:0] tmp_data = 10 ;

      // constraint
      constraint c1 {
	addr == tmp_addr + 1 ;
	data == tmp_data + 1 ;
      }

      function void post_randomize () ;  // {
	tmp_addr = tmp_addr + 1 ;
	tmp_data = tmp_data + 1 ;
      endfunction : post_randomize // }

   endclass : Inc_trans

   initial begin
     Transaction t = new();
     Inc_trans   it = new() ;
     it.tmp_addr = 50 ;

     for (i=0; i<3; i++) begin
        it.randomize() ;
	it.display() ;
     end

   end
endprogram

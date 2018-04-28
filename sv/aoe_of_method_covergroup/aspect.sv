/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


// The following is a Aspect Oriented Extension, AOE,
// that modifies the original definition of Transaction, in-place.
// No new data type is created.  When randomized, constraint c1
// and constraint c2 will both be applied.

extends TransactionAspect(Transaction);
   constraint c2
   {
      addr > 50;
      addr < 1500;
      data < 10;
   }

   // add a coverage group to track addr and data values
   covergroup cg  @(addr);
      coverpoint addr; 
      coverpoint data;
   endgroup


   // add a constructor to new the covergroup
   // Advice is required due to an implicit 'new' in the Transaction class
   after function new();
      cg = new();
   endfunction

endextends

// add an enumerated type to specify direction
typedef enum {READ, WRITE} dir; 

// An additonal AOE which adds a direction property to the
// original transaction definition.  
// Note, that within the same file, advice is applied in the
// order of compilation; i.e. top-down.

extends TransactionAspect2(Transaction);
   // add a new property; name must not conflict with existing symbols
   rand dir direction;

   // Using advice, this display task replaces the original display task
   // This task has been enhanced to show the direction of the transaction
   around task display();
        $write("Transaction : addr = %4d (b %b)    data = %8d (b %b)    dir = %0s\n"
              , addr, addr, data, data, direction.name) ;
   endtask

endextends


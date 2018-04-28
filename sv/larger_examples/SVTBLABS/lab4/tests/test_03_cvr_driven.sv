/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

/***************************************************************************
 *
 * File:        $RCSfile: test_03_cvr_driven.sv,v $
 * Revision:    $Revision: 1.2 $  
 * Date:        $Date: 2003/07/15 15:18:54 $
 *
 *******************************************************************************
 *
 * This test shows how to create coverage-driven test by generating
 * random transactions (e.g on-demand) until an expected
 * coverage goal is achieved.
 *
 * Basically, an apb_trans object is randomly generated
 * throughout the simulation run set in order to create a
 * directed test.
 *
 * A coverage group is attached to my_gen class and is used
 * to measure that the following conditions are met:
 *
 *   - All addresses
 *   - All READ,WRITE transactions
 *   - All possible data inside [0x00, 0x55, 0xAA, 0xFF]
 *
 * The virtual methods in my_gen are here overwritten so
 * to fulfill the above test patterns
 *
 *******************************************************************************
 */

parameter TEST_LENGTH = 64;


program test(apb_if hif);

`include "env.sv"

class my_gen extends apb_gen;
  
  // Define a coverage group aimed at ensuring that all
  // addresses, data and transactions are hit
  // To do multiple calls in one cycle, will be called with sample()
  // routine
  covergroup TransCov;

// LAB: Cover the transaction type READ and WRITE
    // Select relevant transactions (all but IDLE)

// LAB: Cover the address values
    // All addresses
    
// LAB: Cover selected data values
    // Select data (4 values)


// LAB: Now perform cross coverage
    // Define a cross container based upon the
    // 3 previous samples. Ensures that corner
    // cases are also hit.

    // Number of valid states = ( 100+100+100+232/256 ) / 400 = 97.5%
    //coverage_goal = 97;
  endgroup


  // Constructor
  function new(mailbox apb_mbox=null, int max_trans_cnt, bit verbose=0);
    super.new(apb_mbox, max_trans_cnt, verbose);
    TransCov = new();
  endfunction


  function apb_trans get_transaction();
    int s;
    tr = new();
    s = tr.randomize() with {data inside {8'h00, 8'h55, 8'haa, 8'hff};
                             transaction != IDLE;};
    if (!s)
      begin
        $display("apb_trans::randomize failed");
        $finish;
      end
    
    TransCov.sample();
    get_transaction = tr;
  endfunction
  
endclass: my_gen


// Top level environment
env the_env;

// Instanciate the customized generator
my_gen my_generator;


initial begin
  // Instanciate the top level
  the_env = new(hif, hif);

  // Plug the new generator
  my_generator = new(the_env.gen2mas, TEST_LENGTH, 1);
  the_env.gen  = my_generator;

  // Kick off the test now
  the_env.run();

  $finish;
end 

endprogram

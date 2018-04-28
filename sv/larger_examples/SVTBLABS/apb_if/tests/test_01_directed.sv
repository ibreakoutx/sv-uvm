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
 * File:        $RCSfile: test_01_directed.sv,v $
 * Revision:    $Revision: 1.6 $  
 * Date:        $Date: 2003/07/15 15:18:54 $
 *
 *******************************************************************************
 *
 * This test shows how to create directed test by generating
 * transactions on-the-fly (e.g on-demand).
 *
 * Basically, a mem_cell_trans object is directly generated
 * throughout the simulation run set in order to create a
 * directed test.
 *
 * The scenario implemented here performs the following
 * transactions:
 *    - Constrained generation of object during simulation
 *    - Generates 32 WRITE cycles at address [0..31]
 *      with random data
 *    - Generates 32 READ cycles at address [0..31]
 *
 * The virtual methods in l2_gen are here overwritten so
 * to fulfill the above test patterns
 *
 *******************************************************************************
 */


parameter TEST_LENGTH = 64;


program test(apb_if aif);

`include "env.sv"


class my_gen extends apb_gen;
  
  // Constructor
  function new(mailbox apb_mbox, int max_trans_cnt, bit verbose=0);
    super.new(apb_mbox, max_trans_cnt, verbose);
  endfunction


  // Provides a new implementation of get_transaction()
  // This is how the directed testing flavor is performed
  function apb_trans get_transaction();
    tr = new();
    tr.addr = trans_cnt % (max_trans_cnt/2);
    tr.data = trans_cnt;

    if(this.trans_cnt < (max_trans_cnt/2))
      // Forces the first half of the transactions to be WRITE cycles
      // Data is left random
      tr.transaction = WRITE;
    else  
      // Forces the next half of the transactions to be READ cycles
      tr.transaction = READ;
    get_transaction = tr;
  endfunction
  
endclass: my_gen


// Top level environment
env the_env;

// Instanciate the customized generator
my_gen my_generator;

initial begin
  // Instanciate the top level
  the_env = new(aif, aif);

  // Plug the new generator & config
  my_generator = new(the_env.gen2mas, TEST_LENGTH, 1);
  the_env.gen = my_generator;

  // Kick off the test now
  the_env.run();

  $finish;
end 

endprogram


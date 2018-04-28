/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

/*******************************************************************************
 *
 * File:        $RCSfile: apb_gen.sv,v $
 * Revision:    $Revision: 1.7 $  
 * Date:        $Date: 2003/07/15 15:18:31 $
 *
 *******************************************************************************
 *
 * Basic Transaction Generator aimed at randomizing and
 * initiating read() and write() transactions based
 * on APB BFM (apb_master)
 *
 *******************************************************************************
 */


class apb_gen;

  // Random APB transaction
  rand apb_trans tr;

  // Test terminates when the trans_cnt is greater
  // than max_trans_cnt member
  int max_trans_cnt;
  
  // event notifying that all transactions were sent
  event ended;
  
  // Counts the number of performed transactions
  int trans_cnt = 0;

  // Verbosity level
  bit verbose;
  
  // APB Transaction mailbox
  mailbox gen2mas;
    
  // Constructor
  function new(mailbox gen2mas, int max_trans_cnt, bit verbose=0);
    this.gen2mas       = gen2mas;
    this.verbose       = verbose;
    this.max_trans_cnt = max_trans_cnt;
    tr                 = new;
  endfunction

  // Method aimed at generating transactions
  task main();
    if(verbose)
      $display($time, ": Starting apb_gen for %0d transactions", 
               max_trans_cnt);
    
    // Start this daemon as long as there is a transaction 
    // to be proceeded)
    while(!end_of_test())
      begin

        // Wait & Get a transaction
        tr = get_transaction();
  
        // Increment the number of sent transactions
        if(tr.transaction != IDLE)
          ++trans_cnt;
  
        if(verbose)
          tr.display("Generator");

        gen2mas.put(tr);
      end // while (!end_of_test())
        
    if(verbose) 
      $display($time, ": Ending apb_gen\n");
  
    ->ended;

  endtask


  // Returns TRUE when the test should stop
  virtual function bit end_of_test();
    end_of_test = (trans_cnt >= max_trans_cnt);
  endfunction
    
  // Returns a transaction (associated with tr member)
  virtual function apb_trans get_transaction();
    if (! this.tr.randomize())
      begin
        $display("apb_gen::randomize failed");
        $finish;
      end
    get_transaction = tr.copy();
  endfunction
    
endclass

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
 * File:        $RCSfile: scoreboard.sv,v $
 * Revision:    $Revision: 1.2 $  
 * Date:        $Date: 2003/07/03 12:21:01 $
 *
 *******************************************************************************
 *
 * Scoreboard module used to verify the
 * incoming and outgoing transactions correctness
 *
 *******************************************************************************
 */

class scoreboard;

  // Verbosity level
  bit verbose;
  
  // Max # of transactions
  int max_trans_cnt;
  event ended;

  // Number of good matches
  int match;

  // Transaction coming in
  mailbox mas2scb, mon2scb;
    

  // Constructor
  function new(int max_trans_cnt, mailbox mas2scb, mon2scb, bit verbose=0);
    this.max_trans_cnt = max_trans_cnt;
    this.mas2scb       = mas2scb;
    this.mon2scb       = mon2scb; 
    this.verbose       = verbose;
  endfunction


  // Method to receive transactions from master and monitor
  task main();
    apb_trans mas_tr, mon_tr;
    reg [APB_DATA_WIDTH-1:0] exp_data;

    $display($time, ": Starting scoreboard for %0d transaction", max_trans_cnt);

    forever
      begin

        // Since this device operates as a transfer function, the self-checking 
        // mechanism is quite simple. The scoreboard first waits for a
        // transaction to be generated then waits for the monitor to notify that 
        // this transaction occurred.  In order to determine the transaction 
        // correctness the following rules are applied:
        //   - Each generated WRITE transactions are stored to a register file 
        //    (which acts as a reference model in this case).
        //   - Each generated READ transactions get their data field filled from 
        //     the register file (so to provide an expected result).
        //   - each transactions is then compared on a first-come first-serve basis.
        mas2scb.get(mas_tr);
        mon2scb.get(mon_tr);

        exp_data = $root.top.m1.memory_read(mas_tr.addr);

        // First compare the two transactions: master & monitor
        if (mas_tr.transaction != mon_tr.transaction)
          $display("@%0d: ERROR master transaction type (%s) does not match monitor (%s)",
                   $time, mas_tr.transaction.name, mon_tr.transaction.name);
        else if (mas_tr.addr != mon_tr.addr)
          $display("@%0d: ERROR master transaction addr(%h) does not match monitor (%h)",
                   $time, mas_tr.addr, mon_tr.addr);
        else begin

          // Okay, now does the transaction match the memory?
        case(mas_tr.transaction) 
          WRITE: 
            begin
              // Check that master data == monitor data
              if (mas_tr.data != mon_tr.data)
                $display("@%0d: ERROR master transaction data(%h) does not match monitor (%h)",
                         $time, mas_tr.data, mon_tr.data);

              // Okay, the two transactions match, did the right stuf get into memory?
              else if (mas_tr.data != exp_data)
                $display("@%0d: ERROR master transaction data(%h) does not match memory (%h)",
                         $time, mas_tr.data, exp_data);
              else
                begin
                  match++;
                  if(verbose)
                    $display("@%0d: Data match Addr=%H Data=%H", $time, mon_tr.addr, mon_tr.data);
                end
            end // case: WRITE

          READ:  
            begin
              // Okay, the two transactions match, did the right stuf get into memory?
              if (mon_tr.data != exp_data)
                $display("@%0d: ERROR monitor transaction data(%h) does not match memory (%h)",
                         $time, mon_tr.data, exp_data);
              else
                begin
                  match++;
                  if(verbose)
                    $display("@%0d: Data match Addr=%H Data=%H", $time, mon_tr.addr, mon_tr.data);
                end
            end // case: READ

          default:
            begin
              $display("@%0d: Fatal error: Scoreboard received illegal master transaction '%s'", 
                       $time, mas_tr.transaction.name);
              $finish;
            end
        endcase
        end // else: !if(mas_tr.addr != mon_tr.addr)
        
        // Determine if the end of test has been reached
        if(--max_trans_cnt<1)
          ->ended;
        
      end // forever
  endtask

endclass

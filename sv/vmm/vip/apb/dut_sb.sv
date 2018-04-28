/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

//-----------------------------------------------------------------------------
//
// SYNOPSYS CONFIDENTIAL - This is an unpublished, proprietary work of
// Synopsys, Inc., and is fully protected under copyright and trade secret
// laws. You may not view, use, disclose, copy, or distribute this file or
// any information contained herein except pursuant to a valid written
// license from Synopsys.
//
//-----------------------------------------------------------------------------
//
//
// Description : Scoreboard for Memory Design
//
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Scorebaord Class
//-----------------------------------------------------------------------------

class dut_sb extends vmm_xactor;

  vmm_log log;           // For log messages

  int max_trans_cnt;     // Max # of transactions
  local int match;       // Number of good matches

  local apb_trans_channel mon2scb;    // Transactions from monitor
  local apb_trans from_master_q[$] ;  // queue of data from the master

  integer DONE;                       // DONE notification
    
  extern function new(int max_trans_cnt, apb_trans_channel mon2scb);

  extern task main();
  extern task report();
  extern task cleanup();

  extern function void from_master(apb_trans tr);

  extern local function void check_read(apb_trans mas_tr,
                                        apb_trans mon_tr,
                                        reg [`APB_DATA_WIDTH-1:0] exp_data);    

  extern local function void check_write(apb_trans mas_tr,
                                         apb_trans mon_tr,
                                         reg [`APB_DATA_WIDTH-1:0] exp_data);    
endclass 

//-----------------------------------------------------------------------------
// new() - Constructor
//-----------------------------------------------------------------------------

function dut_sb::new(int max_trans_cnt, 
                     apb_trans_channel mon2scb);

  // Call the RVM xactor base class
  super.new("DUT_SB", "class", 0);

  // Save the arguments into local data members
  this.log = new("Scoreboard", "Scoreboard");
  this.max_trans_cnt = max_trans_cnt;
  this.mon2scb       = mon2scb;
    
  // Configure DONE notification to be ON/OFF
  DONE = notify.configure(-1, vmm_notify::ON_OFF); 

endfunction: new

//-----------------------------------------------------------------------------
// from_master() - Entry point from master callback integration object
//-----------------------------------------------------------------------------

function void dut_sb::from_master(apb_trans tr) ; 

  from_master_q.push_back(tr) ; 

endfunction: from_master

//-----------------------------------------------------------------------------
// main() - RVM main method - forever thread that performs comparisons
//-----------------------------------------------------------------------------

task dut_sb::main();
    
  apb_trans mas_tr, mon_tr;
  reg [`APB_DATA_WIDTH-1:0] exp_data;

  // Fork off the super.main() to perform any base-class tasks
  fork
    super.main();
  join_none
    
   `vmm_note(this.log, $psprintf("@%0d: Starting scoreboard for %0d transaction", $time,  max_trans_cnt)) ;

  while(1) begin

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

    mon2scb.get(mon_tr);
    mas_tr = from_master_q.pop_front();

    exp_data = top.m1.memory_read(mas_tr.addr);

    // Perform the comparison of master vs mon vs memory
    case(mas_tr.dir) 
      apb_trans::WRITE: check_write(mas_tr, mon_tr, exp_data);
      apb_trans::READ:  check_read (mas_tr, mon_tr, exp_data);
      default: `vmm_fatal(log, "Fatal error: Scoreboard received illegal master transaction");
    endcase
    
    // Determine if the end of test has been reached
    if(match >= max_trans_cnt) begin
      `vmm_verbose(this.log, $psprintf("Done scorboarding found %d matches", match));
      this.notify.indicate(this.DONE);
    end
    
  end // while(1)
    
endtask

//-----------------------------------------------------------------------------
// check_write() - check mst trans vs. mon trans vs. memory contents
//-----------------------------------------------------------------------------

function void dut_sb::check_write(apb_trans mas_tr, apb_trans mon_tr, reg [`APB_DATA_WIDTH-1:0] exp_data);

    string diff = "";
    
    // Check that master data == monitor data
    if (!mas_tr.compare(mon_tr, diff))
      `vmm_error(log, $psprintf("Master Write transaction does not match monitor - %s", diff));

    // Check the master data == memory data
    else if (mas_tr.data != exp_data)
      `vmm_error(log, $psprintf("Master Write transaction data(%h) does not match memory (%h)",
                                 mas_tr.data, exp_data)) ;
    else begin
      match++;
      `vmm_note(log, $psprintf("%s", mas_tr.psdisplay("CHECK OK ==>")));
    end
endfunction: check_write

//-----------------------------------------------------------------------------
// check_read() - check mst trans vs. mon trans vs. memory contents
//-----------------------------------------------------------------------------

function void dut_sb::check_read(apb_trans mas_tr, apb_trans mon_tr, reg [`APB_DATA_WIDTH-1:0] exp_data);

    string diff = "";
    
    // Check that master data == monitor data
    if (!mas_tr.compare(mon_tr, diff))
      `vmm_error(log, $psprintf("Master Read  transaction does not match monitor - %s", diff));

    // Check the master data == memory data
    else if (mas_tr.data != exp_data)
      `vmm_error (log, $psprintf("Master Read  transaction data(%h) does not match memory (%h)",
                                 mas_tr.data, exp_data)) ;
    else begin
      match++;
      `vmm_note(log, $psprintf("%s", mas_tr.psdisplay("CHECK OK ==>")));
    end
endfunction: check_read

//-----------------------------------------------------------------------------
// report() - RVM Report Method
//-----------------------------------------------------------------------------

task dut_sb::report();

endtask: report

//-----------------------------------------------------------------------------
// cleanup() - RVM Cleanup Method
//-----------------------------------------------------------------------------

task dut_sb::cleanup();

endtask: cleanup


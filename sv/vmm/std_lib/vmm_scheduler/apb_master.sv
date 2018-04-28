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
// Filename    : $Id: apb_master.sv,v 1.14 2005/11/10 21:31:38 alexw Exp $
//
// Created by  : Synopsys Inc. 09/01/2004
//               $Author: alexw $
//               Author: Alex Wakefield, Angshu Saha
//
// Description : AMBA Peripheral Bus Master Transactor
//
//               This is a vmm_xactor class for a APB Master
//
//   This BFM receives APB transactions from a channel, and drives
//   the pins via the SystemVerilog virtual interface.
//
//           |      |          
//           | APB  |  VMM channel
//           | trans|   
//           |  VV  |
//           |      |
//    +--------------------+
//    |     APB-Master     |
//    +--------------------+
//           |||||||
//           |||||||
//           APB Bus
//
//-----------------------------------------------------------------------------

`define APB_MASTER_IF	apb_master_if.master_cb

//-----------------------------------------------------------------------------
// APB Master Xactor Class
//-----------------------------------------------------------------------------
  
class apb_master extends vmm_xactor;

    // APB Interface (Master side)
    virtual apb_if.Master apb_master_if;

    // APB Transaction channels
    apb_trans_channel  in_chan ;

    // Lab4 - Add "extern function new()" here with arguments:
    // Lab4 - string instance                     
    // Lab4 - integer stream_id = -1              
    // Lab4 - virtual apb_if.Master apb_master_if 
    // Lab4 - apb_trans_channel in_chan = null          


  extern function new(string instance, integer stream_id = -1, virtual apb_if.Master apb_master_if, apb_trans_channel in_chan= null);
  


    extern virtual task main() ; 
    extern virtual task reset() ;

  extern virtual function void start_xactor();
  
    extern protected virtual task do_read(ref apb_trans tr) ; 
    extern protected virtual task do_write(apb_trans tr) ;
    extern protected virtual task do_idle(); 
  
endclass: apb_master

//-----------------------------------------------------------------------------
// APB Master Callback Class
//-----------------------------------------------------------------------------

virtual class apb_master_callbacks extends vmm_xactor_callbacks;

   // Callbacks before a transaction is started
   virtual task master_pre_tx(apb_master    xactor,
                              ref apb_trans trans,
                              ref bit        drop);
   endtask

   // Callback after a transaction is completed
   virtual task master_post_tx(apb_master xactor,
                               apb_trans  trans);
   endtask

endclass: apb_master_callbacks


  function void apb_master::start_xactor();
  super.start_xactor();
  endfunction: start_xactor
//-----------------------------------------------------------------------------
// new() - Constructor
//-----------------------------------------------------------------------------

function apb_master::new(string instance,
                         integer stream_id,
                         virtual apb_if.Master apb_master_if, 
                         apb_trans_channel in_chan);

  // Call the super task to initialize the xactor    
  super.new("APB MASTER", instance, stream_id) ;
  
  // Save a refernce to the interface  
  this.apb_master_if = apb_master_if;

  // Allocate an input channel if needed, save a reference to the channel
  if (in_chan == null) in_chan = new("APB MASTER INPUT CHANNEL", instance); 
  this.in_chan       = in_chan;

endfunction: new

//-----------------------------------------------------------------------------
// main() - RVM main
//-----------------------------------------------------------------------------
// Main daemon. Runs forever to switch APB transaction to
// corresponding read/write/idle command
//-----------------------------------------------------------------------------

task apb_master::main();

  apb_trans tr;
  bit drop;

  // Fork off the super.main() to perform any base-class tasks
  fork
    super.main();
  join_none

  // Main loop to drive the APB Bus
  while (1) begin
    
    // Wait if the xactor is stopped on the in_chan is empty
    // Get a transaction from the input channel
    this.wait_if_stopped_or_empty(this.in_chan) ;
    in_chan.get(tr);

    // Pre-Tx callback
    `vmm_callback(apb_master_callbacks, master_pre_tx(this, tr, drop));
    if (drop == 1) begin
      `vmm_note(log, tr.psdisplay("Dropped"));
      continue;
    end

    // Process the transaction
    case (tr.dir)
      apb_trans::READ:    do_read(tr);
      apb_trans::WRITE:   do_write(tr);
      default: do_idle();
    endcase

    // Lab4 - Add a post-tx callack here, arguments are:
    // Lab4 - apb_master_callbacks, master_post_tx(this, tr)
    `vmm_callback(apb_master_callbacks, master_post_tx(this, tr));
    

    // Debug Print
    `vmm_debug(log, tr.psdisplay("Master ==>"));
  end
    
endtask: main

//-----------------------------------------------------------------------------
// reset() - Reset the APB Bus to the default values, then go into active mode
//-----------------------------------------------------------------------------

task apb_master::reset();

  `APB_MASTER_IF.Rst <= 0;
  do_idle();
  repeat (5) @(`APB_MASTER_IF);
  `APB_MASTER_IF.Rst <= 1;

endtask: reset

//-----------------------------------------------------------------------------
// do_idle() - Put the APB Bus into Idle Mode
//-----------------------------------------------------------------------------

task apb_master::do_idle();

  `APB_MASTER_IF.PAddr   <= 0;
  `APB_MASTER_IF.PSel    <= 0;
  `APB_MASTER_IF.PWData  <= 0;
  `APB_MASTER_IF.PEnable <= 0;
  `APB_MASTER_IF.PWrite  <= 0;
   @(`APB_MASTER_IF);
  `APB_MASTER_IF.PWrite  <= 0;

endtask: do_idle

//-----------------------------------------------------------------------------
// do_read() - Issue a APB Read Cycle
//-----------------------------------------------------------------------------
//    - drives the address bus,
//    - select the  bus,
//    - assert Penable signal,
//    - read the data and return it.
//-----------------------------------------------------------------------------
   
task apb_master::do_read(ref apb_trans tr);

  // Drive Control bus
  `APB_MASTER_IF.PAddr  <= tr.addr;
  `APB_MASTER_IF.PWrite <= 1'b0;
  `APB_MASTER_IF.PSel   <= 1'b1;

  // Assert Penable
  ##1 `APB_MASTER_IF.PEnable <= 1'b1;

  // Deassert Penable & return the read data
  ##1 `APB_MASTER_IF.PEnable <= 1'b0;
  tr.data = `APB_MASTER_IF.PRData;
    
endtask: do_read
      
//-----------------------------------------------------------------------------
// do_write() - Issue an APB Write Cycle
//-----------------------------------------------------------------------------
//    - Drive the address bus,
//    - Select the  bus,
//    - Drive data bus
//    - Assert Penable signal
//-----------------------------------------------------------------------------
  
task  apb_master::do_write(apb_trans tr);
    
  // Drive Control bus
  `APB_MASTER_IF.PAddr  <= tr.addr;
  `APB_MASTER_IF.PWData <= tr.data;
  `APB_MASTER_IF.PWrite <= 1'b1;
  `APB_MASTER_IF.PSel   <= 1'b1;

  // Assert Penable
  ##1 `APB_MASTER_IF.PEnable <= 1'b1;

  // Deassert it
  ##1 `APB_MASTER_IF.PEnable <= 1'b0;
   
endtask: do_write


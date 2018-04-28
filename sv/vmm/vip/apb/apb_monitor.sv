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
// Description : AMBA Peripheral Bus Monitor Transactor
//
//   This BFM constantly monitors the APB bus for transactions.
//   When a valid transaction is seen, a callback occurs.
//   Note the monitor has an output channel, and is filled using sneak
//   so the channel-put (sneak) can't block
//
//    +--------------------+
//    |     APB-Monitor    |--------> Callback
//    +--------------------+
//           |||||||
//           |||||||
//           APB Bus
//
//-----------------------------------------------------------------------------

`define APB_MONITOR_IF	apb_monitor_if.monitor_cb

//-----------------------------------------------------------------------------
// APB Monitor Transactor Class
//-----------------------------------------------------------------------------
  
class apb_monitor extends vmm_xactor;
  
  // Factory Object for creating apb_trans
  apb_trans randomized_obj;

  // APB Interface (Monitor side)
  virtual apb_if.Monitor apb_monitor_if;

  // Output Channel
  apb_trans_channel out_chan;

  extern function new(string instance,
                      int stream_id = -1,
                      virtual apb_if.Monitor apb_monitor_if,
                      apb_trans_channel out_chan = null);

  extern virtual task main() ;

  extern virtual task sample_apb(ref apb_trans tr);
    
endclass: apb_monitor

//-----------------------------------------------------------------------------
// APB Monitor Callback Class
//-----------------------------------------------------------------------------

typedef class apb_monitor;
  
virtual class apb_monitor_callbacks extends vmm_xactor_callbacks;

   // Callbacks before a transaction is started
   virtual task monitor_pre_rx(apb_monitor    xactor,
                               ref apb_trans trans);
   endtask

   // Callback after a transaction is completed
   virtual task monitor_post_rx(apb_monitor xactor,
                                apb_trans  trans);
   endtask

endclass: apb_monitor_callbacks
    
//-----------------------------------------------------------------------------
// new() - Constructor
//-----------------------------------------------------------------------------
  
function apb_monitor::new(string instance,
                          int stream_id,
                          virtual apb_if.Monitor apb_monitor_if,
                          apb_trans_channel out_chan);

  super.new("APB TRANS monitor", instance, stream_id) ;

  // Allocate an output channel if needed, save a reference to the channel
  if (out_chan == null) out_chan = new("APB MASTER OUTPUT CHANNEL", instance); 
  this.out_chan       = out_chan;

  // Create the default factory object
  randomized_obj = new();
    
  // Save the inteface into a local data member
  this.apb_monitor_if = apb_monitor_if;

endfunction: new

//-----------------------------------------------------------------------------
// main() - Monitor the APB bus, and invoke callbacks
//-----------------------------------------------------------------------------
    
task apb_monitor::main();

  apb_trans tr;
    
  // Fork super.main to perform any base-class actions
  fork
    super.main();
  join_none

  // Main Monitor Loop
  while(1) begin

    //  - Create a new apb_trans using the factory method
    //  - $cast(tr, randomized_obj.copy());
    $cast(tr, randomized_obj.copy());                                    //

    // Pre-Rx Callback
    `vmm_callback(apb_monitor_callbacks ,monitor_pre_rx(this, tr));

    // Sample the bus using the apb_sample() task
    sample_apb(tr);

    // Put the trans into the output channel using sneak so it can't block
    out_chan.sneak(tr);

    //  - Add a Post-Rx Callback. Typically for Coverage or Scoreboard
    //  - `vmm_callback, apb_monitor_callbacks, monitor_post_rx(this, tr)
    `vmm_callback(apb_monitor_callbacks ,monitor_post_rx(this, tr));     //

    // Printthe transaction in debug mode    
    `vmm_debug(log, tr.psdisplay("Monitor ==>"));

  end

endtask: main

//-----------------------------------------------------------------------------
// sample_apb() - Monitor and Sample the APB bus when a valid transaction occurs
//-----------------------------------------------------------------------------

task apb_monitor::sample_apb(ref apb_trans tr);

  bit Sel;
  bit Rd_nWr;
    
  // Wait for the device to be selected
  Sel = `APB_MONITOR_IF.PSel;
  if(Sel === 0) 
     @(posedge `APB_MONITOR_IF.PSel);

  // Wait for latch enable
  @(posedge `APB_MONITOR_IF.PEnable);

  // Read/Write cycle decision
  Rd_nWr = !`APB_MONITOR_IF.PWrite;

  // Read cycle - Store current transaction parameters 
  if(Rd_nWr == 1) begin
    tr.dir  = apb_trans::READ;
    tr.data = `APB_MONITOR_IF.PRData;
    tr.addr = `APB_MONITOR_IF.PAddr;
  end
  
  // Write Cycle - Store current transaction parameters
  if(Rd_nWr == 0) begin
    tr.dir  = apb_trans::WRITE;
    tr.data = `APB_MONITOR_IF.PWData;
    tr.addr = `APB_MONITOR_IF.PAddr;
  end
    
endtask: sample_apb

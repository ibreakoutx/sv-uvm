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
// Description : Scoreboard Integration/Callbacks
//
//               This class is DUT specific, and connects the scoreboard
//               to the Testbench.
//
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Scoreback Connection via APB Master Callback Class
//-----------------------------------------------------------------------------

typedef class apb_master;
typedef class dut_sb;
    
class apb_master_sb_callbacks extends apb_master_callbacks;

  dut_sb sb;
    
  // Constructor
  function new(dut_sb sb);
    this.sb = sb;
  endfunction: new
    
  // Callbacks before a transaction is started
  virtual task master_pre_tx(apb_master    xactor,
                             ref apb_trans trans,
                             ref bit        drop);
   // Empty
  endtask

  // Callback after a transaction is completed
  virtual task master_post_tx(apb_master xactor,
                              apb_trans  trans);
    //  - call the scoreboard task from_master() and pass trans
    sb.from_master(trans);                                               //
  endtask

endclass: apb_master_sb_callbacks


//-----------------------------------------------------------------------------
// APB Monitor Callback Class
//-----------------------------------------------------------------------------

typedef class apb_monitor;
  
class apb_monitor_sb_callbacks extends apb_master_callbacks;

  dut_sb sb;
    
   // Constructor
  function new(dut_sb sb);
    this.sb = sb;
  endfunction: new

  // Callbacks before a transaction is started
  virtual task monitor_pre_rx(apb_monitor    xactor,
                              ref apb_trans trans);
  endtask

  // Callback after a transaction is completed
  virtual task monitor_post_rx(apb_monitor xactor,
                               apb_trans  trans);
  endtask

endclass: apb_monitor_sb_callbacks

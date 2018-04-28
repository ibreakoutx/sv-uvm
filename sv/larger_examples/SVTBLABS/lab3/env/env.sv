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
 * File:        $RCSfile: env.v,v $
 * Revision:    $Revision: 1.3 $  
 * Date:        $Date: 2003/07/15 15:18:31 $
 *
 *******************************************************************************
 *
 * Verification environment
 * Instanciates following modules:
 * 	- APB Generator
 * 	- APB Master
 * 	- APB Monitor
 * 	- Scoreboard
 *
 *******************************************************************************
 */

`include "apb_trans.sv"
`include "apb_if.sv"
`include "apb_master.sv"
`include "apb_monitor.sv"
`include "apb_gen.sv"
`include "scoreboard.sv"

////////////////////////////////////////////////////////////
class test_cfg;

  // Test terminates when the trans_cnt is greater than max_trans_cnt member
  rand int trans_cnt;

  constraint basic {
    (trans_cnt > 0) && (trans_cnt < 100);
  }
endclass: test_cfg



class env;

  // Test configurations
  test_cfg    tcfg;

  // Transactors
  apb_gen     gen;
  apb_master  mst;
  apb_monitor mon;
  scoreboard  scb;

  // APB transaction mailbox. Used to pass transaction
  // from APB gen to APB master, master to scoreboard, and monitor to scoreboard
  mailbox gen2mas, mas2scb, mon2scb;

  virtual apb_if.Master  aif_mst;
  virtual apb_if.Monitor aif_mon;


  function new(virtual apb_if.Master aif_mst, virtual apb_if.Monitor aif_mon);
    this.aif_mst  = aif_mst;
    this.aif_mon  = aif_mon;
    gen2mas   = new();
    mas2scb   = new();
    mon2scb   = new();
    tcfg      = new();
    if (!tcfg.randomize()) 
      begin
        $display("test_cfg::randomize failed");
        $finish;
      end
    gen      = new(gen2mas, tcfg.trans_cnt, 1);
    mst      = new(this.aif_mst, gen2mas, mas2scb, 1);
    mon      = new(this.aif_mon, mon2scb);
    scb      = new(tcfg.trans_cnt, mas2scb, mon2scb);
  endfunction: new


  virtual task pre_test();
    // Make sure the same # of transactions are expected by the scoreboard
    scb.max_trans_cnt = gen.max_trans_cnt;
    fork
      scb.main();
      mst.main();
      mon.main();
    join_none
  endtask: pre_test


  virtual task test();
    mst.reset();
    fork
      gen.main();
    join_none
  endtask: test


  virtual task post_test();
    fork
      wait(gen.ended.triggered);
      wait(scb.ended.triggered);
    join
  endtask: post_test


  task run();
    pre_test();
    test();
    post_test();
  endtask: run

endclass: env


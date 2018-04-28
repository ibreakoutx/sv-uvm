/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


//`define DUT_TOP_PATH top
`include "vmm.sv"
`include "tb_data.sv"
`include "ral_DUT.sv"
`include "tb_driver.sv"
`include "ral2drvr.sv"

class tb_env extends vmm_group;
  vmm_ral_access ral;
  ral_sys_DUT    ral_model;
  ral2drvr       ral_xactor;
  tb_data_channel ral2drvr_chan;
  
  vmm_log      log;
  function new(string name = "", vmm_object parent = null);
   super.new("TB_ENV", name, parent);
   log = new("tb_env_log", "class");
   ral_model = new(0); //disabling coverage
  endfunction

  virtual function void build_ph();
    ral = new;
    ral2drvr_chan = new("ral2drvr_chan", "class");
    ral_xactor = new("ral_xactor", ral2drvr_chan,top.dif.mst);
    this.ral.set_model(ral_model);
    this.ral.add_xactor(ral_xactor);
  endfunction

  virtual task reset_ph();
    top.rst_n <= 1;
    #1 top.rst_n <= 0;
    #20 top.rst_n <= 1;
  endtask
 
  virtual task run_ph();
    super.run_ph();
  endtask
endclass


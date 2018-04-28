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
//`include "vmm_ral.sv"
`include "tb_data.sv"
`include "ral_DUT.sv"
`include "tb_driver.sv"
`include "ral2drvr.sv"

class tb_env extends vmm_ral_env;

  ral_sys_DUT  ral_model;
  ral2drvr     ral_xactor;
  tb_driver    drvr;
  tb_data_channel ral2drvr_chan;
  vmm_log      log;

  function new();
   log = new("tb_env", "class");
   ral_model = new(0); //disabling coverage
   this.ral.set_model(ral_model);
  endfunction


  function void gen_cfg();
    super.gen_cfg();
    this.ral_model.randomize();
  endfunction

  function void build();
    super.build();
				ral2drvr_chan = new("ral2drvr_chan", "class");
    ral_xactor = new("ral_xactor", ral2drvr_chan);
    this.ral.add_xactor(ral_xactor);
    drvr = new("drvr", top.dif.mst, ral2drvr_chan);
  endfunction

  task hw_reset();
    top.rst_n <= 1;
    #1 top.rst_n <= 0;
    #20 top.rst_n <= 1;
  endtask

  task cfg_dut();
		  vmm_rw::status_e status;
    super.cfg_dut();
    drvr.start_xactor();
    ral_xactor.start_xactor();
  endtask


endclass


/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


`include "vmm.sv"
`include "alu_data.sv"
`include "trans.sv"
`include "trans_cfg.sv"
`include "t_scenario.sv"
`include "alu_driver.sv"
`include "alu_mon.sv"
`include "alu_cfg.sv"
`include "alu_cov.sv"
`include "alu_mon2cov_connector.sv"

class alu_env extends vmm_env;
   
   vmm_log log;

   alu_driver                  drv;
   alu_mon                     mon;
   alu_data_atomic_gen         gen_a;
   alu_data_scenario_gen       gen_s;
   alu_cfg                     cfg;
   alu_data_channel            alu_chan;
   trans_channel               tchan;
   alu_cov                     cov;
   alu_mon2cov_connector       mon2cov;
   virtual alu_if.drvprt       alu_drv_port;
   virtual alu_if.monprt       alu_mon_port;
   trans_cfg                   tcfg;
   t_scenario                  scn;
   trans_scenario_gen          tgen_s;

   function new(virtual alu_if.drvprt alu_drv_port, 
                virtual alu_if.monprt alu_mon_port);
     log = new ("alu_env", "class");
     cfg = new;
     tcfg = new("SCN1");
     this.alu_drv_port = alu_drv_port;
     this.alu_mon_port = alu_mon_port;
   endfunction

   function void gen_cfg();
      super.gen_cfg();  
      cfg.randomize();
      tcfg.randomize();

   endfunction

   function void build();
      super.build();
      alu_chan = new ("ALU", "channel");
      //drv = new("Driver", 0, alu_tb_top.aluif.drvprt, alu_chan);
      drv = new("Driver", 0, alu_drv_port, alu_chan);
      gen_a = new("Gen", 0, alu_chan);
      gen_s = new("ScnGen", 0, alu_chan);
      gen_a.stop_after_n_insts = cfg.num_trans;
      gen_s.stop_after_n_insts = cfg.num_trans;

      tchan = new ("tchan", "channel");
      tgen_s = new("TScengen", 0, tchan);
      tgen_s.stop_after_n_insts = cfg.num_trans;
      scn = new(tcfg.num_trans, tcfg.name);
      tgen_s.scenario_set[0] = scn;

      if (cfg.monitor_en) begin
        //mon = new("Mon", 0, alu_tb_top.aluif.monprt);
        mon = new("Mon", 0, alu_mon_port);
        cov = new;
        mon2cov = new(cov);
        mon.append_callback(mon2cov);
      end
    endfunction

   task reset_dut();
     super.reset_dut();
     //alu_tb_top.rst_n = 0;
     alu_drv_port.rst_n <= 0;
     //repeat (5) @(posedge alu_tb_top.clk);
     repeat (5) @(alu_drv_port.cb);
     //alu_tb_top.rst_n = 1;
     alu_drv_port.rst_n <= 1;
   endtask

   task cfg_dut();
      super.cfg_dut();
   endtask

    task start() ;
      super.start;
      drv.start_xactor();
      gen_a.start_xactor();
      tgen_s.start_xactor();
      if (cfg.monitor_en)
        mon.start_xactor();
      fork begin
        forever begin
          trans tr;
          tchan.get(tr);
          `vmm_note(log, tr.psdisplay("XYZ"));
          #2;
        end
      end join_none
    endtask

    task wait_for_end() ;
      super.wait_for_end;
      gen_a.notify.wait_for(alu_data_atomic_gen::DONE);
      tgen_s.notify.wait_for(trans_scenario_gen::DONE);
      #1000;
    endtask

    task stop();
      super.stop;
      drv.stop_xactor();
      gen_a.stop_xactor();
      if (cfg.monitor_en)
        mon.stop_xactor();
      tgen_s.stop_xactor();
      #100;
    endtask

endclass



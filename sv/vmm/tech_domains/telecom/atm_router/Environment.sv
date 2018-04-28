/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`include "Configuration.sv"
`include "Packet.sv"
`include "GenCovCallbacks.sv"
`include "Scoreboard.sv"
`include "GenSbCallbacks.sv"
`include "Driver.sv"
`include "DriverCovCallbacks.sv"
`include "DriverSbCallbacks.sv"
`include "Receiver.sv"
`include "ReceiverCovCallbacks.sv"
class Environment extends vmm_env;
  vmm_version          vmm_ver;
  Configuration        cfg;
  Packet_atomic_gen    gen;
  GenCovCallbacks      gen_cov_cb;
  Scoreboard           sb;
  GenSbCallbacks       gen_sb_cb;
  //GenPerfCallbacks     gen_perf;
  Driver               drv[];
  DriverCovCallbacks   drv_cov_cb;
  DriverSbCallbacks    drv_sb_cb;
  Receiver             rcv[];
  ReceiverCovCallbacks rcv_cov_cb;
  //vmm_sql_db_sqlite    tr_db;
  //vmm_perf_analyzer    tr_perf;
  virtual router_io.TB router;
          function new(virtual router_io.TB router);
            super.new("Environment");
            this.router = router;
            cfg = new();
          endfunction
  virtual function void gen_cfg();
            super.gen_cfg();
            if (!cfg.randomize()) `vmm_fatal(this.log, "Configuration Randomization Failed!\n");
          endfunction
  virtual function void build();
            super.build();
            vmm_ver = new();
            vmm_ver.display("**** Note : ");
            gen = new("gen", 0);
            gen.stop_after_n_insts = cfg.run_for_n_packets;
            sb = new("sb");
            gen_cov_cb = new();
            gen_sb_cb = new(sb);
            gen.append_callback(gen_cov_cb);
            gen.append_callback(gen_sb_cb);
            //this.tr_db = new("tr_data.db");
            //tr_perf = new("tr_perf",this.tr_db);
            //gen_perf = new(this);
            drv = new[16];
            rcv = new[16];
            drv_cov_cb = new();
            drv_sb_cb = new(sb);
            rcv_cov_cb = new();
            for(int i=0; i<drv.size; i++) begin
              drv[i] = new($psprintf("Driver[%0d]", i), i, gen.out_chan, router);
              drv[i].append_callback(drv_cov_cb);
              drv[i].append_callback(drv_sb_cb);
            end
            for(int i=0; i<rcv.size; i++) begin
              rcv[i] = new($psprintf("Receiver[%0d]", i), i, sb.in_chan, router);
              rcv[i].append_callback(rcv_cov_cb);
            end
          endfunction
  virtual task reset_dut();
            super.reset_dut();
            reset();
          endtask
  virtual task cfg_dut();
            super.cfg_dut();
          endtask
  virtual task start();
            super.start();
            if (vmm_opts::get_bit("playback","Playback into generator output")) begin
               fork begin
                  bit success;
                  Packet factory = new;
                  $display ("Going to replay ");
                  this.gen.out_chan.playback(success,"gen.dat",factory,1);
                  if (!success) begin
                      `vmm_error(this.log,"Error during playback"); 
                                     end
                    end
               join_none
              end else
              begin
               gen.start_xactor();
              end
            sb.start_xactor();
            foreach(cfg.valid_iports[i])
              drv[cfg.valid_iports[i]].start_xactor();
            foreach(cfg.valid_oports[i])
              rcv[cfg.valid_oports[i]].start_xactor();
            if (vmm_opts::get_bit("record","Record generator output")) begin
               this.gen.out_chan.record("gen.dat");
              end
          endtask
  virtual task wait_for_end();
            super.wait_for_end();
            fork
              gen.notify.wait_for(Packet_atomic_gen::DONE);
              sb.notify.wait_for(sb.DONE);
            join_any
          endtask
  virtual task stop();
            super.stop();
            gen.stop_xactor();
            foreach(drv[i])
              drv[i].stop_xactor();
            foreach(drv[i])
              drv[i].notify.wait_for(vmm_xactor::XACTOR_IDLE);
            foreach(rcv[i])
              rcv[i].notify.wait_for(vmm_xactor::XACTOR_IDLE);
          endtask
  virtual task cleanup();
            super.cleanup();
          endtask
  virtual task report();
            super.report();
//            this.tr_perf.save_db();
            //this.tr_perf.save_db_txt("Generator_perf.txt");
            //this.tr_perf.report();
            sb.report();
          endtask

  virtual protected task reset();
    `vmm_trace(this.log, $psprintf("%m"));
    router.reset_n <= 1'b0;
    router.cb.frame_n <= '1;
    router.cb.valid_n <= '1;
    ##2 router.cb.reset_n <= 1'b1;
    repeat(15) @(router.cb);
  endtask
endclass


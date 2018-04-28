/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`timescale 1ns/100ps
`include "vmm.sv"
`include "Environment.sv"

class newPacket extends Packet;
  Configuration cfg;
  constraint test {
    payload.size inside { [2:4] };
    sa inside cfg.valid_iports;
    da inside cfg.valid_oports;
  }
  function new(Configuration cfg);
    this.cfg = cfg;
  endfunction
  function void post_randomize();
    super.post_randomize();
    `vmm_debug(this.log, this.psdisplay());
  endfunction
endclass

program automatic test(router_io.TB router);
initial begin
  Environment env = new(router);
  newPacket pkt;
  env.cfg.run_for_n_packets.rand_mode(0);
  env.cfg.num_of_iports.rand_mode(0);
  env.cfg.num_of_oports.rand_mode(0);
  env.cfg.run_for_n_packets = 0;
  env.cfg.num_of_iports = 16;
  env.cfg.num_of_oports = 16;
  env.gen_cfg();
  env.cfg.display();
  env.build();
  pkt = new(env.cfg);
  env.gen.randomized_obj = pkt;
  env.run();
end
endprogram


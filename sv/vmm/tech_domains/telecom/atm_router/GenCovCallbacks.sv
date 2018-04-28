/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class GenCovCallbacks extends Packet_atomic_gen_callbacks;

  bit[3:0] sa, da;

  covergroup gen_port_cov;
    coverpoint sa;
    coverpoint da;
    cross sa, da;
    option.weight = 0;
  endgroup

  function new();
    gen_port_cov = new();
  endfunction

  virtual task post_inst_gen(Packet_atomic_gen gen, Packet obj, ref bit drop);
    this.sa = obj.sa;
    this.da = obj.da;
    gen_port_cov.sample();
  endtask

endclass

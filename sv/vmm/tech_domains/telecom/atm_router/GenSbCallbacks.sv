/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class GenSbCallbacks extends Packet_atomic_gen_callbacks;

  Scoreboard sb;
  function new(Scoreboard sb);
    this.sb = sb;
  endfunction

  virtual task post_inst_gen(Packet_atomic_gen gen, Packet obj, ref bit drop);
    this.sb.deposit_genpkt(obj);
  endtask

endclass

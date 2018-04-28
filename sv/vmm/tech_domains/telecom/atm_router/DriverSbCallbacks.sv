/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class DriverSbCallbacks extends DriverCallbacks;
  Scoreboard sb;
  function new(Scoreboard sb);
    this.sb = sb;
  endfunction

  virtual task post_send(Packet pkt);
    this.sb.deposit_sentpkt(pkt);
  endtask

endclass

/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class ReceiverCovCallbacks extends ReceiverCallbacks;
  bit[3:0] da;

  covergroup rcvr_port_cov;
    coverpoint da;
    option.weight = 0;
  endgroup

  function new();
    rcvr_port_cov = new();
  endfunction

  virtual task post_recv(Packet pkt);
    this.da = pkt.da;
    rcvr_port_cov.sample();
  endtask

endclass

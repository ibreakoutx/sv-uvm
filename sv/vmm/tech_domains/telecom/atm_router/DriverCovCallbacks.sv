/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class DriverCovCallbacks extends DriverCallbacks;
  bit[3:0] sa, da;

  covergroup drvr_port_cov;
    coverpoint sa;
    coverpoint da;
    cross sa, da;
    option.weight = 0;
  endgroup

  function new();
    drvr_port_cov = new();
  endfunction

  virtual task post_send(Packet pkt);
    this.sa = pkt.sa;
    this.da = pkt.da;
    drvr_port_cov.sample();
  endtask

endclass

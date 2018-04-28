/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class Scoreboard extends vmm_xactor;
  static int DONE;
  static int pkts_checked = 0;
  static int gen_pkt_count = 0;
  static int sent_pkt_count = 0;
  static int recvd_pkt_count = 0;

  protected bit[3:0] sa, da;
  Packet         refPkts[$];
  Packet         genPkts[$];
  Packet         pktsent;
  Packet_channel in_chan;

  int coverage_filter_size;
  int coverage_filter_warnings;

  covergroup sb_cov;
    coverpoint sa { option.weight = 0; }
    coverpoint da { option.weight = 0; }
    cross sa, da;
  endgroup

  extern function new(string instance = "class", Packet_channel in_chan = null);
  extern virtual protected task main();
  extern virtual function void deposit_sentpkt(Packet pkt);
  extern virtual function void deposit_genpkt(Packet pkt);
  extern function void check(Packet pktrecvd);
  extern virtual function int final_check();
  extern virtual function void report();
endclass

function Scoreboard::new(string instance, Packet_channel in_chan);
  super.new("Scoreboard", instance);
  `vmm_trace(this.log, $psprintf("%m"));
  if (in_chan == null)
    in_chan = new("Scoreboard in_chan", instance);
  this.in_chan = in_chan;
  this.DONE     = this.notify.configure(-1, vmm_notify::ON_OFF);
  this.coverage_filter_warnings = 100; // terminates simulation if exceeded
  this.sb_cov = new();
endfunction

task Scoreboard::main();
  int pkts_from_receiver = 0;
  int warning = 0, coverage_repeated = 0;
  real coverage_result, coverage_result_prev = 0;
  Packet pkt;

  super.main();
  `vmm_trace(this.log, $psprintf("%m"));

  while(1) begin
    in_chan.get(pkt);
    `vmm_debug(log, pkt.psdisplay("Receiver to Scoreboard"));
    recvd_pkt_count++;
    check(pkt);
    pkts_checked++;
    coverage_result_prev = coverage_result;
    coverage_result = $get_coverage();
    if (coverage_result == 100) begin
      `vmm_note(log, $psprintf("%0d packets checked.  Coverage = %0f", pkts_checked, coverage_result));
      this.notify.indicate(this.DONE);
      continue;
    end
    if (coverage_result == coverage_result_prev) begin
      coverage_filter_size = (coverage_result * 16 * 16 * 4)/100 + 100;
      if (++coverage_repeated >= coverage_filter_size) begin
        if (++warning >= coverage_filter_warnings + 10) begin
          `vmm_warning(log, $psprintf("Terminating Point Reached.  %0d packets checked.  Coverage = %0f\n", pkts_checked, coverage_result));
          this.notify.indicate(this.DONE);
          continue;
        end
        if (warning >= coverage_filter_warnings) begin
          `vmm_warning(log, $psprintf("Diminished Return Reached.  %0d packets checked.  Coverage = %0f\n", pkts_checked, coverage_result));
          continue;
        end
        `vmm_warning(log, $psprintf("Repeating coverage %0d times.  %0d packets checked.  Coverage = %0f\n", warning + coverage_filter_size, pkts_checked, coverage_result));
        continue;
      end
    end
    else begin
      coverage_repeated = 0;
      warning = 0;
    end
    `vmm_note(log, $psprintf("%0d packets checked.  Coverage = %0f", pkts_checked, coverage_result));
  end
endtask

function void Scoreboard::deposit_sentpkt(Packet pkt);
  string dontcare;
  `vmm_trace(this.log, $psprintf("%m"));
  `vmm_debug(log, pkt.psdisplay("Driver to Scoreboard"));
  refPkts.push_back(pkt);
  sent_pkt_count++;
  foreach(genPkts[i]) begin
    if ((genPkts[i].sa == pkt.sa) && (genPkts[i].compare(pkt, dontcare))) begin
      genPkts.delete(i);
      return;
    end
  end
  pkt.display("ERROR");
  `vmm_fatal(log, $psprintf("Sent packet does not match generated packet\n%m\n\n"));
endfunction

function void Scoreboard::deposit_genpkt(Packet pkt);
  `vmm_trace(this.log, $psprintf("%m"));
  `vmm_debug(log, pkt.psdisplay("Generator to Scoreboard"));
  genPkts.push_back(pkt);
  gen_pkt_count++;
endfunction

function void Scoreboard::check(Packet pktrecvd);
  int    index[$];
  string diff;
  `vmm_trace(this.log, $psprintf("%m"));

  index = refPkts.find_first_index() with (item.da == pktrecvd.da);
  if (index.size() <= 0)
    `vmm_fatal(log, $psprintf("Matching packet not found\n%m\n\n"));
  pktsent = refPkts[index[0]];
  refPkts.delete(index[0]);

  if (!pktsent.compare(pktrecvd, diff)) begin:failed_compare
    pktrecvd.display("ERROR");
    pktsent.display("ERROR");
    `vmm_fatal(log, $psprintf("%s\n%m\n\n", diff));
  end:failed_compare
  this.sa = pktsent.sa;
  this.da = pktsent.da;
  sb_cov.sample();
endfunction

function int Scoreboard::final_check();
  `vmm_trace(this.log, $psprintf("%m"));
  final_check = (genPkts.size() || refPkts.size()) ? 0 : 1;
endfunction

function void Scoreboard::report();
  `vmm_trace(this.log, $psprintf("%m"));
  foreach(refPkts[i])
    `vmm_warning(log, $psprintf("packet#%0d.%0d.%0d was sent into Router but not checked\n", refPkts[i].stream_id, refPkts[i].scenario_id, refPkts[i].data_id));
  $display("[Scoreboard]: %0d packets generated, %0d packets sent, %0d packets sampled, %0d packets checked\n", gen_pkt_count, sent_pkt_count, recvd_pkt_count, pkts_checked);
endfunction

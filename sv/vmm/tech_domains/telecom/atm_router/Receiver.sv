/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class ReceiverCallbacks extends vmm_xactor_callbacks;
  virtual task pre_recv(Packet pkt); endtask
  virtual task post_recv(Packet pkt); endtask
endclass
class Receiver extends vmm_xactor;
  virtual router_io.TB router;
  Packet         pktrecvd;
  Packet_channel out_chan;

  function new(string instance = "class", int stream_id = -1, Packet_channel out_chan = null, virtual router_io.TB router);
    super.new("Receiver", instance);
    `vmm_trace(this.log, $psprintf("%m"));
    if (out_chan == null)
      out_chan = new("Receiver out_chan", instance);
    this.out_chan = out_chan;
    this.stream_id = stream_id;
    this.router = router;
    pktrecvd = new();
    pktrecvd.da = this.stream_id;
    pktrecvd.data_id = 0;
    pktrecvd.scenario_id = 0;
  endfunction

  virtual protected task main();
    super.main();
    `vmm_trace(this.log, $psprintf("%m"));
    forever begin
      Packet pkt;
      `vmm_callback(ReceiverCallbacks, pre_recv(pktrecvd));
      recv();
      $cast(pkt, pktrecvd.copy());
      `vmm_callback(ReceiverCallbacks, post_recv(pkt));
      out_chan.put(pkt);
    end
  endtask

  task recv();
    Packet   pkt;
    reg[7:0] payload[$];

    `vmm_trace(this.log, $psprintf("%m"));
    this.notify.indicate(vmm_xactor::XACTOR_IDLE);
    fork
      begin @(negedge router.cb.frameo_n[stream_id]); end
      begin
        repeat(100000) @(router.cb);
        `vmm_fatal(this.log, $psprintf("Frame timed out!\n%m\n\n"));
      end
    join_any
    disable fork;
    this.notify.reset(vmm_xactor::XACTOR_IDLE);

    begin
      reg[7:0] datum;

      payload.delete();

      while(!router.cb.frameo_n[stream_id]) begin
        for(int i=0; i<8; ) begin
          if (!router.cb.valido_n[stream_id])
            datum[i++] = router.cb.dout[stream_id];
          if (i == 8) begin
            payload.push_back(datum);
            if (router.cb.frameo_n[stream_id])
              break;
          end
          else if (router.cb.frameo_n[stream_id]) begin
            pktrecvd.display("ERROR");
            `vmm_fatal(this.log, $psprintf("Error with frame signal\n%m\n\n"));
            $finish;
          end
          @(router.cb);
        end
      end
    end

    pktrecvd.payload = new[payload.size()];
    foreach(payload[i])
      pktrecvd.payload[i] = payload[i];

    pktrecvd.data_id++;
  endtask

endclass

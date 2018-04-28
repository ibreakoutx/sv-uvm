/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class DriverCallbacks extends vmm_xactor_callbacks;
  virtual task pre_send(Packet pkt); endtask
  virtual task post_send(Packet pkt); endtask
endclass
class Driver extends vmm_xactor;
  virtual router_io.TB router;
  Packet         pkt2send;
  Packet_channel in_chan;

  function new(string instance = "class", int stream_id = -1, Packet_channel in_chan = null, virtual router_io.TB router);
    super.new("Driver", instance);
    `vmm_trace(this.log, $psprintf("%m"));
    if (in_chan == null)
      in_chan = new("Driver in_chan", instance);
    this.in_chan   = in_chan;
    this.stream_id = stream_id;
    this.router    = router;
  endfunction

  virtual protected task main();
    super.main();
    `vmm_trace(this.log, $psprintf("%m"));
    forever begin
      Packet pkt;
      wait_if_stopped_or_empty(in_chan);
      in_chan.get(pkt2send);
      `vmm_callback(DriverCallbacks, pre_send(pkt2send));
      send();
      $cast(pkt, pkt2send.copy());
      `vmm_callback(DriverCallbacks, post_send(pkt));
    end
  endtask

  virtual task send();
    reg[7:0] datum;
    `vmm_trace(this.log, $psprintf("%m"));
    this.notify.reset(vmm_xactor::XACTOR_IDLE);
    router.cb.frame_n[stream_id] <= 1'b0;
    for(int i=0; i<4; i++) begin
      router.cb.din[stream_id] <= pkt2send.da[i];
      @(router.cb);
    end
    router.cb.din[stream_id] <= 1'b1;
    router.cb.valid_n[stream_id] <= 1'b1;
    repeat(5) @(router.cb);
    while(!router.cb.busy_n[stream_id]) @(router.cb);
    foreach(pkt2send.payload[index]) begin
      datum = pkt2send.payload[index];
      for(int i=0; i<8; i++) begin
        router.cb.din[stream_id] <= datum[i];
        router.cb.valid_n[stream_id] <= 1'b0;
        router.cb.frame_n[stream_id] <= (pkt2send.payload.size() == (index + 1)) && (i==7);
        @(router.cb);
      end
    end
    router.cb.valid_n[stream_id] <= 1'b1;
    this.notify.indicate(vmm_xactor::XACTOR_IDLE);
  endtask

endclass

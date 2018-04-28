/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


`include "vmm.sv"

class tr extends vmm_data;
   `vmm_data_member_begin(tr)
   `vmm_data_member_end(tr)
endclass
`vmm_channel(tr)
`vmm_atomic_gen(tr, "tr")
`vmm_scenario_gen(tr, "tr")

class xact extends vmm_xactor;
   tr_channel in_chan, out_chan;
   
   function new(string inst,
		tr_channel in_chan = null,
                tr_channel out_chan = null);
      super.new("Xact", inst);
      if (in_chan == null) in_chan = new("TR INPUT CHANNEL", inst);
      if (out_chan == null) out_chan = new("TR OUTPUT CHANNEL", inst);
      this.in_chan = in_chan;
      this.in_chan.set_consumer(this);
      this.out_chan = out_chan;
      this.out_chan.set_producer(this);      
   endfunction
endclass

program test;   
   
initial
begin
   vmm_log log = new("Test", "Main");
	
   tr_atomic_gen agen = new("A Gen");
   tr_scenario_gen sgen = new("S Gen");
   xact xactor = new("Xact", agen.out_chan);
   
   $write("Start of test...\n");

   $write("Verifying basic setting/reporting...\n");
   if (agen.out_chan.get_consumer() != xactor) begin
      `vmm_error(log, "Wrong consumer for agen.out_chan");
   end
   if (xactor.in_chan.get_producer() != agen) begin
      `vmm_error(log, "Wrong producer for xactor.in_chan");
   end
   if (xactor.out_chan.get_producer() != xactor) begin
      `vmm_error(log, "Wrong producer for xactor.out_chan");
   end
   if (xactor.out_chan.get_consumer() != null) begin
      `vmm_error(log, "Wrong consumer for xactor.out_chan");
   end

   $write("Checking transactor input/ouput channels...\n");
   begin
      tr_channel chan1 = new("tr_channel", "chan1");
      tr_channel chan2 = new("tr_channel", "chan2");
      tr_channel chan3 = new("tr_channel", "chan3");
      
      vmm_channel chans[$];
      bit found;

      chan1.set_producer(sgen);
      chan2.set_producer(sgen);
      chan3.set_producer(sgen);
      chan2.set_producer(null);
      chan1.set_consumer(xactor);
      chan2.set_consumer(xactor);
      chan3.set_consumer(xactor);
      chan3.set_consumer(null);

      sgen.get_output_channels(chans);
      if (chans.size() != 3) begin
         `vmm_error(log, $psprintf("sgen has %0d output channels instead of 3",
                                   chans.size()));
      end
      found = 0;
      foreach (chans[i]) begin
         if (chans[i] == sgen.out_chan) begin
            found = 1;
            break;
         end
      end
      if (!found) `vmm_error(log, "sgen.out_chan is not one of sgen's output channels");
      found = 0;
      foreach (chans[i]) begin
         if (chans[i] == chan1) begin
            found = 1;
            break;
         end
      end
      if (!found) `vmm_error(log, "chan1 is not one of sgen's output channels");
      found = 0;
      foreach (chans[i]) begin
         if (chans[i] == chan3) begin
            found = 1;
            break;
         end
      end
      if (!found) `vmm_error(log, "chan3 is not one of sgen's output channels");

      xactor.get_input_channels(chans);
      if (chans.size() != 3) begin
         `vmm_error(log, $psprintf("xactor has %0d output channels instead of 3",
                                   chans.size()));
      end
      found = 0;
      foreach (chans[i]) begin
         if (chans[i] == xactor.in_chan) begin
            found = 1;
            break;
         end
      end
      if (!found) `vmm_error(log, "xactor.in_chan is not one of xactor's output channels");
      found = 0;
      foreach (chans[i]) begin
         if (chans[i] == chan1) begin
            found = 1;
            break;
         end
      end
      if (!found) `vmm_error(log, "chan1 is not one of xactor's output channels");
      found = 0;
      foreach (chans[i]) begin
         if (chans[i] == chan2) begin
            found = 1;
            break;
         end
      end
      if (!found) `vmm_error(log, "chan2 is not one of xactor's output channels");

      $write("Checking xactor::kill()...\n");
      sgen.kill();

      sgen.get_output_channels(chans);
      if (chans.size() != 0) begin
         `vmm_error(log, $psprintf("sgen has %0d output channels instead of 0",
                                   chans.size()));
         foreach (chans[i]) $write("%s\n",
                                   chans[i].psdisplay("    Channel: "));
      end
      if (sgen.out_chan.get_producer() != null) `vmm_error(log, "sgen.out_chan still has a producer");
      if (chan1.get_producer() != null) `vmm_error(log, "chan1 still has a producer");
      if (chan3.get_producer() != null) `vmm_error(log, "chan1 still has a producer");
     
   end

   $write("Checking multiple producer/consumer warnings...\n");
   begin
      int wp;
      int watched;
      vmm_log_msg msg;

      wp = agen.out_chan.log.create_watchpoint();
      agen.out_chan.log.add_watchpoint(wp);

      fork
         begin: watcher
            forever begin
               agen.out_chan.log.wait_for_watchpoint(wp, msg);
               watched++;
            end
         end
      join_none
      #10;

      agen.out_chan.set_producer(agen); // No warning
      #10;
      if (watched != 0) begin
         `vmm_error(log, "Unexpected message issued by set_producer()");
      end
      watched = 0;

      agen.out_chan.set_consumer(xactor); // No warning
      #10;
      if (watched != 0) begin
         `vmm_error(log, "Unexpected message issued by set_consumer()");
      end
      watched = 0;

      agen.out_chan.set_consumer(agen); // Warning
      #10;
      if (watched != 1) begin
         `vmm_error(log, "No expected message issued by set_consumer()");
      end
      watched = 0;

      agen.out_chan.set_producer(xactor); // Warning
      #10;
      if (watched != 1) begin
         `vmm_error(log, "No expected message issued by set_producer()");
      end
      watched = 0;
   end


   $write("** Expect PASSED with 2 warnings...\n");
   log.report();
end
endprogram

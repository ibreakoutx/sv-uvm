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
   `include "my_data.sv"

program test_vmm_bcast;

   class consumer;
      my_data_channel channel;
      my_data sb[$];
    
      function new( integer i);
         channel = new("Output Channel", $psprintf("#%0d", i), 1);
      endfunction : new
   endclass

   vmm_log log = new("vmm_broadcast", "test");
   
   my_data_channel in_chan = new("Input Channel", "", 5);

   task get_from_channel(consumer c, integer i);

      my_data obj, exp, obj1;

      c.channel.get(obj);

      $cast(obj1, obj);
      obj1.display($psprintf("Rx on #%0d: ", i));

      // First of all, it should be a copy, not a reference
      exp = c.sb.pop_front();
      if (i == 1) begin
         // Copy channels
         if (obj == exp) begin
            `vmm_error(log, $psprintf("Output channel #%0d received a reference instead of a copy", i));
         end
         if (obj.data !== exp.data) begin
            `vmm_error(log, $psprintf("Output channel #%0d received an invalid copy", i));
         end
      end else begin
         // Ref channels
         if (obj != exp) begin
            `vmm_error(log, $psprintf("Output channel #%0d received an invalid reference", i));
         end
      end
   endtask

   consumer out[3];
   
   integer i;

initial begin : pgm
   integer chan_id[3];

   vmm_broadcast bcast = new("Bcast", "", in_chan, 1);

   bcast.start_xactor();

   bcast.log.set_verbosity(vmm_log::VERBOSE_SEV); // To be commented
   for (i = 0; i < 3; i++) begin
      out[i] = new(i);
   end 

   `vmm_note(log, "Verifying sinking of source channel without output channels...");

   repeat (3) begin
      my_data obj = new;
      void'(obj.randomize());
      obj.display("Putting: ");
      in_chan.put(obj);
      #10;
      if (in_chan.level() > 0) begin
         `vmm_error(log, "Source channel is not sunk with no output channels");
      end
   end

   // Verify that broadcasting is ON by default
   chan_id[0] = bcast.new_output(out[0].channel, 1'bx);
   chan_id[1] = bcast.new_output(out[1].channel, 1'b0);
   chan_id[2] = bcast.new_output(out[2].channel, 1'b1);

    

   `vmm_note(log, "Verifying basic broadcasting operations...");
   repeat (3) begin
      my_data obj = new;
      void'(obj.randomize());
      for (i = 0; i < 3; i++) begin
         out[i].sb.push_back(obj);
      end
      obj.display("Putting: ");
      in_chan.put(obj);
   end
   in_chan.display();
   #10;
   // The level in the input channel should be 2
   // as the first element is moved to the output channels
   if (in_chan.level() != 2) begin
      `vmm_error(log, $psprintf("Source channel contains %0d elements instead of 2", in_chan.level()));
   end
   // With one element in each output channel
   for (i = 0; i < 3; i++) begin
      if (out[i].channel.level() != 1) begin
         `vmm_error(log, $psprintf("Output channel #%0d contains %0d elements instead of 1", i, out[i].channel.level()));
      end
   end

   `vmm_note(log, "Verifying new broadcasting cycle on empty output channel...");
   // If I get one element from one channel, it should cause another
   // element from the input channel to be broadcasted
   get_from_channel(out[0], 0);
   #10;
   for (i = 1; i < 3; i++) begin
      if (out[i].channel.level() != 2) begin
         `vmm_error(log, $psprintf("Output channel #%0d contains %0d elements instead of 2", i, out[i].channel.level()));
      end
   end
   i = 0;
   if (out[i].channel.level() != 1) begin
      `vmm_error(log, $psprintf("Output channel #%0d contains %0d elements instead of 1", i, out[i].channel.level()));
   end
   repeat (3) begin
      my_data obj = new;
      void'(obj.randomize());
      for (i = 0; i < 3; i++) begin
         out[i].sb.push_back(obj);
      end
      obj.display("Putting: ");
      in_chan.put(obj);
   end
   #10;
   if (in_chan.level() != 4) begin
      `vmm_error(log, $psprintf("Source channel contains %0d elements instead of 4", in_chan.level()));
   end

   `vmm_note(log, "Verifying no broadcast cycle when getting from >1 output channel...");
   // If I get one element from a channel with >1 element,
   // it should NOT cause another element from the input channel
   // to be broadcasted
   get_from_channel(out[2], 2);
   #10;
   i = 2;
   if (out[i].channel.level() != 1) begin
      `vmm_error(log, $psprintf("Output channel #%0d contains %0d elements instead of 1", i, out[i].channel.level()));
   end
   i = 0;
   if (out[i].channel.level() != 1) begin
      `vmm_error(log, $psprintf("Output channel #%0d contains %0d elements instead of 2", i, out[i].channel.level()));
   end
   i = 1;
   if (out[i].channel.level() != 2) begin
      `vmm_error(log, $psprintf("Output channel #%0d contains %0d elements instead of 1", i, out[i].channel.level()));
   end
   if (in_chan.level() != 4) begin
      `vmm_error(log, $psprintf("Source channel contains %0d elements instead of 4", in_chan.level()));
   end

   `vmm_note(log, "Verifying broadcast content...");
   // Verify the remaining content
   for(int i=0; i<$size(out); i++) begin 
      while (out[i].channel.level() > 0) begin
         get_from_channel(out[i], i);
      end
   end
   log.report();
   end :pgm
endprogram

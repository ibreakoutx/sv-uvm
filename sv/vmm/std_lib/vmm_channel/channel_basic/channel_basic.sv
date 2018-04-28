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

program test_data;
  typedef class my_data;
  `include "my_data.sv"
   vmm_log  log;
  
task test_channel(my_data_channel channel,
                  integer         full,
                  integer         empty);

   string msg;
   bit blocked;
   event go;
  my_data unused_data;
   
   `vmm_note(log, $psprintf("Testing channel with full = %0d and empty = %0d",
                          full, empty));

   if (channel == null) begin
      channel = new("channel", "", full, empty);
   end else begin
      channel.reconfigure(full, empty);
   end

   if (channel.level() != 0) begin
      `vmm_error(log, "Channel did not initialize empty");
   end

   // Correct for boundary conditions
   if (full == 0) begin
      full = 1;
   end
   if (empty == full) begin
      empty = full - 1;
   end

   
   `vmm_note(log, "Verifying blocking at full");
   log.start_msg(vmm_log::NOTE_TYP);
   log.text();
   blocked = 0;
   fork
   begin
      if (channel.level() != full) begin
         
         `vmm_error(log, $psprintf("Channel.put() blocked at level = %0d instead of %0d",
                                 channel.level(), full));
      end
      channel.flush();
      blocked = 1;
   end
   join_none
   repeat (full) begin
      my_data data = new;
      channel.put(data);
   end
   if (blocked == 0) begin
      `vmm_error(log, $psprintf("Channel.put() not blocked after %d put()'s",
                              full));
   end
   disable fork;
   channel.flush();

   
   `vmm_note(log, "Verifying blocking until empty");
   blocked = 0;
   fork
   begin : f_p1
      repeat (full) begin
         my_data data = new;
         channel.put(data);
      end
      if (channel.level() != empty) begin
         `vmm_error(log, $psprintf("Channel.put() unblocked at level = %0d instead of %0d",
                                 channel.level(), empty));
      end
   end
   begin : f_g1
     repeat (channel.level()) begin
        my_data data;
         channel.get(data);
         // Give a chance to the put() process to unblock if possible
         repeat (10) begin
         #0;
      end // repeat
      end
   end
   join
   channel.flush();


   if (empty > 0) begin
      `vmm_note(log, "Verifying get() blocks only at 0");
      blocked = 0;
      repeat (full-1) begin
         my_data data = new;
         channel.put(data);
      end
      fork
      begin
         my_data data = new;
         
         if (channel.level() > 0) begin
            `vmm_error(log, $psprintf(msg, "Channel.peek() or Channel.get() blocked at level = %0d instead of 0",
                                    channel.level()));
         end
         blocked = 1;
         channel.put(data);
      end
      join_none
      while (channel.level() > 0) begin
         vmm_data obj1, obj2;
         channel.peek(obj1);
         channel.get(obj2);
         if (obj1 != obj2) begin
            `vmm_error(log, "Channel.peek() did not return the same object as Channel.get()");
            obj1.display("peek(): ");
            obj2.display("get():  ");
         end
      end
      // Should block on this one
      channel.get(unused_data);
      if (blocked == 0) begin
         `vmm_error(log, "Channel this not block on get()");
      end
      disable fork;

      `vmm_note(log, "Verifying peek() blocks only at 0");
      blocked = 0;
      repeat (full-1) begin
         my_data data = new;
         channel.put(data);
      end
      fork
      begin
         my_data data = new;
         
         if (channel.level() > 0) begin
            `vmm_error(log, $psprintf("Channel.peek() blocked at level = %0d instead of 0",
                                    channel.level()));
         end
         blocked = 1;
         channel.put(data);
      end
      join_none
      while (channel.level() > 0) begin
         vmm_data obj1, obj2;
         channel.peek(obj1);
         channel.get(obj2);
         if (obj1 != obj2) begin
            `vmm_error(log, "Channel.peek() did not return the same object as Channel.get()");
            obj1.display("peek(): ");
            obj2.display("get():  ");
         end
      end
      // Should block on this one
      channel.peek(unused_data);
      if (blocked == 0) begin
         `vmm_error(log, "Channel this not block on peek()");
      end
      disable fork;
   end
   channel.flush();
   
   `vmm_note(log, "Verifying tee() operations");
   begin
      bit [7:0] sb[*];

      fork
      begin
         integer i = 0;
         
         repeat (15) begin
            my_data data = new;
            data.randomize();

            sb[i++] = data.data;
            channel.put(data);
         end
      end
      begin
         integer i = 5;
         
         repeat (10) begin
            my_data data;
            channel.tee(data);
            if (data.data !== sb[i]) begin
               `vmm_error(log, $psprintf("Invalid tee() data #%0d through channel: 8'h%h instead of 8'h%h",
                                       i, data.data, sb[i]));
            end
            i++;
         end
      end
      join_none
      begin
         integer i = 0;
         bit mode = 1;
         
         repeat (3) begin
            repeat (5) begin
               my_data data;
               channel.get(data);
               if (data.data !== sb[i]) begin
                  `vmm_error(log, $psprintf("Invalid get() data #%0d through channel: 8'h%h instead of 8'h%h",
                                          i, data.data, sb[i]));
               end
               i++;
            end
            mode = channel.tee_mode(mode);
         end
      end
      disable fork;
   end
   channel.tee_mode(0);
endtask : test_channel

   my_data_channel channel = null;
my_data unused_data;
initial
  begin : chan_stim
   log = new("Channel test", "Program");
   test_channel(channel, 0, 0);
   test_channel(channel, 1, 0);
   test_channel(channel, 5, 0);
   test_channel(channel, 5, 1);
   test_channel(channel, 5, 5);

   channel = new("Data Channel", "Resized");
   test_channel(channel, 5, 0);
   test_channel(channel, 5, 1);
   test_channel(channel, 5, 5);
   test_channel(channel, 5, 0);
   test_channel(channel, 1, 0);

   
   `vmm_note(log, "Verifying unblocking on configuration");
   begin
      my_data_channel channel = new("channel", "", 1, 0);
      my_data data;
      bit blocked = 1;

      fork
      begin
         data = new;
         channel.put(data);
         blocked = 0;
      end
      join_none
      repeat (10) #0;
      if (!blocked) begin
         `vmm_error(log, "Producer thread is not blocked");
      end
      channel.reconfigure(2);
      repeat (10) #0;
      if (blocked) begin
         `vmm_error(log, "Producer thread is STILL blocked");
      end
      blocked = 1;
      fork
      begin
         data = new;
         channel.put(data);
         blocked = 0;
      end
      join_none
      repeat (10) #0;
      if (!blocked) begin
         `vmm_error(log, "Producer thread is not blocked");
      end
      channel.reconfigure(1);
      repeat (10) #0;
      if (!blocked) begin
         `vmm_error(log, "Producer thread did not remain blocked");
      end
   end
   
   
   `vmm_note(log, "Verifying fairness for multiple contributors");
   begin
      my_data_channel   channel  = new("channel", "");
      integer        contrib[3];
      integer i;
      integer        total;

      total = 0;
      for (i = 0; i < 2; i++) begin
         fork
         begin
            my_data data;

            contrib[i] = 0;
            while (1) begin
               data = new;
               total++;
               contrib[i]++;
               channel.put(data);
            end
         end
         join_none
      end
      fork
         while (1) begin
            channel.get(unused_data);
         end
      join_none
      while (total < 100) begin
         @(total);
      end
      if (contrib[0] + contrib[1] + contrib[2] != total) begin
         `vmm_fatal(log, "Internal error: sum of contrib[i] != total");
      end
      if (contrib[0] * 100 / total < 30 ||
          contrib[1] * 100 / total < 30 ||
          contrib[2] * 100 / total < 30) begin
         `vmm_error(log, $psprintf("Unfair to contributors: %d/%d/%d of %d",
                                 contrib[0], contrib[1], contrib[2], total));
      end
      disable fork;
   end

   
   `vmm_note(log, "Verifying fairness for multiple consumers");
   begin
      my_data_channel   channel  = new("channel", "");
      integer        consum[3];
      integer i;
      integer        total;

      total = 0;
      fork
         while (1) begin
            my_data data = new;
            channel.put(data);
         end
      join_none
      for (i = 0; i < 2; i++) begin
         fork
         begin
            consum[i] = 0;
            while (1) begin
               channel.get(unused_data);
               total++;
               consum[i]++;
            end
         end
         join_none
      end
      while (total < 100) begin
         @(total);
      end
      if (consum[0] + consum[1] + consum[2] != total) begin
         `vmm_fatal(log, "Internal error: sum of consum[i] != total");
      end
      if (consum[0] * 100 / total < 30 ||
          consum[1] * 100 / total < 30 ||
          consum[2] * 100 / total < 30) begin
         `vmm_error(log, $psprintf("Unfair to consumers: %d/%d/%d of %d",
                                 consum[0], consum[1], consum[2], total));
      end
      disable fork;
   end


   `vmm_note(log, "Verifying debug operations");
   begin
      my_data_channel channel = new("channel", "", 3);

      channel.log.set_verbosity(vmm_log::DEBUG_SEV, "/./", "/./");

      fork
         repeat (10) begin
            my_data data = new;
            data.randomize();

            channel.put(data);
         end
         repeat (10) begin
            my_data data;
            channel.get(data);
         end
      join
   end

   log.report("/./");
   

end // initial chan_stim
      //  */
endprogram : test_data


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

program test;

initial begin
   int ID = 99;
   real timestamp, then;
   int blocked;

   vmm_log log = new("My log", "");
   vmm_notify ntfy = new(log);

   $timeformat(-3, 3, "ns", 1);

   `vmm_note(log, "Verifying ON/OFF events...");
   void'(ntfy.configure(ID, vmm_notify::ON_OFF ));
   if (ntfy.is_on(ID)) begin
      `vmm_error(log, "Event is ON after configuration");
   end

   blocked = 0;
   fork
   begin
      blocked = 1;
      ntfy.wait_for(ID);
      blocked = 0;
   end
   join_none
   #(5);
   //
   // Check that a thread is waiting for the event is reported
   if (!blocked) begin
      `vmm_error(log, "vmm_notify::wait_for() did not block");
   end
   if (!ntfy.is_waited_for(ID)) begin
      `vmm_error(log, "rvm_notify::is_waited_for() did not report the notification as being waited on");
   end
   if (ntfy.is_on(ID)) begin
      `vmm_error(log, "The notification is reported as ON before indication");
   end

   #(10);
   timestamp = $realtime;
   `vmm_trace(log, "...indicating ON/OFF event");
   ntfy.indicate(ID);

   if (!ntfy.is_on(ID)) begin
      `vmm_error(log, "Notification not reported as ON");
   end

   #(5);
   if (blocked) begin
      `vmm_error(log, "vmm_notify::wait_for() is still blocked");
   end
   // Check that no thread is waiting for the event is reported
   if (ntfy.is_waited_for(ID)) begin
      `vmm_error(log, "A thread is still reported as waiting for the notification");
   end
   then = ntfy.timestamp(ID);
   if (then != timestamp) begin
      `vmm_error(log, $psprintf("Notification reported at %0d instead of %0d",
                              then, timestamp));
   end

   `vmm_note(log, "...checking that it remains on...");
   #(10);
   
   blocked = 0;
   fork
   begin
      blocked = 1;
      ntfy.wait_for(ID);
      blocked = 0;
   end
   join_none
   #(5);
   if (blocked) begin
      `vmm_error(log, "ON/OFF event did not remain indicated");
   end
   if (ntfy.is_waited_for(ID)) begin
      `vmm_error(log, "Notification reported as being waited on");
   end
   disable fork;

   blocked = 0;
   fork
   begin
      blocked = 1;
      ntfy.wait_for_off(ID);
      blocked = 0;
   end
   join_none
   #(5);
   if (!blocked) begin
      `vmm_error(log, "wait_for_off() did not block");
   end
   if (!ntfy.is_waited_for(ID)) begin
      `vmm_error(log, "Notification not reported as being waited on");
   end

   `vmm_note(log, "...resetting notification");
   if (!ntfy.is_on(ID)) begin
      `vmm_error(log, "Notification is not ON before reset");
   end
   ntfy.reset(ID);
   if (ntfy.is_on(ID)) begin
      `vmm_error(log, "Notification remained ON after reset");
   end
   #(5);
   if (blocked) 
      `vmm_error(log, "wait_for_off_t() remained blocked");
   if (ntfy.is_waited_for(ID)) 
      `vmm_error(log, "Notification reported as being waited on");
   disable fork;

   blocked = 0;
   fork
   begin
      blocked = 1;
      ntfy.wait_for(ID);
      blocked = 0;
   end
   join_none
   #(5);
   if (!blocked) 
      `vmm_error(log, "ON/OFF event did not block");
   if (!ntfy.is_waited_for(ID)) 
      `vmm_error(log, "Notification not reported as being waited on");
   disable fork;

   #(10);
   `vmm_note(log, "...Indicating waiting thread as terminated");
   ntfy.terminated(ID);
   if (ntfy.is_waited_for(ID)) begin
      `vmm_error(log, "Notification still reported as being waited on");
   end

   blocked = 0;
   fork
   begin
      blocked = 1;
      ntfy.wait_for_off(ID);
      blocked = 0;
   end
   join_none
   #(5);
   if (blocked) begin
      `vmm_error(log, "wait_for_off(ID) blocked on OFF event");
   end
   if (ntfy.is_waited_for(ID)) begin
      `vmm_error(log, "Notification reported as being waited on");
   end
   disable fork;

   #(100);
   `vmm_note(log, "Verifying indication to two threads...");
   
   blocked = 0;
   fork
   begin
      blocked++;
      ntfy.wait_for(ID);
      blocked--;
   end
   begin
      blocked++;
      ntfy.wait_for(ID);
      blocked--;
   end
   join_none

   #(10);
   if (blocked != 2) begin
      `vmm_error(log, $psprintf("%0d threads are blocked instead of 2",
                              blocked));
   end
   timestamp = $realtime;
   `vmm_trace(log, "...indicating ON/OFF event");
   ntfy.indicate(ID);

   #(5);
   if (blocked != 0) begin
      `vmm_error(log, $psprintf("%0d threads remain blocked", blocked));
   end
   // Check that no thread is waiting for the event is reported
   if (ntfy.is_waited_for(ID)) begin
      `vmm_error(log, "A thread is still reported as waiting for the notification");
   end
   then = ntfy.timestamp(ID);
   if (then != timestamp) begin
      `vmm_error(log, $psprintf("Notification reported at %0d instead of %0d",
                              then, timestamp));
   end
   disable fork;

   blocked = 0;
   fork
   begin
      blocked++;
      ntfy.wait_for_off(ID);
      blocked--;
   end
   begin
      blocked++;
      ntfy.wait_for_off(ID);
      blocked--;
   end
   join_none

   #(10);
   if (blocked != 2) begin
      `vmm_error(log, $psprintf("%0d threads are blocked instead of 2",
                              blocked));
   end
   timestamp = $realtime;
   `vmm_trace(log, "...resetting ON/OFF event");
   ntfy.reset(ID);

   #(5);
   if (blocked != 0) begin
      `vmm_error(log, $psprintf("%0d threads remain blocked", blocked));
   end
   // Check that no thread is waiting for the event is reported
   if (ntfy.is_waited_for(ID)) begin
      `vmm_error(log, "A thread is still reported as waiting for the notification");
   end
   disable fork;

   log.report();
end

endprogram

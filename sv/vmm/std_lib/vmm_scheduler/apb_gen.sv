/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class apb_gen extends vmm_xactor;
   apb_trans randomized_obj;
   apb_trans_channel out_chan;
   
   string name, instance;
   
   int  trans_cnt, stop_after_n_insts;
   static int DONE_WITH_3RW = 0; // creating own notifier....
   static int DONE = 1 ; // creating own notifier....
   

  function new(string name, string instance, integer stream_id = -1, apb_trans_channel out_chan = null, int stop_after_n_insts=0);
     super.new(name, instance, stream_id);
     this.name = name;
     this.instance = instance;
     this.stream_id = stream_id;
    randomized_obj = new();
    trans_cnt = 0;
     // Allocate an output channel if needed, save a reference to the channel
     if (out_chan == null) 
       out_chan = new("APB GEN INPUT CHANNEL", instance); 
     this.out_chan       = out_chan;
     this.stop_after_n_insts = stop_after_n_insts;
  
     // configure user notifier to one_shot
     super.notify.configure(this.DONE_WITH_3RW, vmm_notify:: ONE_SHOT);
     super.notify.configure(this.DONE, vmm_notify:: ONE_SHOT);
  
     // FYI  inherited notifiers from vmm_xactor
     // vmm_notify notify ;
     // enum { XACTOR_IDEL;XACTOR_BUSY;XACTOR_STARTED;XACTOR_STOPPED;XACTOR_RESET};
  
  endfunction;
  

// make first 3 reads, next 3 writes, rest are random

  task main();
     super.main();

     fork
	begin
	   while (trans_cnt < stop_after_n_insts) begin
	      apb_trans tr ;
	      if (trans_cnt <3)
		randomized_obj.randomize() with {dir == READ;};
	      else if (trans_cnt >2 && trans_cnt < 6)
		randomized_obj.randomize() with {dir == WRITE;};
	      else
		randomized_obj.randomize();
	      $cast(tr, randomized_obj.copy());
	      tr.stream_id = this.stream_id;	      
	      out_chan.put(tr);
	      if (trans_cnt == 5 ) 
		 this.notify.indicate(this.DONE_WITH_3RW);
	      trans_cnt++;
	      randomized_obj.data_id++;
                   end // while (trans_cnt < stop_after_n_insts)
	   this.notify.indicate(this.DONE);  // to notify that generator done
	end // fork begin
	
	begin
	   //      this.notify.wait_for(this.DONE_WITH_3RW);
	   //    $display ("From w/in Generator GEN0 FINISHED 3RW SEQUENCE ");
	end
    
        join_none
          
  endtask
  
    endclass



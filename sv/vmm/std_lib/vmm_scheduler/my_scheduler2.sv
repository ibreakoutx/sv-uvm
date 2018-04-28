/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

/* 

2. execute the whole sequence of transactions from a source before switching to the next. */


class my_scheduler extends vmm_scheduler; 
  static vmm_log log ;

  
int start_id = -1; 
int num_gen_obj[]; // to hold number of transactions the generator is to complete
int n_remain = 0; // hold number of transactions left to complete before switching input channel
randc bit [2:0]id;  // index to randomly point to valid input source

  function new(string name, string instance, vmm_channel destination, int instance_id = -1, int num_gen_obj[]);
  super.new(name, instance, destination, instance_id);
  this.num_gen_obj = num_gen_obj;
  log  = new("my_sched", "my_scheduler2");
  endfunction
   
virtual protected task schedule(output vmm_data     obj, 
                                input  vmm_channel  sources[$], 
                                input  int unsigned input_ids[$]); 
   vmm_channel src;
  
  if (start_id == -1) begin
    start_id = input_ids[id];
    n_remain = num_gen_obj[id];
    `vmm_debug(log, $psprintf("first start_id is %0d", start_id));
//    $display("first start_id is %0d and id is %0d, input_id[%0d] is %0d, n_remain is %0d", start_id,  id, id, input_ids[id], n_remain);
    
  end
     
   else if (n_remain > 0)  begin // keep id till all transactions done
     id = id;
//     if (n_remain == 1)
  //     $display(" id is %0d, input_id[%d] is %0d", id, id, input_ids[id]);
   end
  

   else if (n_remain == 0) begin
     
   // randomly get next id
       this.randomize() with {id >= 0  && id < input_ids.size();};
       n_remain =   num_gen_obj[input_ids[id]];
     $display("next id is %0d, input_id[%0d] is %0d, NUM REMAIN is %0d", id, id, input_ids[id], n_remain);
     
   end // else if


  src = sources[id];   // put object on out channel
//$display("source instance is %0s", src.log.get_instance()); 
  
  
  src.get(obj);

  
  
  if (n_remain > 0)
    n_remain--;
  else
    n_remain = 0;

//  $display("done, n_remain is %0d", n_remain);
endtask : schedule

endclass

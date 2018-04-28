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

int last_id = -1; 
int n_remain = 0;
  vmm_channel SOURCES[$];
  int num_gen_obj[];
  randc bit [2:0]id;


  function new(string name, string instance, vmm_channel destination, int instance_id = -1, int num_gen_obj[]);
//    function new(string name, string instance, vmm_channel destination, int instance_id = -1);
  super.new(name, instance, destination, instance_id);
  this.num_gen_obj = num_gen_obj;
  
  endfunction
   
virtual protected task schedule(output vmm_data     obj, 
                                input  vmm_channel  sources[$], 
                                input  int unsigned input_ids[$]); 
   vmm_channel src;


  
  if (last_id == -1) begin
    last_id = input_ids[id]; 
    n_remain = num_gen_obj[id];
  end
     
   else if (n_remain > 0)  begin// keep id till all transactions done
     id = id;
     last_id = id;
   end
  

   else if (n_remain == 0) begin 
   // randomly get next id
     this.randomize() with {id >= 0  && id < input_ids.size();};
     n_remain =   num_gen_obj[id];
   end // else if
  

   src = sources[id];  

//input channels only has one object when schedule called
//Wiill cycle through each id. Since overidding this method, scheduler_election not used
//here

  
  src.get(obj);
  
  if (n_remain > 0)
    n_remain--;
  else
    n_remain = 0;


endtask : schedule

endclass

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
1. execute a randomized number of transactions from a source before switching to 
 the a new source (source may be repeated)
*/

class my_scheduler extends vmm_scheduler; 

int start_id = -1; 
int num_gen_obj[]; // to hold number of transactions the generator is to complete
rand int  n_remain = 0; // hold number of transactions left to complete before switching input channel
randc bit [2:0]id;  // index to randomly point to valid input source


  function new(string name, string instance, vmm_channel destination, int instance_id = -1, int num_gen_obj[]);

  super.new(name, instance, destination, instance_id);
  this.num_gen_obj = num_gen_obj;
  
  endfunction
   
virtual protected task schedule(output vmm_data     obj, 
                                input  vmm_channel  sources[$], 
                                input  int unsigned input_ids[$]); 
   vmm_channel src;

  int max;
  
  
  if (start_id == -1) begin
    start_id = input_ids[id];
    max = num_gen_obj[id];
      this.randomize(id) with {id >=0 && id < input_ids.size();}; 
    `ifdef err
      this.randomize(n_remain, id) with {n_remain >=0 && n_remain <= num_gen_obj[id];};
    `else
   this.randomize(n_remain) with {n_remain >=0 && n_remain <= max;};
   `endif
  

    //n_remain = num_gen_obj[id];
  end
     
   else if (n_remain > 0) // keep id till all transactions done
     id = id % input_ids.size();

   else if (n_remain == 0) begin 
   // randomly get next id
     this.randomize(id) with {id >= 0  && id < input_ids.size();};
     max = num_gen_obj[id];
     this.randomize(n_remain) with {n_remain >=0 && n_remain <= max;};
   end // else if
  

   src = sources[id];  

  if(src == null)
    $display("Null %0d", id);

    src.get(obj);  // put object on out channel
  
  if (n_remain > 0)
    n_remain--;
  else
    n_remain = 0;


endtask : schedule

endclass

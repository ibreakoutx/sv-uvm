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

class uniq_rand_num_list;

   static vmm_log log = new ("uniq_rand_num_list", "class");   
   bit [9:0] list[$];

  integer min;       
  integer max;       
  integer length;    

  local randc bit [9:0] num; 
  local bit [9:0] temp_list[$]; 

  /*!
   * constraint to set the range of the unique number
   *
   * This constraint shall not be modified or turned off
   */
  constraint num_range_valid {
    num inside { [min:max] };
  }
  
  function new (integer length=0, integer min=0, integer max=511) ;
     if (length < 0)   length = 0;
     if (min < 0)    min = 0;
     if (max < 0 || max >= 511) max = 511;

    
    this.length = length;
    this.min = min;
    this.max = max;

     if (this.length == 0) return;

    repeat (this.length) begin
      if (!this.randomize()) begin
         `vmm_fatal (log, "cannot randomize randc");
      end
      list.push_back(this.num);
    end
  endfunction // new
   

   task display(string prefix="");
      $display ("%s\n", psdisplay_list (list, prefix));
   endtask // display
   

   function string psdisplay_list(bit [9:0] list[$], string prefix="");
    string str;
    str = prefix;
    foreach (list[i]) 
       $sformat (str, "%s %0d", str, list[i]);

      $sformat (str, "%s\n", str);
      psdisplay_list = str;
   endfunction // string
endclass // uniq_rand_num_list



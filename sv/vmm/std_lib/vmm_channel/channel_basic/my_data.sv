/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


class my_data extends vmm_data;

   static vmm_log log = new("my_data", "");
   
   bit [7:0] data;

 

   function new();
   super.new(this.log);
   this.randomize();
   endfunction : new



   virtual function string psdisplay(string prefix = "");
         psdisplay = $psprintf("%sData = 8'h%2h\n", prefix, this.data);
   endfunction : psdisplay


     function vmm_data copy(vmm_data to = null);
   my_data data;
   
   if (to == null) begin
     data = new;
   end
   else begin
     if (!$cast(data, to)) begin
       `vmm_fatal(log, "Attempting to copy to a non-my_data instance");
       return null;
     end // if
   end // else

   data.data = this.data;
   
   copy = data;
   endfunction : copy


function bit compare(vmm_data to,
                     output string   diff,
                                input int    kind = -1);
   my_data data;
   if (!$cast(data, to)) begin
      `vmm_fatal(log, "Attempting to compare to a non-my_data instance");
      return(-1);
   end // if
   compare = 1;

   if (this.data !== data.data) begin
      $sformat(diff, "Data 8'h%2h !== 8'h%2h", this.data, data.data);
      compare = 0;
   end // if
endfunction : compare


function int unsigned byte_size(int kind = -1);
   byte_size = 1;
endfunction : byte_size


function int unsigned byte_pack(ref logic [7:0] bytes[],
                                input int unsigned offset = 0,
                                input int   kind = -1);
   bytes = new [1];
   bytes[0] = this.data;
   
   byte_pack = 1;
endfunction : byte_pack


function int unsigned byte_unpack(const ref logic [7:0]    bytes[],
                                  input int unsigned offset = 0,
                                  input int      len    = -1,
                                  input int      kind = -1);
   this.data = bytes[0];
   byte_unpack = 1;
endfunction : byte_unpack

  endclass // my_data
  `vmm_channel(my_data)

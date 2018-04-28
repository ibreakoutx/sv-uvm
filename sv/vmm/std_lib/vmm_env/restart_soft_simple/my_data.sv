/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class my_data extends vmm_data ;

   static vmm_log log = new("my_data", "");
   
   rand bit [7:0] data;

   extern function new();

   extern virtual function string psdisplay(string prefix = "");

endclass


function my_data::new() ;
   super.new(this.log);
endfunction



function string my_data::psdisplay(string prefix ) ;
   $write(psdisplay, "%sData = 8'h%2h\n", prefix, this.data);
endfunction

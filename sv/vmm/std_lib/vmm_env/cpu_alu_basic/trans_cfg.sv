/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class trans_cfg;
   rand int num_trans;
   string name;

   constraint cst_default {
     num_trans == 5;
   }
 
   function new(string name);
     this.name = name;
   endfunction
   
endclass


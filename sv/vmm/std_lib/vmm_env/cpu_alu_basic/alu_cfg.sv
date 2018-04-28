/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class alu_cfg;
   rand bit monitor_en;
   rand bit cov_en;
   rand bit sb_en;
   rand int num_trans;

   constraint cst_default {
     monitor_en == 1;
     cov_en == 1;
     sb_en  == 1;
     num_trans inside {[5:500]};
   }
    
   constraint cst_cfg {
      (monitor_en == 0) -> (cov_en == 0 && sb_en == 0);
   }

   //constraint cst_alu_cfg_user;
 
   function void display();
     $display("MON_ENABLE=%b, COV_ENABLE=%b, SB_ENABLE=%b, No Of Transactions = %0d", monitor_en, cov_en, sb_en, num_trans);
   endfunction
  
endclass


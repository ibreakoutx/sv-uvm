/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


class alu_mon2cov_connector extends alu_mon_callbacks;
   alu_cov cov;

   function new(alu_cov cov);
     this.cov = cov;
   endfunction

   virtual task post_mon(alu_mon   mon,
                         alu_data tr,
                         ref bit          drop);
      cov.tr = tr; 
      -> cov.cov_event;
   endtask

endclass

/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class my_scheduler_election extends vmm_scheduler_election;
  constraint default_round_robin {
                                  source_idx dist {
                                                   0: = 10, 1: = 10, 3: = 10} ;
                                  
                                  source_idx >= 0 && source_idx <8;}
                                                
endclass

/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

/***************************************************************************
 *
 * File:        $RCSfile: apb_trans.sv,v $
 * Revision:    $Revision: 1.5 $  
 * Date:        $Date: 2003/07/02 15:47:08 $
 *
 *******************************************************************************
 *
 * APB Transaction Structure
 *
 *******************************************************************************
 */

class apb_trans;
  rand apb_addr_t addr;
  rand apb_data_t data;
  rand trans_e                 transaction;

  task display(string prefix);
        case (this.transaction)
          READ:
            $display($time, ": %s Read  Addr=0x%02X Data=0x%02X",
                   prefix, this.addr, this.data);
          WRITE:
            $display($time, ": %s Write Addr=0x%02X Data=0x%02X",
                   prefix, this.addr, this.data);
          default:
            $display($time, ": %s Idle  --------------------------", prefix);
        endcase
  endtask: display
    
  function apb_trans copy();
    apb_trans to   = new();
    to.addr        = this.addr;
    to.data        = this.data;
    to.transaction = this.transaction;
    copy = to;
  endfunction: copy
  
endclass

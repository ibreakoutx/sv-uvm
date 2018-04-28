/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

//-----------------------------------------------------------------------------
//
// SYNOPSYS CONFIDENTIAL - This is an unpublished, proprietary work of
// Synopsys, Inc., and is fully protected under copyright and trade secret
// laws. You may not view, use, disclose, copy, or distribute this file or
// any information contained herein except pursuant to a valid written
// license from Synopsys.
//
//
// Description : AMBA Peripheral Bus Configuration class
//
//               This is a configuration class for APB VIP
//
//-----------------------------------------------------------------------------

class apb_cfg;

  // How many transactions to generate before test ends?
  rand int trans_cnt;

  constraint basic {
    trans_cnt > 5;
    trans_cnt < 10;
  }
    
endclass: apb_cfg


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
//-----------------------------------------------------------------------------
//
// Filename    : $Id: apb_cfg.sv,v 1.4 2005/09/19 18:10:30 alexw Exp $
//
// Created by  : Synopsys Inc. 09/01/2004
//               $Author: alexw $
//               Author : Alex Wakefield, Angshu Saha
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


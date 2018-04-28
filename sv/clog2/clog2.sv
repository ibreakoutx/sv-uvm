/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

/////////////////////////////////////////////////////////////////////////////////
//
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from Synopsys Inc. In the event of publication,
// the following notice is applicable:
//
// (C) COPYRIGHT 2008 SYNOPSYS INC.  ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------
// Filename    : clog2.sv
//
// Author      : Kiran Maiya, Synopsys Inc. 10/13/08
//             
// Description : This file defines all the interfaces required for this project.
//
//
/////////////////////////////////////////////////////////////////////////////////

program main ;

   initial
   begin
    int arr[5] = '{1, 5, 13, 25, 64433} ;

    foreach(arr[i])
    $display("$clog2[%0d] = %0d\n", arr[i], $clog2(arr[i])) ;
   end
endprogram


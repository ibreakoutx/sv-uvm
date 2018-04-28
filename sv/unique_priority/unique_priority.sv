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
// Filename    : unique_priority.sv
//
// Author      : Kiran Maiya, Synopsys Inc. 10/13/08
//             
// Description : This file defines all the interfaces required for this project.
//
//
/////////////////////////////////////////////////////////////////////////////////


program main ;

  bit [3:0] a, b ;

initial 
  begin

a = 2 ;
  priority if(a==2 )
    $display("a = 0 ") ;
  else if(b == 1)
    $display("b == 1") ;
  a = 1 ;

  unique case(a) 
   0: $display("a = 0") ;
  endcase
  end
endprogram

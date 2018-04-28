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
// Filename    : array_program_port.sv
//
/////////////////////////////////////////////////////////////////////////////////

module top ;

int arr[5] = '{0, 1, 2, 3, 4} ;

test tb(arr) ;

endmodule: top

program test(input int arr[5]) ;

initial
  begin
   foreach(arr[i])
     $display("arr[%0d] = %0d", i, arr[i]) ;
  end
endprogram: test

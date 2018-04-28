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
// Filename    : str_index_assoc_array.sv
//
// Author      : Kiran Maiya, Synopsys Inc. 10/13/08
//             
// Description : This file defines all the interfaces required for this project.
//
//
/////////////////////////////////////////////////////////////////////////////////

program main ;

class A ;
  rand int str_arr[string] ;

  constraint con
  {
   foreach(str_arr[i])
   { 
    str_arr[i] < 10 ;
    str_arr[i] >  0 ;
   }
  }

  task display() ;
    foreach(str_arr[i])
    begin
      $display("str_arr[%s] = %0d\n", i, str_arr[i]) ;
   end
  endtask: display

  function new() ;
    str_arr["HellO"]    = 0 ;
    str_arr["Dear"]     = 1 ;
    str_arr["Customer"] = 2 ;

  endfunction: new

endclass: A

   initial
   begin
     A a = new ;

     a.display() ;
     a.randomize() ;
     a.display() ;
   end
endprogram


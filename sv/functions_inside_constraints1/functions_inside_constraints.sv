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
// Filename    : functions_inside_constraints.sv
//
/////////////////////////////////////////////////////////////////////////////////

function int f1(int i_in);
  f1 = i_in;
endfunction

function int toint (reg [31:0]  i); 
  $display(i);
  $display("KM: i = %s\n", i) ;
  toint = i; 
endfunction

class c1_c;
  rand int arr[*];
  int int_str1 ;
  string str1 ;
  
  constraint con1 
    {
     foreach (arr[idx]) 
     { 
       f1(idx) == 11 ->  arr[idx] == 0 ;
       arr[idx] < 10 ;
       arr[idx] >= 0 ;
     }
     
    } // con1
                                   
  function void pre_randomize();
  foreach (arr[idx]) 
    $display("pre: %0d -- %0d", idx,arr[idx]);
  str1 = "def" ;
  
  int_str1 = str1 ;
  
  
  endfunction
  function void post_randomize();
  foreach (arr[idx]) $display(idx,,arr[idx]); 
  endfunction
endclass

program p1;
  c1_c c1 = new;
  initial 
    begin
      c1.arr[11] = 11;
      c1.arr[22] = 22;
      c1.arr["abc"] = 33;
      c1.arr["def"] = 44;
      c1.randomize();
      $display("def ascii equivalent is %d",toint(("def"))); 
    end
endprogram

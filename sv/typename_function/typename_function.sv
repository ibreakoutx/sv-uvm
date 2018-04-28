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
// Filename    : typename_function.sv
//
//////////////////////////////////////////////////////////////////////////////////

program main ;
  typedef bit [3:0] Vec4 ;

  class A ;
  Vec4 v4 ;
  endclass: A  
  struct 
  {
   Vec4 v4 ;
   } S ;
  
  typedef struct 
  {
   Vec4 v4 ;
   } tS ;
  

    initial
      begin
        Vec4 v4 ;
        A a = new ;
        tS ts ;
 
        
        $display("v4 is of type %s", $typename(v4)) ; 
        $display("a is of type %s", $typename(a)) ;
        $display("s is of type %s", $typename(S)) ;
        $display("tS is of type %s", $typename(tS)) ;

        $display("") ;
      end
endprogram: main 

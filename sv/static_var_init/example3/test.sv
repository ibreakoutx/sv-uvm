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
// Filename    : test.sv
//
/////////////////////////////////////////////////////////////////////////////////

class c1_c#(int VAL=10);
	static int count=0;
	static function int f1();
		$display("c1_c::f1 called,VAL is %0d",VAL);
		return count++;
	endfunction
endclass

class c2_c#(int VAL=10) extends c1_c#(VAL);
	static int a = f1();
endclass
program p1;
	initial begin;
		$display("c2_c::a is: %0d",c2_c#(200)::a);
	end
endprogram

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

program p1;
	import OpenVera::*;
	c0_c c0[10];
	int aa[c0_c];

	initial begin
		foreach(c0[i]) begin
			c0[i]=new;
			c0[i].name=$psprintf("c0[%0d]",i);
			aa[c0[i]] = i*2;
		end
		foreach(aa[index_c]) begin
			c0_c index;
			index = index_c;
			$display("aa[%s]=%0d",index.name,aa[index]);
		end
	end

endprogram

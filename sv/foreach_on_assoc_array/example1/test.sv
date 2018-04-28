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

class c1_c;
	string name;	
endclass

program p1;
	int aa[c1_c];
	c1_c c1[3];
	initial begin
		foreach(c1[i]) begin
			c1[i]=new;
			c1[i].name=$psprintf("c1[%0d]",i);
			aa[c1[i]]=i*2;
		end
		
		foreach(aa[index_c]) begin
			c1_c index;
			index = index_c;
			$display("aa[%s]=%0d",index.name,aa[index_c]);
		end
	end
	
endprogram

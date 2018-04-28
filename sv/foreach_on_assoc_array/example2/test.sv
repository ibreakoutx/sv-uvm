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
	c1_c c1[10];
	initial begin
		foreach(c1[i]) begin
			c1[i]=new;
			c1[i].name=$psprintf("c1[%0d]",i);
			aa[c1[i]]=i*2;
		end
		
		//exists	
		if(aa.exists(c1[0])) begin
			$display("exists correct!");
			$display("aa[%s]=%0d",c1[0].name,aa[c1[0]]);
		end	
		aa.delete(c1[0]);
		if(!aa.exists(c1[0])) begin
			$display("delete correct!");
		end

		//first	
		begin
			c1_c c0;
			aa.first(c0);
			$display("first:, name is %s ",c0.name);
			aa.last(c0);
			$display("last, name is ",c0.name);
		end

		//next
		begin
			c1_c c0;
			$display("next:...");
			if(aa.first(c0)) 
				do
					$display("\t",c0.name);
				while(aa.next(c0));
		end
		
		//prev
		begin
			c1_c c0;
			$display("prev:...");
			if(aa.last(c0)) 
				do
					$display("\t",c0.name);
				while(aa.prev(c0));
		end
	end
	
endprogram

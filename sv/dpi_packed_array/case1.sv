/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

/* canonical open array*/

program p1;
	import "DPI" function void mydisplay(input bit[4:2] a[]);
	bit[4:2] a[8];

	initial begin
		for(int i=0;i<8;i++) a[i]= 15+i;
		for(int i=0;i<8;i++) $display("SV: a[%0d]",i,a[i]);
		mydisplay(a);
		
	end


endprogram

/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

/*longint*/

program p1;
	longint i1;
	
	import "DPI" function void mydisplay(inout longint i1);
	initial begin
		i1=64'h1234_5678_9abc_def0;
		$display("SV: i1 is %0h",i1);
		mydisplay(i1);
		$display("SV(after DPI call): i1 is %0h",i1);
	end

endprogram


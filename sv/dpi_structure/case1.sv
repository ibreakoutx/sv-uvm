/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

program p1;
	typedef struct {
		int a;
		int b;
	} mystruct;

	import "DPI" function void mydisplay(inout mystruct s1);
	mystruct s1;
	initial begin
		s1.a =10;
		s1.b =20;
		$display("SV: s1.a=%0d,s1.b=%0d",s1.a,s1.b);

		mydisplay(s1);
		$display("SV after DPI call: s1.a=%0d,s1.b=%0d",s1.a,s1.b);
	end 
	
endprogram

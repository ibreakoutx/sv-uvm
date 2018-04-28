/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/




program waitOrder;
event a, b, c, d, e;

initial begin
	fork
		wait_order(d,a,d,b)  // checks for the exact order of event triggers d -> a -> d -> b
			$display($time,," wait_order_1 Passed"); 
		
		wait_order(d, a, b, a, e)  // similarly checks for order of event triggers d -> a -> b -> a -> e 
			$display($time,," wait_order_2 Passed"); 
	join
end

initial begin
	#1 ->d;
	#1 ->c;
	->> #10 e;   // Non Blocking trigger
	#1 ->a; 
	#1 ->d;
	#1 ->b;
	#1 ->a;
	#1 ->b;
end
endprogram

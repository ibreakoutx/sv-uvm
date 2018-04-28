/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



program test;
int sq[$:3]; // can hold 3+1 (4) elements 
initial begin
	repeat (4) // filling queue with required elements
	  sq.push_front(2);
	$display("Initial queue = %p", sq);
	sq.push_back(20); // 20 not added at back since queue is full
	$display("After pushing element at back of queue = %p", sq);
	sq.push_front(10); // 10 added at front and 2 at back of queue is removed
	$display("After pushing element at front of queue = %p", sq);
end
endprogram


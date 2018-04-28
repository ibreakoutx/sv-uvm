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
   int a = 10; 
   class c1_c; 
      function int f(); 
			//delayed symbol resolution
			$display("c1_c:: a is %d",a);
      endfunction 
      int a; 
   endclass 

	initial begin
		c1_c c1=new;
		c1.a = 100;
		c1.f();
	end
endprogram


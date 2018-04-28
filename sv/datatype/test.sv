/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



package pkg1;
	//static const support
	static const int sc1=10;
    const static int sc2=11;

	class c0_c;
	 	rand int a;
	endclass 

	class c1_c extends c0_c;
		//instance constant
		const int id;
	 	rand int c;
		function new(int id);
			this.id=id;
			$display("instance const: id is %d",id);
		endfunction
	endclass 

	//nested parameterized class
	class c3_c#(type c3_T=c0_c);
	   class c31_c#(type T=c3_T);
			T obj1;
	   endclass
	endclass
endpackage

program test();
	import pkg1::*;
	//real in variable sized array
	real rda[] = '{10.0,11.1};

 	c0_c c0;
 	c1_c c1_1,c1_2;
	c3_c #(c1_c) c3=new;
	int i_null;
 	initial begin
 		c1_1 = new(1);
 		c1_2 = new(2);
 		c0 = c1_1;
 		c1_2 = c1_c'(c0);//static cast for class
		
		//assign null to int variable 
		i_null = null;
 	end
endprogram : test


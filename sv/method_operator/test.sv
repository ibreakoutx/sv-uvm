/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



interface itf;
	int data;
  	modport mp(inout data);

	always @(data) begin
		$display($stime,,"%m data is %d",data);
	end
endinterface
package pkg1;
	typedef enum bit [1:0] {
	      zero = 2'b00, one = 2'b01, two = 2'b10, three = 2'b11
	    } enum_t;


	//pure virutal methods
	virtual class c0_c;
        pure virtual function void f1();
        pure virtual task t();
	endclass

	class c1_c extends c0_c;
        function void f1();
			$display("c1_c::f1");
        endfunction
		task t();
			$display("c1_c::t");
		endtask
	endclass
	class c2_c;
	    function c1_c f2();
			$display("c2_c::f2: return c1_c object");
			f2=new();
		endfunction
	endclass

	function int count(string name,int in1=10);
		int j;
		$display(name);
		return (j=in1+10); //assignment in return statement	
   endfunction // bit
   function string name();
      name="0";
   endfunction
endpackage
program p1;
	import pkg1::*;
	integer a, b, c;
   	int ra;


	string s = "B";
	enum_t t1;

	virtual itf itf1;

	c1_c c1_1=new();	
	
	c2_c c2;
  	initial begin : initial_1
    	$display("s[0] is int value of %0d",s[0]);
		//string str.getc(index) and str[index] consistency 
    	if (s.getc(0) == 66) 
			$display("match");
    	if (s[0] == 66) 
			$display("match");  

		//enum type in conditional operator
		t1 = (s[0]==42) ? (enum_t'(2'b01)) : two;

		//void casting of system task
		void'($value$plusargs("s1=%s", s));
		$display("s1 is %s",s);	

		//access modport through virtual interface
		#1;
		itf1 = top.itf1;
		itf1.mp.data = 10;

		//Call a method through an object returned from a class method
		c2=new;
		c2.f2().f1();

		//assignment in expression
		a = (b = (c = 5 ));
    	if( (ra=count("Hello",.in1(0))) == 10)  //named arguments 
			$display("a",,a);  
		if((s=name()) == "0") 
			$display("b",,b);

		s = $psstack();
		$display("stack trace:",,s);
  	end: initial_1

	//$exit()
	initial begin: initial_2
		fork
			begin
			#1000;
			$display("killed by $exit(), will not display");
			end
		join_none
		#10;
		$display($stime,,"initial_2 done");
		$exit();
	end: initial_2
endprogram

module top;
	itf itf1();
	p1 p1_inst();
endmodule

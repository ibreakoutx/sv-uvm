/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



`define NUM 7

interface itf();
	reg[31:0] sig[3:0];
	//event array
	event sliced[0:`NUM];
	event de[];
endinterface

package mypkg;
    typedef enum int {
                AA,
                BB,
                CC
    } enum_t;

	typedef struct {
        int x;
    } st_t;

	class c1_c;
                rand int a;
                rand int b;
                rand int p[];
        		st_t st[]=new[2];
	endclass
endpackage: mypkg

program p1;
    import mypkg::*;
	//replication of dynamic array
	bit ba[] = '{{8{1'b1}}}; //an array with one element
   	bit bb[]='{8{1'b1}};//an array with 8 elements
	bit bc[];
	byte bq[$];
    c1_c c1=new;
	//enum type insde assco array key
    int myaa [enum_t];
	//initializing arrays using other arrays
	string d[1:5] = '{ "a", "b", "c", "d", "e" };
	string p[] =  { d[1:3], "hello", d[4:5] };
	//Bit vector initialization using default
	bit [7:0] b = '{default:'0}; //will result in 8'b0000_0000

	//mailbox
	mailbox mb=new;
	enum_t t1;
	virtual itf itf1;
    initial begin
    	$display(ba.size(),bb.size());
		//comparison of dynamic arrays
      	if (ba == bb) $display ("foo") ;
		//conditional operator with aggregate data types
		bc = ba[0] ? ba : bb;	
		//wait on unpacked fixed array
		itf1 = top.itf1;
		@(itf1.sig) $display($stime,,"wait on unpacked fixed array");

		mb.put(1);
		//VCS has runtime check for type mismatch
		//Enable this line to show the runtime error// mb.get(t1);

		//stream operator on dynamic array
        c1.randomize() with {p.size==3;};
        //NYI bq = {<<byte{c1.a,c1.b}};
        //NYI bq = {c1.p,bq};

		//Wait on struct elements from a dynamic struct array
		fork 
			begin
				#100;
				c1.st[1].x=2008;
			end
		join_none
		#2 @(c1.st[1].x) $display($stime,,"wait on struct element");
	
    end
endprogram

module top;
	itf itf1();
	p1 p1_inst();

	initial begin
		#10;
		itf1.sig[0]=32'h1234_5678;
	end
endmodule

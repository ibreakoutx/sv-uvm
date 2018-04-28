/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



 // example of assignments  

program doc_examples;


logic logque [$];
	//This is a queue of elements with the logic data type.


int intque [$] = {1,2,3};
	// This is a queue of elements with the int data type. 
	// These elements are initialized 1, 2, and 3.

string strque [$] = {"first","second","third","fourth"};
	// This is a queue of elements with the string data type. 
	// These elements are initialized "first", "second", "third", 
	// and "fourth".


  string s1, s2, s3, s4;


	initial begin

		// assignment of array members to data
	s1=strque[0];
	s2=strque[1];
	s3=strque[2];
	s4=strque[3];

	$display("s1=%s s2=%s s3=%s s4=%s",s1,s2,s3,s4);


		// assignment of data to array meembers
	intque[0]=4;
	intque[1]=5;
	intque[2]=6;
	$display("intque[0]=%0d intque[1]=%0d intque[2]=%0d", 
		intque[0],intque[1],intque[2]);


end

endprogram

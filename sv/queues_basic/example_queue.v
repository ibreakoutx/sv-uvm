/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


// this is an example to demonstrate the use of Queues.
//  A queue is created in the program block, it gets passed to
// methods and manipulated. 
 

program tb_top;


	// tasks
task double_down(ref reg [31:0] array_data[$]) ;

		// argument takes in a queue by reference,
		// modifies it and returns it

		int i, orig_size;	

			// double the size of the array

		orig_size = array_data.size();

		for ( i = 0 ; i < orig_size; i ++ )
			array_data.push_back(i);


endtask



  // program global vars

   reg [31:0] my_array[$] =  { 1,2,3,4,6,7} ;
   int i;

initial begin

			// pass the array into a method
	double_down(my_array) ;	 

			$display("done");
			// show the results of the transformation
	   for ( i = 0 ; i < my_array.size(); i ++ )
		$display ("%d: %d \n" , i, my_array[i]);




end
endprogram


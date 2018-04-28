/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


// this is an example to demonstrate the use of Dynamic arrays.
// An array is created in the program block, and a task call
// performs a transformation 


program tb_top;


	// tasks
task xfer_size_add_one(ref reg [31:0] array_data[], input int new_size) ;

		// argument takes in an array by reference,
		// modifies the size and returns the new array
		// with the old handle. 

		int i;		// this var is used, not the global var

			// add one to each member
		for ( i = 0 ; i < array_data.size(); i ++ )
			 array_data[i]++; 

			// copy the array onto itself, but with a new size
		array_data = new[new_size] (array_data);

endtask



  // program global vars

   reg [31:0] my_array[];
   reg [31:0] copied_array[];
   reg [31:0] another_copied_array[];
   int i;


initial begin
   // size the data
   my_array = new [6]; 
   
   
   
   // initialize values
   for ( i = 0 ; i < my_array.size(); i ++ ) 
      my_array[i] = i;
   
   
   // copy array after a new statement allocates memory for the new array
   // that is exactly the size of my_array.
   copied_array = new[my_array.size()] (my_array);
   
   
   // similar results can be achieved by doing a
   // a direct assign to an empty dynamic array that allocates memory and results in a copy of the array
   another_copied_array = my_array;
   
   
   // pass the array into a method and modify it
   xfer_size_add_one(my_array, 6) ;	 
   
   
   // show the results of the transformation on the original array.
   $display ("\n\nMY ARRAY:\n---------------------\n");
   for ( i = 0 ; i < my_array.size(); i ++ )
      $display ("%d: %d" , i, my_array[i]);
   
   
   // show the results of the transformation, where the previously copied array does not update
   $display ("\n\nCOPIED ARRAY:\n---------------------\n");
   for ( i = 0 ; i < copied_array.size(); i ++ )
      $display ("%d: %d" , i, copied_array[i]);
   

   // show the results of the transformation, again where the previously copied array does not update
   $display ("\n\nANOTHER COPIED ARRAY:\n---------------------\n");
   for ( i = 0 ; i < another_copied_array.size(); i ++ )
      $display ("%d: %d" , i, another_copied_array[i]);
   
   $display ("\n\n---------------------------------------\n\n");
   
   
end
endprogram


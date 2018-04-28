/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


// this is an example of using an associative array
// associative arrayys are great for not having to specifiy size
// of arrays up front, also to model hashes or memories

parameter BASE_ADDR = 32'h3000;

program sram_modeling ;



  bit [31:0] sram_model[*];
  int assoc[string];


  bit [31:0] i;

 initial begin

			// here we can fill any addresses,
			// does not have to be continious
			// and the size of the array is only
			// the number of elements used 
    sram_model[BASE_ADDR + 0 ] = 32'hdead_beef;
    sram_model[BASE_ADDR + 3 ] = 32'hdead_beef;
    sram_model[BASE_ADDR + 5 ] = 32'hdead_beef;
    sram_model[BASE_ADDR + 7 ] = 32'hdead_beef;


		// there are many neat built in operators for arrays

		// find the number of elemetns in the array
		// note this is a function call
	$display("size of array: %d\n",	sram_model.num());


		// find first element
		// note these are tasks, with a ref used for the argument
		// ie i will get updated

	sram_model.first(i);
	$display ("the first index of the array is %d", i);


		// find the next element, which is now BASE_ADDR +3:
	sram_model.next(i);
	$display ("the next index used of the array is %d", i);


		// find the last  element, which is  BASE_ADDR +7:
	sram_model.last(i);
	$display ("the last index used of the array is %d", i);


		// example of using string arrays
     assoc["zero"] = 0;
     assoc["one"] = 1;
     assoc["seventeen"] = 17;
     $display(assoc["one"]);

end

endprogram


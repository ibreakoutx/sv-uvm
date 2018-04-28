/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



// this small example shows the use of the built in queue methods

program examples ;
    int intque[$] = { 1, 2,  3 };
     string strque [$] = {"first","second","third","forth"};


 initial begin


		// example of the use of size
	for (int i = 0 ; i < intque.size(); i++ )
		$display(intque[i]);



		// example of the use of insert

	strque.insert(1,"next");		// insert "next" into element 1, former element 1 is now element 2.
	strque.insert(2,"somewhere");

	for (int i = 0; i < strque.size; i++) 
		$write(strque[i]," ");

		$display(" ");




		// example of the use of delete
	strque.delete(1);		// delete the element
	strque.delete(3);

	for (int i = 0; i < strque.size; i++) 
		$write(strque[i]," ");

		$display(" ");




		// example of the use of pop_front
		// deletes the front of the queue
	strque.pop_front();

	for (int i = 0; i < strque.size; i++) 
		$write(strque[i]," ");

		$display(" ");




		// example of the use of pop_back
		// deletes the back of the queue
	strque.pop_back();

	for (int i = 0; i < strque.size; i++) 
		$write(strque[i]," ");

		$display(" ");



		// example of the use of push_front and push_back
		// grows the queue
	strque.push_front("in-front");
	strque.push_back("in-back");

	for (int i = 0; i < strque.size; i++) 
		$write(strque[i]," ");

		$display(" ");


  end

endprogram

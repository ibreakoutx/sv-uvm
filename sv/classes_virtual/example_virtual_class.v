/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

// ok, the third cool thing about classes is the use of virtual
// you can have virtual classes and/or virtual methods

// a class that begins with the keyword virtual  (a virtual class)
// cannot have objects from it.  But it can be used as a base
// class and all the methods and varibles are going to be the commonality
// from all derived classes/objects.

// An example could be a fabric router, that has many kinds
// of data formats.  The base class contains all the common
// data but that datatype would never be send into the router
// by itself. All derived classes must have that common data,


// a class that contains virtual methods (virtual task/ virtual function)
// allows existing code to use the base class handles, but in fact
// the derived objects methods are being used.  This permits
// a great deal of reuse, since the original code doesn't need
// be modified when some functionaly gets changed


// an example is the VMM methodlogy, where the Bus Functional
//Models (xactors) act on data, but one can substitute a changed
//data and the BFM does not need to be modified to take this
//new data.


// all of this is called polymorphism!


// ok, so now you are expecting to see some code!

program tb_top;

		// here is a shape class, defining that there will be 
		// some shapes to draw, and they all must have
		// a shape method to be used by the "BFM"

virtual class Shapes;
	
		// every shape must have a total size, and a start coordinate
	int total_size;
	int start_x, start_y;
	bit[7:0] color;

		// every shape must implement draw and color actions
	virtual task draw();
	endtask

		// by defining code here, it becomes optional for
		// derifed methods to define it there.
		// because it is virtual, the derived object method
		// will override this call, unless super is used by
		// the derived object to call this one

	virtual task setcolor (bit [7:0] color); 
			this.color = color;
	endtask




endclass



class Circle extends Shapes;

	bit [30:0] circle_d_data;

	function new(int size = 4);
		total_size = size * 3;
	endfunction

		// here is how I would draw a circle
		// I keep it virtual so that one somone
		// can create a 3D ciricle and build upon
		// this example
	virtual task draw();
		// do the actual draw here
		$display("drawing a circle...\n");
	endtask


endclass





class Square extends Shapes;

	int drawn = 0;

	function new(int sizex = 1, int sizey = 1);
		total_size = sizex * sizey;
	endfunction

	virtual task draw();
		// do the actual draw here
		$display("drawing a square...\n");
		drawn = 1; 
	endtask

	virtual task setcolor(bit [7:0] color);
		// here I need to do the base class stuff, but then
		// the work of updating the color of the square
		super.setcolor(color);
		if (drawn == 1) begin
			$display("updating drawing...\n");
		end		
	endtask			


endclass

  Shapes s[2];
  Circle c1;
  Square s1;


initial begin
		// initialize the objects, let base class handles 
		// point to them also

	c1 = new();		// create a circle object
	s[0] = c1;		// s[0] also points to that circle

	s1 = new();		// create a square object
	s[1] = s1;		// watch out for sharp edges


	
	//s0.draw(); is the same as calling c1.draw(), but
	// the neat thing here is that a BFM only needs the 
	// base class handle, and doesn't need to be modifed
	// if the functionality or data features change!!


	s[0].draw();
	s[0].setcolor(22);

	// is the same as 
	c1.draw();
	c1.setcolor(22);

	// but the base methods didn't need to be changed


end 

endprogram

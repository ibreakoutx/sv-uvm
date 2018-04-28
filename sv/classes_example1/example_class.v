/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



// this is an example of how to use the OO Classes


program example_classes();


	// here we define a class.  A class is like a blueprint
	// to a home, it spells out the framework and design
	// of the house 

class House_Blueprint;

		// first we declare varibles that define general properities 
		// of all houses even though a specific house will 
		// have unique data

	int number_of_rooms;
	bit family_room_lightswitch;
	static string street_name;  // all homes here share the same street name


		// on building a house, intiailze defaults
		// and build the house based on argument liss

	function new(int rooms, string street = "");
		if (street != "")
			street_name = street;
		number_of_rooms = rooms;
		family_room_lightswitch = 0;
	endfunction


		// we can flip the lights of a specific house with
		// a method call 
	task hit_the_switch() ;
		family_room_lightswitch = !family_room_lightswitch;
	endtask


		// we can return values in function calls 
	function bit lights() ;
		lights = family_room_lightswitch;
	endfunction


endclass




House_Blueprint red, blue, yellow, green;
		// here we declare handles, they don't point to anything yet

int result;

initial begin

		// red now points to a home with 4 rooms
	red = new(4, "middlefield");	

		// green now points to a home with 6 rooms
		// note the second arg is missing!
		// Don't worry:  Its a default arguement, so its optional
	green = new(6); 
		

		 // here we turn on the light switch in the red house
		// by accessing the method
	red.hit_the_switch();  


		// we can do the same thing by directly accessing the varible,
		// as long as it is a public varible
		// note that while this is less coding, the purpose of 
		// methods is to check the input and do the calculations 
		// to prevent inroduction of incorrect data
		// (ie -1 rooms wouldn't make sense )
	red.family_room_lightswitch = 1; 


		// here we can get the results of the lights being on or off
		// in the room.   Note the red house and the green house
		// are based on the same blueprint, but have different
		// values 
	result = red.lights();
	result = green.lights();

	


end

endprogram


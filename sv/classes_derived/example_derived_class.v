/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



// ok, this example builds on example1. 
// here we show how to make derived classes.
// derived classes can have 2 purposes.
// one is to extend the functionality of the base class to do more stuff
// the other is to restrict, limit or refine the functionality of the base class.
// there is a third purpose, see example3. 


// in this example, we will extend the base class house blueprint
// with additional functionality, which would naturally be to
// add second floor

// we will also refine the example, to expand the lightswitch
// functionality so that there can be more than one switch in
// the living room



program example_classes();

	// here is the same house blueprint from example1

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


	// now we are going to create a subclass which uses all
 	// the existing functionality, but adds a second floor


class Monster_House_Blueprint extends House_Blueprint;

	// add in a second floor number of rooms
	int second_story_rooms;
	int first_story_rooms;

		//change the lightswitch functionality
	bit [1:0]  family_room_lightswitch;

	function new(int rooms, string street = "");

			// super is used to access the base class
			// methods and data.  If new has an arg list,
			// you MUST call super.new for it. 
   	     super.new(rooms, street); 

		// here we can access data of both the derived and base class
	     second_story_rooms =     number_of_rooms /2 ;
	     first_story_rooms =    number_of_rooms - second_story_rooms ;
	

		// since I have redefined family_room_lightswitch, 
		// I need to take data out of the super class 
		// and put it here, since the super.new used it.

		// note the use of this and super

		this.family_room_lightswitch = super.family_room_lightswitch;

					
	endfunction

		// since I changed the family_room_lightswitch, the methods
		// have to be changed too, to acces the derived data 

	task hit_the_switch() ;
		case (family_room_lightswitch)
		2'b11:   family_room_lightswitch = 2'b00;
		2'b00:   family_room_lightswitch = 2'b11;
		default: family_room_lightswitch = 2'b00;
		endcase

	endtask

		// we can return values in function calls 
	function bit[1:0] lights() ;
		lights = family_room_lightswitch;
	endfunction




endclass



Monster_House_Blueprint red, blue, yellow, green;
		// here we declare handles pointing to the Monster House.
		// now we can immediately take advantage of the new
		//funciontality



int result;

initial begin

		// red now points to a home with 4 rooms, 
		//2 on floor 0, and 2 on floor 1
	red = new(4, "middlefield");	

		// green now points to a home with 6 rooms
		// 3 on floor 0 and 3 on floor 1 
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


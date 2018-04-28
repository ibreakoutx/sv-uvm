/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



//  this example builds on example2. 
// here we show how to make derived classes, and we are going to link them


// in this example, we will extend the base class house blueprint
// with additional functionality, which would naturally be to
// add second floor, and to link houses on the street


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
        int sugar;

	bit [1:0]  family_room_lightswitch;


		// have a link to the left and the right house
		// note we are using the base class handle.
		// see example3 for info about that
	Monster_House_Blueprint left_house;
	Monster_House_Blueprint right_house;



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


		// here is an example of recursive calls to neighbor objects
	function bit got_sugar() ;
		int result = 0; 
		if (sugar == 0) begin
			if (left_house != null) 
				result = left_house.got_sugar(); 
			if (result == 0 && right_house != null) 
				result = right_house.got_sugar(); 

		end
		got_sugar = result;
	endfunction

endclass



Monster_House_Blueprint red, blue, yellow, green;
		// here we declare handles pointing to the Monster House.
		// now we can immediately take advantage of the new
		//funciontality



int result;

initial begin

	red = new(4, "middlefield");	
	green = new(6); 
	blue = new(8);
	yellow = new(33);


		// here we let the objects know about thier neighbors
	red.left_house = yellow;
	yellow.right_house = red;
	yellow.left_house = blue;
	blue.right_house = yellow;
	blue.left_house = green;
	green.right_house = blue;


		// now lets querry


	


end

endprogram


/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`define PHY_MAX_BURSTS_PER_FRAME 64
`define PHY_MAX_NUM_OF_SUPERZONES 5


//------------------------------------------------------------------------------------
// ClassName   : phy_frame
// Author      : Prashanth S
// Description : This is a frame descriptor having a set of super zones
//               These super zones will be constructed and randomized
//               according to the frame specific constraints
//
//------------------------------------------------------------------------------------
class phy_frame extends vmm_data;

  rand bit [8:0] super_zone_lengths[];
  rand bit [6:0] super_zone_bursts[];
  rand bit [4:0] num_of_super_zones;
  rand bit [8:0] bursts_per_frame;
  rand phy_super_zone super_zone_list[$];
  phy_super_zone blue_print_super_zone;

  bit [10:0] frame_length;
  int unsigned frame_index;
  phy_tb_config phy_cfg;

  constraint cst_phy_frame {
     num_of_super_zones >  0;
     num_of_super_zones <= `PHY_MAX_NUM_OF_SUPERZONES;
     bursts_per_frame > 0;
     bursts_per_frame <= `PHY_MAX_BURSTS_PER_FRAME;
     super_zone_bursts.sum()   == bursts_per_frame;
     super_zone_lengths.sum()  <= frame_length;
     super_zone_lengths.size() == num_of_super_zones;
     super_zone_bursts.size()  == num_of_super_zones;
     foreach (super_zone_lengths[i]) {
	super_zone_lengths[i] > 0;
	super_zone_bursts[i] > 0;
        super_zone_list[i].super_zone_index == i;
	super_zone_list[i].super_zone_length == super_zone_lengths[i];
	super_zone_list[i].bursts_per_super_zone == super_zone_bursts[i];
     }
  }

  //constraint cst_phy_frame_user;

  static vmm_log log = new("phy_frame", "class");

  //------------------------------------------------------------------------------------
  // Constructor: Assigns the phy config handle to the local pointer 
  //------------------------------------------------------------------------------------
  function new(phy_tb_config phy_cfg = null);
    super.new(log);
    this.phy_cfg = phy_cfg;
    if (phy_cfg != null) this.frame_length = phy_cfg.frame_length;
    blue_print_super_zone = new(phy_cfg);
  endfunction

  //------------------------------------------------------------------------------------
  // pre_randomize() executes automatically right before randomize is called for this object
  // This mechanism is used to create list a maximum no of super_zone
  // objects, and after randomize, remove the redundant objects in the
  // post_randomize() 
  //------------------------------------------------------------------------------------
  function void pre_randomize();
    resize_objects(`PHY_MAX_NUM_OF_SUPERZONES);
  endfunction

  //------------------------------------------------------------------------------------
  // Creates a new list of specified No. of super_zone objects
  //------------------------------------------------------------------------------------
  virtual function void resize_objects(int max_num_of_super_zones);
    this.super_zone_list.delete();
    for (int i=0; i<max_num_of_super_zones; i++) begin
	phy_super_zone super_zone;
	$cast(super_zone, blue_print_super_zone.allocate());
	super_zone_list.push_back(super_zone);
    end
  endfunction
  

  //------------------------------------------------------------------------------------
  // post_randomize() chops extra objects in the queue calculates dependent non
  // random values and calls build_super_zone() of each of the super_zone
  // objects
  //------------------------------------------------------------------------------------
  function void post_randomize();
    while (super_zone_list.size() > num_of_super_zones) begin
      super_zone_list.pop_back();
    end

    foreach (super_zone_list[i]) begin
      super_zone_list[i].frame_index = this.frame_index;
      if (i==0) begin
	  super_zone_list[i].zone_offset = 0;
	  super_zone_list[i].burst_offset = 0;
	  super_zone_list[i].length_offset = 0;
      end
      else begin
	  super_zone_list[i].zone_offset = super_zone_list[i-1].zone_offset + super_zone_list[i-1].num_of_zones;
	  super_zone_list[i].burst_offset = super_zone_list[i-1].burst_offset + super_zone_list[i-1].bursts_per_super_zone;
	  super_zone_list[i].length_offset = super_zone_list[i-1].length_offset + super_zone_list[i-1].super_zone_length;
      end
      if (i < super_zone_list.size() - 1)
	   super_zone_list[i].next_super_zone_direction = super_zone_list[i+1].super_zone_direction;
      `vmm_trace(log, $psprintf("Frame#%0d, Building super zone %0d", 
                            frame_index, i));
      super_zone_list[i].build_super_zone();
    end
  endfunction


  virtual function vmm_data allocate();
    phy_frame frame = new(phy_cfg);
    $cast(frame.blue_print_super_zone, blue_print_super_zone.allocate());
    allocate = frame;
  endfunction

  //------------------------------------------------------------------------------------
  // Capture all the fields of this object in a string and return it
  //------------------------------------------------------------------------------------
  virtual function string psdisplay(string prefix = "");
    string result;
    result = {$psprintf("\n------------------------------------ %sFrame #%0d  --------------------------------------------\n", prefix, frame_index), 
              $psprintf("Length=%0d symbols, NumOfSuperZones=%0d, Total Bursts=%0d\n\n",
                        frame_length, num_of_super_zones, bursts_per_frame)};
    foreach (super_zone_list[i]) begin
      string pref = $psprintf("    SuperZone #%0d:", i);
      result = {result, super_zone_list[i].psdisplay(pref), "\n\n"};
    end
    psdisplay = {result, "----------------------------------------------------------------------------------\n"};
  endfunction


  virtual function vmm_data copy(vmm_data to=null);
    phy_frame tr;
    if (to != null) begin
       if (!$cast(tr, to)) begin
         `vmm_fatal(log, "Expecting derivative of phy_frame class for copy()");
       end
    end
    else begin
      tr = new this;
      //TODO - All the fields must be copied
      `vmm_warning(log, "Copy() method is not complete !!!!!");
      copy = tr;
    end
  endfunction

endclass

`vmm_channel(phy_frame)

`vmm_atomic_gen(phy_frame, "PhyGen")


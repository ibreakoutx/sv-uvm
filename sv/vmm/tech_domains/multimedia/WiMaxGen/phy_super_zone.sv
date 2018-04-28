/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`define PHY_MAX_NUM_OF_ZONES 10

//------------------------------------------------------------------------------------
// ClassName   : phy_super_zone
// Author      : Prashanth S
// Description : This is a super zone descriptor having a set of zones
//               These zones will be constructed and randomized
//               according to the super zone specific constraints
//               Also zone specific parameters like zone_length,
//               permutations are determined here
//
//------------------------------------------------------------------------------------
class phy_super_zone extends vmm_data;

  typedef enum {TX_SUPER_ZONE, RX_SUPER_ZONE} super_zone_direction_t;
  typedef enum {DOWNLINK, UPLINK} super_zone_mode_t;
  typedef enum {WIMAX} super_zone_type_t;

  rand super_zone_direction_t  super_zone_direction;
  rand super_zone_mode_t       super_zone_mode;
  rand super_zone_type_t       super_zone_type;
  rand bit [8:0]               super_zone_length;
  rand bit [4:0]               num_of_zones;
  rand bit [5:0]               zone_lengths[];
  rand phy_zone::permutation_t permutations[];
  rand bit [8:0]               bursts_per_super_zone;
  rand bit [6:0]               bursts_per_zone[];
  rand bit [4:0]               super_zone_index;


  phy_zone                     zone_list[$];
  bit [5:0]                    burst_offset;
  bit [4:0]                    zone_offset;
  int unsigned                 length_offset;
  super_zone_direction_t       next_super_zone_direction;
  int unsigned                 frame_index;
  phy_tb_config                phy_cfg;
  phy_zone                     blue_print_zone;

  static vmm_log               log = new("phy_super_zone", "class");

  //-----------------------------------------------
  // Valid constraints
  //-----------------------------------------------
  constraint cst_phy_super_zone_valid {
     zone_lengths.sum() == super_zone_length;
     bursts_per_zone.sum() == bursts_per_super_zone;
     zone_lengths.size() == num_of_zones;
     bursts_per_zone.size() == num_of_zones;
     permutations.size() == num_of_zones;
     num_of_zones inside {[1: `PHY_MAX_NUM_OF_ZONES]};
     foreach (zone_lengths[i]) {
       zone_lengths[i] > 0;
       zone_lengths[i] < phy_cfg.frame_length;
       bursts_per_zone[i] > 0;
       bursts_per_zone[i] < `PHY_MAX_BURSTS_PER_ZONE;
       if (super_zone_mode == UPLINK) zone_lengths[i] % `UL_SYMBOLS_PER_SLOT == 0;
       if (super_zone_mode == DOWNLINK && permutations[i] == phy_zone::PUSC) 
	       zone_lengths[i] % `DL_PUSC_SYMBOLS_PER_SLOT == 0;
     }
  }

  //-----------------------------------------------
  // Empty constraint can be defined by the user
  //-----------------------------------------------
  //constraint cst_phy_super_zone_user;

  function new(phy_tb_config phy_cfg);
    super.new(log);
    this.phy_cfg = phy_cfg;
    blue_print_zone = new(phy_cfg);
  endfunction

  //------------------------------------------------------------------------------------
  // build_super_zone is called after randomization (by the frame object)
  // This randomizes the zone objects sequentially. Note that this function
  // assumes that the zone length and zone permutation is ready
  //------------------------------------------------------------------------------------
  virtual function void build_super_zone();
    int brst_idx = burst_offset;
    int sym_idx = length_offset;
    string txt;
    zone_list.delete();
    txt = $psprintf("%s %s %s SuperZone:NumOfZones=%0d, Length=%0d\n", 
                super_zone_direction.name, super_zone_mode.name, 
		super_zone_type.name, num_of_zones, super_zone_length);
    `vmm_trace(log, {"Building zone list in super zone", txt});
    for (int i=0; i<num_of_zones; i++) begin
       phy_zone zone;
       $cast (zone, blue_print_zone.allocate());
       if (super_zone_mode == DOWNLINK) 
	  zone.zone_mode = phy_zone::DOWNLINK;
       else if (super_zone_mode == UPLINK)
	  zone.zone_mode = phy_zone::UPLINK;
       else 
	  `vmm_fatal(log, $psprintf("Unknown mode %s", zone.zone_mode));
       zone.permutation = permutations[i];
       zone.zone_length = zone_lengths[i];
       zone.num_of_bursts = bursts_per_zone[i];
       zone.zone_index    = zone_offset + i; //TBD Unique index
       zone.fb_offset     = sym_idx;
       zone.burst_offset  = brst_idx;
       zone.frame_index   = frame_index;
       zone.super_zone_index = super_zone_index;
       sym_idx += zone_lengths[i];
       brst_idx += bursts_per_zone[i];
       if (super_zone_direction == TX_SUPER_ZONE) begin
	  zone.current_zone = phy_zone::TX_ZONE;
          zone.next_zone = phy_zone::TX_ZONE;
       end
       else begin
	  zone.current_zone = phy_zone::RX_ZONE;
          zone.next_zone = phy_zone::RX_ZONE;
       end
       if (i == num_of_zones-1) begin
         if (next_super_zone_direction == TX_SUPER_ZONE)
            zone.next_zone = phy_zone::TX_ZONE;
	 else
            zone.next_zone = phy_zone::RX_ZONE;
       end
       case (super_zone_type)
         WIMAX : zone.zone_type = phy_zone::WIMAX_ZONE;
	 default: begin
	            `vmm_fatal(log, $psprintf("SuperZoneType %s Not Supported", 
		       super_zone_type.name));
	          end
       endcase
       if (zone.fb_offset == 0 && super_zone_mode == DOWNLINK) 
	  zone.dl_preamble_en = 1;
 
       zone.randomize();

       `vmm_trace(log, "Adding zone object to zone_list");
       zone_list.push_back(zone);
    end
  endfunction

  //------------------------------------------------------------------------------------
  // Capture all the fields of this object in a string and return it
  //------------------------------------------------------------------------------------
  virtual function string psdisplay(string prefix = "");
    string result;
    result = $psprintf("%s %s %s %s NumOfZones=%0d, Length=%0d symbols\n", 
                prefix, super_zone_direction.name, super_zone_mode.name, 
		super_zone_type.name, num_of_zones, super_zone_length);
    foreach (zone_list[i]) begin
      string pref = $psprintf("%s Zone #%0d:", prefix, i);
      result = {result, zone_list[i].psdisplay(pref)};
    end
    psdisplay = result;
  endfunction

  virtual function vmm_data allocate();
    phy_super_zone super_zone = new(phy_cfg);
    $cast(super_zone.blue_print_zone, this.blue_print_zone.allocate());
    allocate = super_zone;
  endfunction

endclass


/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`define UL_NUM_OF_SUBCHANNELS 35
`define DL_PUSC_NUM_OF_SUBCHANNELS 30
`define DL_FUSC_NUM_OF_SUBCHANNELS 16

`define UL_SYMBOLS_PER_SLOT 3
`define DL_PUSC_SYMBOLS_PER_SLOT 2
`define DL_FUSC_SYMBOLS_PER_SLOT 1

`define PHY_MAX_BURSTS_PER_ZONE 10 
`define PHY_DUMMY_BURST_COLOR 63


class phy_zone extends vmm_data;

  typedef enum {UPLINK, DOWNLINK} zone_mode_t;
  typedef enum bit {TX_ZONE = 1'b0, RX_ZONE = 1'b1} zone_kind_t;
  typedef enum bit [3:0] {WIMAX_ZONE = 4'b0000, 
                          WIMAX_DL_FCH_ZONE = 4'b0010,
                          WIMAX_DL_MAP_ZONE = 4'b0100
                          } zone_type_t;
  typedef enum bit [3:0] {PUSC = 4'b0000,
                          FUSC = 4'b0001
                         } permutation_t;
  typedef enum bit [1:0] {NO_STC = 2'b00, STC_2 = 2'b01, STC_3 = 2'b10} stc_mode_t;
  typedef enum bit [1:0] {MATRIX_A = 2'b00, 
                          MATRIX_B = 2'b01, 
                          MATRIX_C = 2'b10,
                          MATRIX_BH = 2'b11
                         } matrix_t;


  rand bit [10:0]    padding_samples;
  rand bit [1:0]     prbs_id;
  rand bit [5:0]     dl_perm_base;
  rand bit [6:0]     ul_perm_base;
  rand stc_mode_t    stc_mode;
  rand matrix_t      matrix;
  rand bit [3:0]     beam_select;
  rand bit           use_sub_chan;
  rand bit           dedicated_pilots;
  rand bit [17:0]    power_boosting;
  rand bit [15:0]    data_rotation_assist_table_ptr;
  rand bit [15:0]    antenna_coef_ptr;
 

  //Rx specific fields
  rand bit           mac_report_gen_intrpt;
  rand bit           phy_report_gen_intrpt;
  rand bit           disable_rotation_scheme;
  rand bit           color_map_continue;
  rand bit [10:0]    throwing_samples;
  rand bit [1:0]     burst_buffer_index;
  rand bit [1:0]     rotation_buffer_index;
  rand bit [3:0]     permutation_table_index;

  rand bit [7:0]     mod_cdma_S;
  rand bit [7:0]     mod_cdma_N;
  rand bit [7:0]     mod_cdma_M;
  rand bit [7:0]     mod_cdma_L;
  rand bit [7:0]     mod_cdma_O;

  //Burst Dimensions specific fields
  rand bit [5:0]     symb_lengths[];
  rand bit [5:0]     subchan_lengths[];
  rand bit [10:0]    burst_slots[];
  rand bit [5:0]     start_symb[];
  rand bit [5:0]     start_subchan[];
  bit [4:0]          subchans_per_segment[3];

  //Burst list
  rand phy_burst     burst_list[$];

  //Fields updated by the super_zone object
  zone_mode_t   zone_mode;
  zone_kind_t   current_zone;
  zone_kind_t   next_zone;
  zone_type_t   zone_type; 
  permutation_t permutation;
  bit [10:0]    zone_length; //in symbols - Increased the width for randomization
  bit [7:0]     zone_index;
  bit [7:0]     fb_offset;
  bit [5:0]     burst_offset;
  bit [7:0]     num_of_bursts;
  bit [15:0]    num_of_slots; 
  bit [3:0]     symbols_per_slot; 
  bit [10:0]    num_of_subchannels; //Increased the width for randomization
  bit           dl_preamble_en; //TBD to check with Ronen
  phy_color     colors[$];
  int           frame_index;
  int           super_zone_index;

  bit [31:0]    spare = 0;
  phy_tb_config phy_cfg;

  static vmm_log     log = new("Zone", "class");

  constraint cst_mod_cdma {
    mod_cdma_S + mod_cdma_N + mod_cdma_M +mod_cdma_L + mod_cdma_O inside {[0:255]};
  }

  constraint cst_phy_zone_default {
    prbs_id == 0;
    power_boosting == 0;
  }

  //Constraints responsible for the creation
  // of rectangular bursts
  constraint cst_phy_zone_bursts {
    burst_slots.sum() <= num_of_slots; //Sum of burst areas <= Total zone area  
    burst_slots.size() == num_of_bursts;
    symb_lengths.size() == num_of_bursts;
    subchan_lengths.size() == num_of_bursts;
    start_symb.size() == num_of_bursts;
    start_subchan.size() == num_of_bursts;
    //Constraints to make sure all bursts are rectangular and falls into
    //the specified zone area
    foreach (burst_slots[i]) {
      burst_slots[i] > 0;
      burst_slots[i] == symb_lengths[i] * subchan_lengths[i] / symbols_per_slot;
      symb_lengths[i] <= burst_slots[i] * symbols_per_slot;
      subchan_lengths[i] <= burst_slots[i] ;

      symb_lengths[i] <= zone_length;
      subchan_lengths[i] <= num_of_subchannels;

      start_symb[i] + symb_lengths[i] <= fb_offset +zone_length;
      start_subchan[i] + subchan_lengths[i] <= num_of_subchannels;
      if (i == 0) {
        start_symb[i] >= fb_offset;
        start_subchan[i] >= 0;
      } else {
        ((start_symb[i] >= start_symb[i-1]+symb_lengths[i-1]) && (start_subchan[i] >= start_subchan[i-1])) ||
        ((start_subchan[i] >= start_subchan[i-1]+subchan_lengths[i-1]) && (start_symb[i] >= start_symb[i-1]));
      }
    }
  }

  constraint cst_phy_zone_symb_per_slot {
    foreach (start_symb[i]) {
      (start_symb[i] -fb_offset) % symbols_per_slot == 0;
      symb_lengths[i] % symbols_per_slot == 0;
    }
  }

 

  //constraint cst_phy_zone_user;

  
  function new(phy_tb_config phy_cfg);
    super.new(log);
    this.phy_cfg = phy_cfg;
  endfunction

  function void pre_randomize();
    resize_bursts(`PHY_MAX_BURSTS_PER_ZONE);

    num_of_subchannels = get_num_of_subchannels();
    num_of_slots       = get_num_of_slots();
    symbols_per_slot   = get_symbols_per_slot();

    if (permutation == phy_zone::FUSC && zone_mode == DOWNLINK)
        this.cst_phy_zone_symb_per_slot.constraint_mode(0);
    else
        this.cst_phy_zone_symb_per_slot.constraint_mode(1);

    `vmm_trace(log, $psprintf("Frame#%0d, SuperZone#%0d, %s %s Zone#%0d, NumBursts=%0d, Len=%0d symbols, Depth=%0d: Randomizing zone object", 
                    frame_index, super_zone_index, permutation.name, zone_mode.name, zone_index, num_of_bursts, zone_length, num_of_subchannels));

  endfunction

  function void post_randomize();
      chop_extra_bursts();
      do_directed_burst_handling(); 
      create_colors();
      do_reshape_and_coloring();
    `vmm_trace(log, $psprintf("Generated zone: %s", this.psdisplay()));
  endfunction

  virtual function void do_directed_burst_handling();
  endfunction

  virtual function set_burst(int frame_index,
                             int burst_index, 
                             int symbol_index,
			     int subchan_index,
			     int symbol_length,
			     int subchan_length);
    int idx = burst_index - burst_offset;
    if (frame_index == this.frame_index) begin
      if (idx > burst_slots.size()) begin
          `vmm_fatal(log, $psprintf("Invalid burst index to set: NumOfBursts=%0d", num_of_bursts));
      end
      `vmm_note(log, $psprintf("Frame:%0d, Zone:%0d, Setting burst %0d: sym_idx=%0d, subchan_idx=%0d, symbol_length=%0d, subchan_length=%0d", 
           frame_index, zone_index, burst_index, symbol_index, subchan_index, symbol_length, subchan_length)); 

      burst_slots[burst_index] = symbol_length * subchan_length / symbols_per_slot;
      start_symb[burst_index]  = symbol_index;
      start_subchan[burst_index] = subchan_index;
      symb_lengths[burst_index] = symbol_length;
      subchan_lengths[burst_index] = subchan_length;
    end
  endfunction
  
  virtual function resize_bursts(int max_no_of_bursts);
    burst_list.delete();
    for (int i=0; i<max_no_of_bursts; i++) begin
	phy_burst burst = new(this);
	burst_list.push_back(burst);
    end
  endfunction

  function void chop_extra_bursts();
    while (burst_list.size() > num_of_bursts) begin
	burst_list.pop_back();
    end
  endfunction

  virtual function void create_colors();
    int n_slots = get_num_of_slots();
    int n_sc = get_num_of_subchannels();
    int n_sym_per_slot = get_symbols_per_slot();

    for (int i = 0; i<n_sc; i++) begin
       for (int j=fb_offset; j<fb_offset+zone_length; j=j+n_sym_per_slot) begin
	    phy_color color = new(j, i, `PHY_DUMMY_BURST_COLOR, zone_index);
	    colors.push_back(color);
       end
    end
  endfunction


  virtual function void do_reshape_and_coloring();
    int symb_offset;
    int subchan_offset;
    //Does Rectangular coloring all downlink bursts and uplink non-regular bursts
    for (int i=0; i<num_of_bursts; i++) begin
       if (zone_mode == UPLINK && 
	   burst_list[i].burst_type == phy_burst::REGULAR_BURST)
           continue;
       burst_list[i].lower_sym_indx = start_symb[i];
       burst_list[i].upper_sym_indx = start_symb[i] + symb_lengths[i] - symbols_per_slot;
       burst_list[i].lower_sub_chan_indx = start_subchan[i];
       burst_list[i].upper_sub_chan_indx = start_subchan[i] + subchan_lengths[i] - 1;
       for (int j=start_symb[i]; j<start_symb[i]+symb_lengths[i]; j=j+symbols_per_slot) begin
	 for (int k=start_subchan[i]; k<start_subchan[i]+subchan_lengths[i]; k++) begin
           phy_color color;
	   `vmm_debug(log, $psprintf("Coloring zone#%0d, burst#%0d, sym=%0d, subchan=%0d", zone_index, i, j, k));
	   color = get_color(j, k);
	   color.set_burst_index(burst_offset+i); 
	 end
       end
    end
    //Does Snake coloring for uplink regular bursts
    symb_offset = fb_offset;
    subchan_offset = 0;
    for (int i=0; i<num_of_bursts; i++) begin
       int n_slots = 0;
       bit done = 0;
       bit is_start_position = 1;
       if (zone_mode == UPLINK &&
	   burst_list[i].burst_type == phy_burst::REGULAR_BURST) begin
	   for (int j=0; j<num_of_subchannels; j++) begin
	     for (int k=fb_offset; k<fb_offset+zone_length; k=k+symbols_per_slot) begin
	       phy_color color;
	      
	       if (n_slots >= burst_slots[i]) begin
		 symb_offset = k;
		 subchan_offset = j;
		 done = 1;
		 break;
	       end
	       color = get_color(k, j);
	       //Color slot if it is not yet colored
	       if (!color.is_colored) begin
                 //Check if it is the starting slot of the burst
                 if (is_start_position == 1) begin
                   burst_list[i].lower_sym_indx = k;
                   burst_list[i].lower_sub_chan_indx = j;
                   is_start_position = 1;
                 end
                 burst_list[i].upper_sym_indx = k;
                 burst_list[i].upper_sub_chan_indx = j;
		 color.set_burst_index(burst_offset+i);
		 n_slots++;
	       end
	     end
	     if (done) break;
	   end
       end
    end
  endfunction

  virtual function phy_color get_color(int symb_indx, int sub_chan_indx);
     foreach (this.colors[i]) begin
       if (colors[i].symbol_indx == symb_indx && 
	   colors[i].sub_chan_indx == sub_chan_indx) begin
	   return(colors[i]);
       end
     end
     `vmm_error(log, $psprintf("Zone#%0d: Color with sym#%0d, subchan#%0d not found", zone_index, symb_indx, sub_chan_indx));
     $display("Total available colors are below:");
     foreach (this.colors[i]) begin
       $display("%s", colors[i].psdisplay());
     end
     `vmm_fatal(log, $psprintf("Zone#%0d: Unable to continue", zone_index));
  endfunction


  virtual function int unsigned get_num_of_subchannels();
    if (zone_mode == UPLINK) 
      get_num_of_subchannels = phy_cfg.num_of_ul_subchannels;
    else if (zone_mode == DOWNLINK && permutation == PUSC)
      get_num_of_subchannels = phy_cfg.num_of_dl_pusc_subchannels;
    else if (zone_mode == DOWNLINK && permutation == FUSC)
      get_num_of_subchannels = phy_cfg.num_of_dl_fusc_subchannels;
    else begin
      `vmm_fatal(log, $psprintf("Unsupported mode/permutation %s %s", zone_mode.name, permutation.name));
    end
  endfunction

  virtual function int unsigned get_symbols_per_slot();
    if (zone_mode == UPLINK) 
      get_symbols_per_slot = `UL_SYMBOLS_PER_SLOT; 
    else if (zone_mode == DOWNLINK && permutation == PUSC)
      get_symbols_per_slot = `DL_PUSC_SYMBOLS_PER_SLOT;
    else if (zone_mode == DOWNLINK && permutation == FUSC)
      get_symbols_per_slot = `DL_FUSC_SYMBOLS_PER_SLOT;
    else begin
      `vmm_fatal(log, $psprintf("Unsupported mode/permutation %s", zone_mode.name, permutation.name));
    end
  endfunction

  virtual function int unsigned get_num_of_slots();
    get_num_of_slots = zone_length * get_num_of_subchannels() / get_symbols_per_slot();
  endfunction

  virtual function string psdisplay(string prefix = "");
    string result;
    if (current_zone == TX_ZONE) begin
        result = { $psprintf("\t************************************************\n"),
                   $psprintf("\t%s %s\n", prefix, current_zone.name),
                   $psprintf("\t************************************************\n"),
                   $psprintf("\tzone_index       : 0d%0d\n", zone_index),
                   $psprintf("\tzone_type        : %s\n",  zone_type.name),
                   $psprintf("\tpermutation      : %s\n",  permutation.name),
                   $psprintf("\tDL preamble      : %b\n",  dl_preamble_en),
                   $psprintf("\tnext_zone        : %s\n",  next_zone.name),
                   $psprintf("\tpadding_samples  : 0x%0x\n",  padding_samples),
                   $psprintf("\tzone_length      : %0d symbols\n",  zone_length),
                   $psprintf("\tFB_offset        : %0d\n",  fb_offset),
                   $psprintf("\tPRBS ID          : 0x%0x\n",  prbs_id),
                   $psprintf("\tDL_PERMBase      : 0x%0x\n",  dl_perm_base),
                   $psprintf("\tnum_of_bursts    : %0d\n",  num_of_bursts),
                   $psprintf("\tstc_mode         : %s\n",  stc_mode.name),
                   $psprintf("\tmatrix           : %s\n",  matrix.name),
                   $psprintf("\tbeam_select      : 0x%0x\n",  beam_select),
                   $psprintf("\tuse_sub_channel  : %b\n",  use_sub_chan),
                   $psprintf("\tdedicated_pilots : %b\n",  dedicated_pilots),
                   $psprintf("\tzone_boosting    : 0x%0x\n",  power_boosting),
                   $psprintf("\tdata_rot_assist  : 0x%0x\n",  data_rotation_assist_table_ptr),
                   $psprintf("\tantenna_coef_ptr : 0x%0x\n",  antenna_coef_ptr),
                   $psprintf("\t************************************************\n")
                 };
     end
     else if (current_zone == RX_ZONE) begin
        result = { $psprintf("\t************************************************\n"),
                   $psprintf("\t\t%s Zone %s\n", prefix, current_zone.name),
                   $psprintf("\t************************************************\n"),
                   $psprintf("\tzone_index              : 0d%0d\n", zone_index),
                   $psprintf("\tzone_type               : %s\n",  zone_type.name),
                   $psprintf("\tpermutation             : %s\n",  permutation.name),
                   $psprintf("\tnum_of_slots            : %0d\n",  num_of_slots),
                   $psprintf("\tnum_of_symbols          : %0d\n",  zone_length),
                   $psprintf("\tstc_mode                : %s\n",  stc_mode.name),
                   $psprintf("\tmatrix                  : %s\n",  matrix.name),
                   $psprintf("\tmac_report_gen_intrpt   : %b\n",  mac_report_gen_intrpt),
                   $psprintf("\tphy_report_gen_intrpt   : %b\n",  phy_report_gen_intrpt),
                   $psprintf("\tdisable_rotation_scheme : %b\n",  disable_rotation_scheme),
                   $psprintf("\tcolor_map_continue      : %b\n",  color_map_continue),
                   $psprintf("\tPRBS ID                 : 0x%0x\n",  prbs_id),
                   $psprintf("\tnext_zone               : %s\n",  next_zone.name),
                   $psprintf("\tthrowing_samples        : 0d%0d\n", throwing_samples),
                   $psprintf("\tburst_buffer_index      : 0x%0x\n", burst_buffer_index),
                   $psprintf("\trotation_buffer_index   : 0x%0x\n", rotation_buffer_index),
                   $psprintf("\tperm_table_index        : 0x%0x\n", permutation_table_index),
                   $psprintf("\tnum_of_bursts           : %0d\n",  num_of_bursts),
                   $psprintf("\tantenna_coef_ptr        : 0x%0x\n",  antenna_coef_ptr),
                   $psprintf("\t************************************************\n")
                 };
     end
     psdisplay = {result, burst_psdisplay()};
  endfunction

  virtual function string burst_psdisplay();
     string result;
    result = $psprintf("Total area = %0d, NumOfBursts = %0d\n", num_of_slots, num_of_bursts);
    foreach (burst_slots[i]) begin
      result = {result,  $psprintf("%0d: Area = %0d slots (%0d), len = %0d, depth = %0d: start_symb=%0d, start_subchan=%0d\n", i, burst_slots[i], burst_slots[i]*symbols_per_slot, symb_lengths[i], subchan_lengths[i], start_symb[i], start_subchan[i])};
    end

     result = {result, $psprintf("\n   ")};
     for (int j=fb_offset; j<fb_offset+zone_length; j=j+symbols_per_slot) begin
	  result = {result, $psprintf("%4d", j)};
     end
     result = {result, $psprintf("\n  ")};
     for (int j=fb_offset; j<fb_offset+zone_length; j=j+symbols_per_slot) begin
	  result = {result, "____"};
     end
     result = {result, $psprintf("\n")};


     for (int i=0; i<num_of_subchannels; i++) begin
        result = {result, $psprintf("%2d|", i)};
	for (int j=fb_offset; j<fb_offset+zone_length; j=j+symbols_per_slot) begin
	  phy_color clr = get_color(j, i);
	  if (clr.is_colored)
            result = {result, $psprintf("%4d", clr.burst_indx)};
	  else
	    result = {result, "   #"};
	end
	result = {result, $psprintf("\n")};
     end
     burst_psdisplay = result;
  endfunction

  function void get_words (ref bit [31:0] words[$]);
    if (current_zone == TX_ZONE) get_tx_words(words);
    else get_rx_words(words);
  endfunction

  function void get_rx_words (ref bit [31:0] words[$]);
    bit [31:0] data; 
    bit [5:0] num_sym = zone_length;
    data = {burst_buffer_index, rotation_buffer_index, num_of_bursts, antenna_coef_ptr};
    words.push_back(data);
    data = {num_sym, stc_mode, matrix, mac_report_gen_intrpt, phy_report_gen_intrpt, 
            disable_rotation_scheme, color_map_continue, prbs_id, spare[1:0], next_zone, 
            throwing_samples};
    words.push_back(data);
    data = {zone_index, zone_type, permutation, num_of_slots}; 
    words.push_back(data);
  endfunction

  function void get_tx_words (ref bit [31:0] words[$]);
    bit [31:0] data; 
    bit [5:0] num_sym = zone_length;
    if (zone_index == 0) num_sym++;
    data = {data_rotation_assist_table_ptr, antenna_coef_ptr};
    words.push_back(data);
    data = {stc_mode, matrix, beam_select, use_sub_chan, dedicated_pilots, power_boosting};
    words.push_back(data);
    data = {spare, num_sym, fb_offset, prbs_id, dl_perm_base, num_of_bursts};
    words.push_back(data);
    data = {zone_index, zone_type, permutation, dl_preamble_en, spare[2:0], next_zone, padding_samples}; 
    words.push_back(data);
  endfunction

  virtual function vmm_data allocate();
    phy_zone zone = new(phy_cfg);
    allocate = zone;
  endfunction

endclass

`vmm_channel(phy_zone)


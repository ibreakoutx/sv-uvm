/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


`define PHY_REGULAR_BURST          4'b0000
`define PHY_RANGING_BURST          4'b0001
`define PHY_SOUNDING_BURST         4'b0010
`define PHY_BH_BURST               4'b0011
`define PHY_MINI_SUBCHANNEL_BURST  4'b0100
`define PHY_CQICH_BURST            4'b0101
`define PHY_PAPR_DUMMY_BURST       4'b0110
`define PHY_ACKCH_BURST            4'b0111

//Coding type
`define PHY_CODING_TYPE_UNCODED    2'b00
`define PHY_CODING_TYPE_CC         2'b01
`define PHY_CODING_TYPE_CTC        2'b10
`define PHY_CODING_TYPE_BH         2'b11

//Modulation type
`define PHY_BURST_MODULATION_QPSK    2'b00
`define PHY_BURST_MODULATION_QAM_16  2'b01
`define PHY_BURST_MODULATION_QAM_64  2'b10
`define PHY_BURST_MODULATION_QAM_256  2'b11

//Boosting
`define PHY_BOOSTING_NORMAL          3'b000 
`define PHY_BOOSTING_PLUS_6DB        3'b001 
`define PHY_BOOSTING_MINUS_6DB       3'b010 
`define PHY_BOOSTING_PLUS_9DB        3'b011 
`define PHY_BOOSTING_PLUS_3DB        3'b100 
`define PHY_BOOSTING_MINUS_3DB       3'b101 
`define PHY_BOOSTING_MINUS_9DB       3'b110 
`define PHY_BOOSTING_MINUS_12DB      3'b111 

typedef class phy_zone;

class phy_burst extends vmm_data;
  typedef enum bit [1:0] {UNCODED      = `PHY_CODING_TYPE_UNCODED, 
                          CC_CODING    = `PHY_CODING_TYPE_CC, 
                          CTC_CODING   = `PHY_CODING_TYPE_CTC, 
                          BH_CODING    = `PHY_CODING_TYPE_BH
                         } coding_type_t;

  typedef enum bit [3:0] {REGULAR_BURST         = `PHY_REGULAR_BURST,
                          RANGING_BURST         = `PHY_RANGING_BURST,
                          SOUNDING_BURST        = `PHY_SOUNDING_BURST,
                          BH_BURST              = `PHY_BH_BURST,
                          MINI_SUBCHANNEL_BURST = `PHY_MINI_SUBCHANNEL_BURST,
                          CQICH_BURST           = `PHY_CQICH_BURST,
                          PAPR_DUMMY_BURST      = `PHY_PAPR_DUMMY_BURST,
                          ACKCH_BURST           = `PHY_ACKCH_BURST
                         } burst_type_t;

  typedef enum bit [1:0] {QPSK            = `PHY_BURST_MODULATION_QPSK,
                          QAM_16          = `PHY_BURST_MODULATION_QAM_16,
                          QAM_64          = `PHY_BURST_MODULATION_QAM_64,
                          QAM_256         = `PHY_BURST_MODULATION_QAM_256
                         } modulation_type_t;

  typedef enum bit [2:0] {NORMAL = `PHY_BOOSTING_NORMAL,
                          PLUS_6DB = `PHY_BOOSTING_PLUS_6DB,
                          MINUS_6DB = `PHY_BOOSTING_MINUS_6DB,
                          PLUS_9DB = `PHY_BOOSTING_PLUS_9DB,
                          PLUS_3DB = `PHY_BOOSTING_PLUS_3DB,
                          MINUS_3DB = `PHY_BOOSTING_MINUS_3DB,
                          MINUS_9DB = `PHY_BOOSTING_MINUS_9DB,
                          MINUS_12DB = `PHY_BOOSTING_MINUS_12DB
                         } boosting_t;

  typedef enum bit {LLR_OVERWRITE = 1'b0, LLR_ADD = 1'b1} harq_llr_op_t;


  rand burst_type_t      burst_type;
  rand coding_type_t     coding_type;
  rand modulation_type_t modulation_type;
  rand boosting_t        boosting;
  rand bit [2:0]         coding_rate;
  rand bit [1:0]         repetition;
  rand bit               interleaver_bypass;
  rand bit               scrambler_bypass;
  rand bit [9:0]         num_of_slots;

  //Fields used for Ranging mode only
  rand bit [1:0]         ranging_method;
  rand bit [14:0]        cdma_seed;

  //Location information of the burst
  rand int unsigned      burst_index;
  bit [31:0]             lower_sub_chan_indx;
  bit [31:0]             upper_sub_chan_indx;
  bit [31:0]             lower_sym_indx;
  bit [31:0]             upper_sym_indx; //TBD


  //Rx specific Burst parameters
  rand bit [9:0]         cid;
  rand harq_llr_op_t     harq_llr_operation;
  rand bit [13:0]        llr_address;
  rand bit               deinterleaver_bypass;
  rand bit               descrambler_bypass;

  int num_of_bits_in_burst;
  phy_zone               parent_zone;
  phy_color              colors[$];
  static vmm_log         log = new("Burst", "class");

  //constraint cst_phy_burst_user;

  function new(phy_zone parent_zone);
    super.new(log);
    this.parent_zone = parent_zone;
    this.num_of_bits_in_burst = 0;
  endfunction
 
  virtual function void calculate_num_of_bits_in_burst();
	int n_slots;
	int mod_order;

	n_slots = this.num_of_slots;
	case (this.modulation_type)
	        QPSK    : mod_order = 2;
        	QAM_16  : mod_order = 4;
	        QAM_64  : mod_order = 6;
        	QAM_256 : mod_order = 8;
		default : begin
	            `vmm_fatal(log, $psprintf("Modulation %s is not supported", this.modulation_type.name));
		    mod_order = 0;
	        end
	endcase
	this.num_of_bits_in_burst = n_slots * 48 * mod_order;

      case (this.coding_rate)
        3'b000: this.num_of_bits_in_burst = (this.num_of_bits_in_burst * 1/2);
        3'b001: this.num_of_bits_in_burst = (this.num_of_bits_in_burst * 2/3);
        3'b010: this.num_of_bits_in_burst = (this.num_of_bits_in_burst * 3/4);
        3'b011: this.num_of_bits_in_burst = (this.num_of_bits_in_burst * 5/6);
        3'b100: this.num_of_bits_in_burst = (this.num_of_bits_in_burst * 5/8);
        3'b101: this.num_of_bits_in_burst = (this.num_of_bits_in_burst * 7/8);
      endcase

  endfunction



  virtual function void update_dl_fields();
    int unsigned sc_idx;
    colors.delete(); 
    for (int i=parent_zone.fb_offset; i<parent_zone.fb_offset+parent_zone.zone_length; i=i+parent_zone.symbols_per_slot) begin
      for (int j = lower_sub_chan_indx; j <= upper_sub_chan_indx; j++) begin
        phy_color color = new(i, j, burst_index, parent_zone.zone_index);
        colors.push_back(color);
      end  
    end
  endfunction

  //follow snake path and return the next vacant slot (sym_idx and sc_idx)
  virtual function void update_ul_fields(ref int unsigned sym_idx, ref int unsigned sc_idx);
    bit left2right;
    int unsigned slot_no = 0;
    
    lower_sym_indx = sym_idx;
    lower_sub_chan_indx = sc_idx;
    colors.delete();
    while (slot_no < num_of_slots) begin
      phy_color color;
      if (sc_idx % 2 == 0) left2right = 1;
      else left2right = 0;
      
      color = new(sym_idx, sc_idx, burst_index, parent_zone.zone_index);
      colors.push_back(color);
      slot_no++;
      upper_sym_indx = sym_idx+parent_zone.symbols_per_slot-1;
      upper_sub_chan_indx = sc_idx;
      if (left2right) begin
        if (sym_idx + parent_zone.symbols_per_slot >= parent_zone.fb_offset+parent_zone.zone_length) sc_idx++;
        else sym_idx = sym_idx + parent_zone.symbols_per_slot;
      end
      else begin
        if (sym_idx - parent_zone.symbols_per_slot < parent_zone.fb_offset) sc_idx++;
        else sym_idx = sym_idx - parent_zone.symbols_per_slot;
      end
    end
  endfunction

  virtual function void get_burst_words(ref bit[31:0] val_words[$]);
    if (parent_zone.current_zone == phy_zone::TX_ZONE) get_tx_burst_words(val_words);
    else get_rx_burst_words(val_words);
  endfunction

  virtual function void get_rx_burst_words(ref bit[31:0] val_words[$]);
    bit [31:0] result;
    result = 0;
    result[30] = harq_llr_operation;
    result[29:16] = llr_address;
    result[15] = deinterleaver_bypass;
    result[14] = descrambler_bypass;
    result[9:0]   = num_of_slots;
    val_words.push_back(result);
    result = 0;
    result[31:29] = burst_type;
    result[28:26] = coding_rate;
    result[25:16] = cid;
    result[15:14] = modulation_type;
    result[13:12] = coding_type;
    result[11:10] = repetition;
    val_words.push_back(result);
  endfunction

  virtual function void get_tx_burst_words(ref bit[31:0] val_words[$]);
    //todo bit [31:0] result = $random;
    bit [31:0] result = 0;

    result [31:28] = burst_type;
    result[9:0]   = num_of_slots;
    case (burst_type)
     REGULAR_BURST : begin
                       result[27:26] = coding_type;
                       result[24:22] = coding_rate;
                       result[21:20] = modulation_type;
                       result[19]    = interleaver_bypass;
                       result[18]    = scrambler_bypass;
                       result[17:16] = repetition;
                       result[15:13] = boosting;
                     end
     RANGING_BURST : begin
                       result[26:25] = ranging_method;
                       result[24:15] = cdma_seed;
                     end
     BH_BURST      : begin
                       result[27:26] = coding_type;
                       result[24:22] = coding_rate;
                       result[21:20] = modulation_type;
                       result[19]    = interleaver_bypass;
                       result[18]    = scrambler_bypass;
                       result[17:16] = repetition;
                       result[15:13] = boosting;
                      end
      default      : begin
                       `vmm_debug(log, $psprintf("Burst type = %s", burst_type.name));
                     end

    endcase
    val_words.push_back(result);
  endfunction
  
  virtual function string psdisplay (string prefix = "");
    if (parent_zone.current_zone == phy_zone::TX_ZONE) psdisplay = tx_psdisplay(prefix);
    else psdisplay = rx_psdisplay(prefix);
  endfunction

  virtual function string rx_psdisplay (string prefix = "");
     string result;
     result = { $psprintf("+++++++++++++++++++++++++++++++++++++++++++++++\n"),
                $psprintf("\t\t%s Burst#%0d\n", prefix, burst_index),
                $psprintf("+++++++++++++++++++++++++++++++++++++++++++++++\n"),
                $psprintf("burst_type        : %s\n", burst_type.name),
                $psprintf("coding_type       : %s\n", coding_type.name),
                $psprintf("cid               : 0x%x\n", cid),
                $psprintf("coding_rate       : 0x%0x\n", coding_rate),
                $psprintf("modulation_type   : %s\n", modulation_type.name),
                $psprintf("repetition        : 0x%0x\n", repetition),
                $psprintf("num_of_slots      : %0d\n", num_of_slots),
                $psprintf("HARQ_LLR_op       : %0d\n", harq_llr_operation),
                $psprintf("Ptr_llr_mem       : 0x%x\n", llr_address),
		$psprintf("num_bits_in_burst : 0x%x\n", num_of_bits_in_burst),
                $psprintf("+++++++++++++++++++++++++++++++++++++++++++++++\n")
               };
     foreach (colors[i]) begin
       string tmp_str;
       tmp_str.itoa(i);
       result = { result, colors[i].psdisplay(tmp_str) };
     end
     rx_psdisplay = result;
  endfunction

  virtual function string tx_psdisplay (string prefix = "");
     string result;
     if (burst_type == REGULAR_BURST || burst_type == BH_BURST) begin
       result = { $psprintf("+++++++++++++++++++++++++++++++++++++++++++++++\n"),
                  $psprintf("\t\t%s Burst#%0d\n", prefix, burst_index),
                  $psprintf("+++++++++++++++++++++++++++++++++++++++++++++++\n"),
                  $psprintf("burst_type        : %s\n", burst_type.name),
                  $psprintf("coding_type       : %s\n", coding_type.name),
                  $psprintf("modulation_type   : %s\n", modulation_type.name),
                  $psprintf("boosting          : %s\n", boosting.name),
                  $psprintf("coding_rate       : 0x%0x\n", coding_rate),
                  $psprintf("repetition        : 0x%0x\n", repetition),
                  $psprintf("interleave bypass : %b\n", interleaver_bypass),
                  $psprintf("scrambler bypass  : %b\n", interleaver_bypass),
                  $psprintf("num_of_slots      : %0d\n", num_of_slots),
		  $psprintf("num_bits_in_burst : 0x%x\n", num_of_bits_in_burst),
                  $psprintf("+++++++++++++++++++++++++++++++++++++++++++++++\n")
                 };
     end
     else begin
       result = { $psprintf("+++++++++++++++++++++++++++++++++++++++++++++++\n"),
                  $psprintf("\t\t%s Burst#%0d\n", prefix, burst_index),
                  $psprintf("+++++++++++++++++++++++++++++++++++++++++++++++\n"),
                  $psprintf("burst_type        : %s\n", burst_type.name),
                  $psprintf("num_of_slots      : %0d\n", num_of_slots),
                  $psprintf("+++++++++++++++++++++++++++++++++++++++++++++++\n")
                };

     end
     result = { result, $psprintf("Coloring commands:\n") };
     foreach (colors[i]) begin
       string tmp_str;
       tmp_str.itoa(i);
       result = { result, colors[i].psdisplay(tmp_str) };
     end
     tx_psdisplay = result;
  endfunction


  virtual function void get_color_words(ref bit [31:0] words[$]);
     bit [31:0] data;

    if (parent_zone.current_zone == phy_zone::TX_ZONE) begin
      for (int i=0; i<colors.size(); i=i+2) begin
        if (i == colors.size()-1) begin
          data = colors[i].get_color_val();
          words.push_back(data);
          return;
        end
        data = { colors[i+1].get_color_val(), colors[i].get_color_val() };
        words.push_back(data);
      end
    end else begin
      foreach (colors[i]) begin
        data [4:0] = colors[i].symbol_indx; 
        data [10:5] = colors[i].sub_chan_indx; 
        data [16:11] = colors[i].get_burst_index();
        words.push_back(data);
      end
    end
  endfunction

endclass






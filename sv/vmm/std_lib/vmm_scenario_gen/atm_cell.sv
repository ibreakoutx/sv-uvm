/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


class atm_cell extends vmm_data;

static  vmm_log log = new("atm_cell", "class");

   rand bit [ 3:0] gfc;
   rand bit [ 7:0] vpi;
   rand bit [15:0] vci;
   rand bit [ 2:0] pt;
   rand bit        clp;
   rand bit [ 7:0] hec;            
   rand bit [ 7:0] payload[48];
   
   constraint hec_valid {
      hec == 8'h00;
   }

   
   extern function new();
   
   extern virtual function string psdisplay(string prefix = "" );
    
   extern  virtual function bit is_valid(bit silent = 1 ,
                                         int kind = -1);
				  
   extern  virtual function vmm_data copy(vmm_data to = null);
    
   extern  virtual function bit compare(vmm_data   to,
                                        output string diff,
                                        input int kind =-1);
   
   extern  virtual function int unsigned byte_size(int kind=-1 );
    
   extern   virtual function int unsigned byte_pack(ref logic [7:0] bytes[],
                                                   input int unsigned offset  =0,
                                                   input int   kind=-1);
    
   extern virtual function int unsigned byte_unpack(ref logic [7:0] bytes[], 
                                                   input int unsigned offset=0,
                                                   input int len=-1, 
                                                   input int  kind=-1);
 
   extern  virtual function void save(int file);
   extern  virtual function bit load(int file);
   extern  virtual function bit[7:0] compute_hec();

endclass
 
 `vmm_channel(atm_cell)
 `vmm_scenario_gen(atm_cell, "ATM Cell")   
 
 function atm_cell::new();
 begin
 
    super.new(this.log);
    hec = 0;   // by default assume HEC is to be valid
 end			
 endfunction
 
 
 function bit atm_cell::is_valid(bit     silent = 1,
                                 int     kind   = -1);
    is_valid = 1;
 
    if (this.hec != 8'h00) 
    begin
       is_valid = 0;
 
       if (!silent) `vmm_warning(this.log, "HEC value is invalid");
       
       return is_valid;
    end	
    
 endfunction
 
 
 function string atm_cell::psdisplay(string prefix = "");
    int i;
 
    $write(psdisplay, "%sATM cell #%0d.%0d.%0d\n", prefix,this.stream_id, this.scenario_id, this.data_id);
    $write(psdisplay, "%s%s   gfc:0x%h  vpi:0x%h  vci:0x%h  pt:0x%h  clp:0b%b  hec:%0s\n", psdisplay, prefix,    gfc,      vpi,      vci,      pt,      clp, (hec) ? "BAD" : "good");
    $write(psdisplay, "%s%s   data:", psdisplay, prefix);
    for (i = 0; i < 4; i++) $write(psdisplay, "%s 0x%h", psdisplay, payload[i]);
    $write(psdisplay, "%s ..", psdisplay);
    for (i = 44; i < 48; i++) $write(psdisplay, "%s 0x%h", psdisplay, payload[i]);
    $write(psdisplay, "%s\n", psdisplay);
 endfunction
 
 
 function vmm_data atm_cell::copy(vmm_data to = null);
    atm_cell cpy;
 
    // Copying to a new instance?
    if (to == null) 
       cpy = new;
    else
 
    // Copying to an existing instance. Correct type?
    if (!$cast(cpy, to))    // upcast to -cpy
    begin
       `vmm_fatal(this.log, "Attempting to copy to a non atm_cell instance");
       copy = null;
       return copy;
    end
    
 
    super.copy_data(cpy);
    
    cpy.gfc = this.gfc;
    cpy.vpi = this.vpi;
    cpy.vci = this.vci;
    cpy.pt  = this.pt;
    cpy.clp = this.clp;
    cpy.hec = this.hec;
 
    foreach(payload[i])
    begin
       cpy.payload[i] = this.payload[i];
    end			
 
    copy = cpy;
 endfunction
 
 
 function bit atm_cell::compare(vmm_data   to,
                                output string diff,
                                input int   kind);
    atm_cell cmp;
 
    compare = 1; // Assume success by default.
    diff    = "No differences found";
    
    if (!$cast(cmp, to)) 
    begin
       `vmm_fatal(this.log, "Attempting to compare to a non atm_cell instance");
       compare = 0;
       diff = "Cannot compare non atm_cell to atm_cell";
       return compare;
    end 
 
    // data types are the same, do comparison:
    if (this.gfc != cmp.gfc) 
    begin
       diff = $psprintf("Different GFC values: %b != %b", this.gfc, cmp.gfc);
       compare = 0;
       return compare;
    end 
    if (this.vpi != cmp.vpi) 
    begin
       diff = $psprintf("Different VPI values: %h != %h", this.vpi, cmp.vpi);
       compare = 0;
       return compare;
    end 
    if (this.vci != cmp.vci) 
    begin
       diff = $psprintf("Different VCI values: %h != %h", this.vci, cmp.vci);
       compare = 0;
       return compare;
    end 
    if (this.pt != cmp.pt) 
    begin
       diff = $psprintf("Different PT values: %b != %b", this.pt, cmp.pt);
       compare = 0;
       return compare;
    end 
    if (this.clp != cmp.clp) 
    begin
       diff = $psprintf("Different CLP values: %b != %b", this.clp, cmp.clp);
       compare = 0;
       return compare;
    end 
    if (this.hec != cmp.hec) 
    begin
       diff = $psprintf("Different HEC values: %b != %b", this.hec, cmp.hec);
       compare = 0;
       return compare;
    end 
       
    foreach(payload[i]) 
       if (this.payload[i] != cmp.payload[i]) 
       begin
          diff = $psprintf("Different payload[%0d] values: 0x%h != 0x%h",
                          i, this.payload[i], cmp.payload[i]);
          compare = 0;
          return compare;
       end 
 endfunction
 
 
  function int unsigned atm_cell::byte_size(int kind);
    byte_size = 53;
  endfunction
 
 
 function int unsigned atm_cell::byte_pack( ref logic [7:0] bytes[],
                                   input int unsigned offset, 
                                   input int   kind);
    bit [7:0] hec;
 
    // Make sure there is enough room in the array
    if (bytes.size() < this.byte_size() + offset) 
    begin
       bytes = new [this.byte_size() + offset] (bytes);
    end 
 
    hec = compute_hec() ^ this.hec;
 
    // vera_pack()'s offset is in *bits*
    offset *= 8;
     
   bytes[0] = {gfc, vpi[7:4]};
   bytes[1] = {vpi[3:0], vci[15:12]};
   bytes[2] = {vci[11:4]};
   bytes[3] = {vci[3:0], pt, clp};
   bytes[4] = {hec};
   for (int i=0; i < 48; i++)
     bytes[i+5]=payload[i];
    byte_pack = 53;
 endfunction
 
 
 function int unsigned atm_cell::byte_unpack(ref logic [7:0] bytes[],
                                            input int  unsigned  offset, 
                                            input int len, 
                                            input int   kind);
    bit [7:0] hec;
 
    // Make sure there will be enough data to unpack
    if (bytes.size() < this.byte_size() + offset)
    begin
       bytes = new [this.byte_size() + offset] (bytes);
    end 
 
    // vera_unpack()'s offset is in *bits*
    offset *= 8;
    //bytes, offset, this.gfc, this.vpi, this.vci, this.pt, this.clp, this.hec, 
    //                   this.payload);
    
    this.hec = compute_hec() ^ hec;
 
    byte_unpack = 53;
endfunction 
 
 
 function void atm_cell::save(int file);
    bit [7:0] bytes[];
    int   i;
 	
		// Uncomment following after 
		// STAR 9000085991 is fixed

    //void'( this.byte_pack(bytes));

    foreach (bytes[i]) 
       $fwrite(file, "%x", bytes[i]);
    
    $fwrite(file, "\n");
endfunction 
 
 function bit atm_cell::load(int file);
    bit [7:0] bytes[];
    string line;
    int i;
    int j; 	
 
    j = $fgets(line, file);
    if (line.len( ) == null) 
    begin
       load = 0;
       return load;
    end 
    
    bytes = new [53];
    foreach (bytes[i]) 
    begin
       string image = line.substr(i * 2, i * 2 + 1);
       bytes[i] = image.atohex();
    end 

    // void'(this.byte_unpack(bytes));
    load = 1;
 endfunction 
 
 function bit[7:0] atm_cell::compute_hec();
    bit [31:0] crc;
    //
    // This ATM HEC computation is believed to be correct
    // but no ganrantee of correctness or fit for any use
    // is implied or offered
    //
    
    crc = {gfc,vpi,vci,pt,clp} % 9'b100000111;
    crc = crc ^ 8'b0101_0101;
    compute_hec = crc;
 endfunction
 

/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

//-----------------------------------------------------------------------------
//
// SYNOPSYS CONFIDENTIAL - This is an unpublished, proprietary work of
// Synopsys, Inc., and is fully protected under copyright and trade secret
// laws. You may not view, use, disclose, copy, or distribute this file or
// any information contained herein except pursuant to a valid written
// license from Synopsys.
//
//-----------------------------------------------------------------------------
//
// Filename    : $Id: apb_trans.sv,v 1.10 2005/11/05 19:32:36 alexw Exp $
//
// Created by  : Synopsys Inc. 09/01/2004
//               $Author: alexw $
//               Author: Alex Wakefield, Angshu Saha
//
// Description : AMBA Peripheral Bus Transaction
//
//               This is a vmm_data class for a APB transaction
//
//-----------------------------------------------------------------------------

class apb_trans extends vmm_data;

  static vmm_log log = new ("apb_trans", "class") ;
    
  // Local Data Members
  // Lab2 - Add an enumerated type here {READ, WRITE} dir_e
  // Lab2 - Add data members for addr, data and dir here.
  typedef enum {READ, WRITE} dir_e;                                      //LAB2
  rand reg [31:0] addr;                                                  //LAB2
  rand reg [31:0] data;                                                  //LAB2
  rand dir_e dir;                                                        //LAB2

  // Constructor
  extern function new();

  // VMM Standard Methods
  extern virtual function string   psdisplay(string prefix = "");
    
  extern virtual function vmm_data allocate ();
  extern virtual function vmm_data copy     (vmm_data to = null);
  extern virtual function void     copy_data(vmm_data to = null);
  extern virtual function bit      compare  (vmm_data to,
                                             output string diff,
                                             input int kind = -1);
    
  extern virtual function bit      is_valid (bit silent = 1,
                                             int kind = -1);
    
  extern virtual function int unsigned byte_size  (int kind = -1);
  extern virtual function int unsigned byte_pack  (ref logic [7:0] bytes[],
                                                   input int unsigned offset = 0,
                                                   input int  kind = -1);
  extern virtual function int unsigned byte_unpack(const ref logic [7:0] bytes[],
                                                   input int unsigned offset = 0,
                                                   input int len  = -1,
                                                   input int kind = -1);

  
endclass: apb_trans

//-----------------------------------------------------------------------------
// VMM Macros - Channel and Atomic Generator
//-----------------------------------------------------------------------------

`vmm_channel(apb_trans)
// port 0 will use extended genrator apb_gen, see dut._env.sv
// , port 1-6 wil use atomic generator, port 7 will use scenario generator 
`vmm_atomic_gen(apb_trans, "APB Atomic Gen")  // for ports 1-6
`vmm_scenario_gen(apb_trans, "APB Scenario Gen") // for generating on port 7



//-----------------------------------------------------------------------------
// new() - Constructor
//-----------------------------------------------------------------------------

function apb_trans::new();

  super.new(this.log);

endfunction: new

 //-----------------------------------------------------------------------------
// allocate() - VMM
//-----------------------------------------------------------------------------

function vmm_data apb_trans::allocate();

  // Allocate a new object of this type, and return a handle to it
  apb_trans i = new();
  allocate = i;
    
endfunction: allocate

//-----------------------------------------------------------------------------
// copy() - VMM
//-----------------------------------------------------------------------------

function vmm_data apb_trans::copy(vmm_data to);
    
  apb_trans cpy;

  // Allocate a new object if needed, check the type if 'to' specified
  if (to == null)
    cpy = new();
  else if (!$cast(cpy, to)) begin
    `vmm_error(this.log, "Cannot copy to non-apb_trans instance");
    copy = null;
    return copy;
  end

  // Copy the data fields into the 'to' object and return cpy
  copy_data(cpy);
  copy = cpy;
    
endfunction: copy

//-----------------------------------------------------------------------------
// copy_data() - VMM
//-----------------------------------------------------------------------------

function void apb_trans::copy_data(vmm_data to);

  apb_trans cpy;

  // Copy all the VMM base class data
  super.copy_data(to);

  if (!$cast(cpy, to)) begin
    `vmm_error(this.log, "Cannot copy to non-apb_trans instance");

  end

    
  // Lab2 - Add lines here to copy each data member.
  // Lab2 - cpy.addr = this.addr;
  cpy.addr = this.addr;                                                 //LAB2
  cpy.data = this.data;                                                 //LAB2
  cpy.dir  = this.dir;                                                  //LAB2
                                                                        //LAB2    
endfunction: copy_data

//-----------------------------------------------------------------------------
// compare - VMM
//-----------------------------------------------------------------------------

function bit apb_trans::compare(vmm_data   to,
                                output string diff,
                                input int  kind);
   apb_trans pkt;
   compare = 1;

   // Check the type is correct    
   if (to == null || !$cast(pkt, to)) begin
      `vmm_error(this.log, "Cannot compare to non-apb_trans instance");
      compare = 0;
     return compare;
     
   end

   if (pkt.dir !== this.dir) begin                         
     $sformat(diff, "dir (%s !== %s)",  this.dir, pkt.dir);
     compare = 0;                                              
   end                                                         
                                                               
   if (pkt.addr !== this.addr) begin                           
     $sformat(diff, "addr (%1b !== %1b)", this.addr, pkt.addr);
     compare = 0;                                              
   end                                                         
                                                               
   // Lab2 - Add a compare of the 'data' field below similar to 'addr' above
   if (pkt.data !== this.data) begin                                     //LAB2
     $sformat(diff, "data (%1b !== %1b)", this.data, pkt.data);          //LAB2
     compare = 0;                                                        //LAB2
   end                                                                   //LAB2
                                                                         //LAB2
endfunction: compare

//-----------------------------------------------------------------------------
// psdisplay() - VMM
//-----------------------------------------------------------------------------
    
function string apb_trans::psdisplay(string prefix);

  // Lab2 - Review the psdisplay() code below
  case (this.dir)                                                   
    READ:                                                                   
      $sformat(psdisplay, "%s#%0d.%0d.%0d : Read  Addr=0x%02X Data=0x%02X",
               prefix, this.stream_id, this.scenario_id, this.data_id,      
               this.addr, this.data);                                       
    WRITE:                                                                  
      $sformat(psdisplay, "%s#%0d.%0d.%0d : Write Addr=0x%02X Data=0x%02X",
               prefix, this.stream_id, this.scenario_id, this.data_id,      
               this.addr, this.data);                               
    default:                                                                
      $sformat(psdisplay, "%s#%0d.%0d.%0d : Unknown ---------------------",
               prefix, this.stream_id, this.scenario_id, this.data_id);
  endcase                                                                   
    
endfunction: psdisplay 

  
//-----------------------------------------------------------------------------
// is_valid() - VMM
//-----------------------------------------------------------------------------

function bit apb_trans::is_valid(bit silent,
                                 int kind);
    is_valid = 1;

endfunction: is_valid

//-----------------------------------------------------------------------------
// byte_size() - VMM
//-----------------------------------------------------------------------------

function int unsigned apb_trans::byte_size(int kind);

    // Lab2 - Review the byte_size() code below
    byte_size = 4;
    
endfunction: byte_size


//-----------------------------------------------------------------------------
// byte_pack() - VMM
//-----------------------------------------------------------------------------

function int unsigned apb_trans::byte_pack(ref logic [7:0]    bytes[],
                                             input int unsigned offset,
                                             input int          kind);

  // Lab2 - Reivew the bype_pack() code below
  bytes = new[offset +  byte_size()];
  bytes[offset]   = data[31:24];
  bytes[offset+1] = data[23:16];
  bytes[offset+2] = data[15: 8];
  bytes[offset+3] = data[ 7: 0];

  byte_pack = byte_size();     // Return the number of bytes packed
    
endfunction: byte_pack

//-----------------------------------------------------------------------------
// byte_unpack() - VMM
//-----------------------------------------------------------------------------

function int unsigned apb_trans::byte_unpack(const ref logic [7:0] bytes[],
                                             input int unsigned    offset,
                                             input int             len,
                                             input int             kind);
    
  // Lab2 - Review the byte_unpack() code below
  data = {bytes[offset], bytes[offset+1], bytes[offset+2], bytes[offset+3]};

  byte_unpack = byte_size();   // Return the number of bytes unpacked
    
endfunction: byte_unpack

    

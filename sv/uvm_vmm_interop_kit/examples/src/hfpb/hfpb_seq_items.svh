//----------------------------------------------------------------------
//   Copyright 2005-2007 Mentor Graphics Corporation
//   Copyright 2010 Synopsys Inc.
//
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

class hfpb_seq_item #(int DATA_SIZE=8, int ADDR_SIZE=16)
  extends uvm_sequence_item;

  typedef hfpb_seq_item #(DATA_SIZE, ADDR_SIZE) this_type;
  typedef hfpb_transaction #(DATA_SIZE, ADDR_SIZE) hfpb_tr_t;

  typedef uvm_object_registry#(this_type) type_id;

  rand bus_trans_t         bus_trans_type;
  rand bit[DATA_SIZE-1:0]  wdata;
       bit[DATA_SIZE-1:0]  rdata;
  rand bit[ADDR_SIZE-1:0]  addr;
  bit[2:0] slave_id;

  function new();
    default_transaction();
  endfunction

  static function type_id get_type();
    return type_id::get();
  endfunction

  function void default_transaction();
    bus_trans_type = IDLE;
    wdata = 0;
    rdata = 0;
    addr = 0;
    slave_id = 0;
  endfunction

  function uvm_object clone();
    this_type t = new;
    t.copy(this);
    return t;
  endfunction

  function hfpb_tr_t clone_tr();
    hfpb_tr_t t = new();
    t.wdata          = wdata;
    t.rdata          = rdata;
    t.addr           = addr;
    t.bus_trans_type = bus_trans_type;
    t.slave_id       = slave_id;
    return t;
  endfunction
  
  function void copy(input this_type t);
    wdata           = t.wdata;
    rdata           = t.rdata;
    addr            = t.addr;
    bus_trans_type  = t.bus_trans_type;
    slave_id        = t.slave_id;
  endfunction

  function void copy_tr(input hfpb_tr_t t);
    wdata           = t.wdata;
    rdata           = t.rdata;
    addr            = t.addr;
    bus_trans_type  = t.bus_trans_type;
    slave_id        = t.slave_id;
  endfunction

  function bit comp(input this_type t);
    return ((t.addr == addr) && 
            (t.rdata == rdata) && 
            (t.wdata == wdata) && 
            (t.bus_trans_type == bus_trans_type)); 
  endfunction
  
  function string convert2string;
    string s;
    $sformat(s, "slave%2d: %05s: addr=%04x wdata=%02x rdata=%02x", 
              slave_id, bus_trans_type.name(), addr, wdata, rdata);
    return s;
  endfunction

  function bit is_idle;
    return (bus_trans_type == IDLE);
  endfunction

  function bit is_write;
    return (bus_trans_type == WRITE);
  endfunction
    
  function bit is_read;
    return (bus_trans_type == READ);
  endfunction

  function void set_idle();
    bus_trans_type = IDLE;
  endfunction

  function void set_write();
    bus_trans_type = WRITE;
  endfunction

  function void set_read();
    bus_trans_type = READ;
  endfunction

  function void set_wdata(bit [DATA_SIZE-1:0] D);
    wdata = D;
  endfunction

  function void set_rdata(bit [DATA_SIZE-1:0] D);
    rdata = D;
  endfunction

  function void set_addr(bit [ADDR_SIZE-1:0] A);
    addr = A;
  endfunction

  function bit [DATA_SIZE-1:0] get_rdata();
    return rdata;
  endfunction

  function bit [DATA_SIZE-1:0] get_wdata();
    return wdata;
  endfunction

  function bit [ADDR_SIZE-1:0] get_addr();
    return addr;
  endfunction

  function bit [2:0] get_slave_id();
    return slave_id;
  endfunction

  function void set_slave_id(bit [2:0] id);
    slave_id = id;
  endfunction

endclass

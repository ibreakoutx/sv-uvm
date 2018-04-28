//----------------------------------------------------------------------
//   Copyright 2005-2007 Mentor Graphics Corporation
//   Copyright 2010 Synopsys Inc
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


//----------------------------------------------------------------------
// hfpb_driver
//----------------------------------------------------------------------
// begin codeblock header
class hfpb_driver #(int DATA_SIZE=8, int ADDR_SIZE=16)
  extends
    uvm_driver #(hfpb_seq_item #(DATA_SIZE, ADDR_SIZE),
                 hfpb_seq_item #(DATA_SIZE, ADDR_SIZE));
// end codeblock header

  typedef enum {
    INACTIVE, START, ACTIVE, ERROR
  } state_e;

  typedef bit [ADDR_SIZE-1:0] addr_t;

  local virtual hfpb_if #(DATA_SIZE, ADDR_SIZE) m_bus_if;

  local state_e m_state;

  local hfpb_seq_item #(DATA_SIZE, ADDR_SIZE) m_req;
  local hfpb_seq_item #(DATA_SIZE, ADDR_SIZE) m_rsp;

  local bit has_addr_map;
  hfpb_addr_map #(ADDR_SIZE) addr_map;

  // Generate cycle accurate bus controls for protocol

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build();

    hfpb_vif #(DATA_SIZE, ADDR_SIZE) vif;
    uvm_object dummy;

    has_addr_map = 0;
    if(get_config_object("addr_map", dummy, 0)) begin
      if(!$cast(addr_map, dummy))
        uvm_report_warning("build", "address map is incorrect type");
      else
        has_addr_map = 1;
    end
    else
      uvm_report_warning("build", "no address map specified");

    vif = null;
    if(!get_config_object("hfpb_vif", dummy, 0)) begin
      // get config_object is specifed to NOT do a clone
      uvm_report_error("build", "no virtual interface available");
    end
    else begin
      if(!$cast(vif, dummy)) begin
        uvm_report_error("build", "virtual interface is incorrect type");
      end
      else begin
        m_bus_if = vif.m_bus_if;
      end
    end

  endfunction  

  function void start_of_simulation();
    m_state = INACTIVE;
  endfunction  

  function void map(ref hfpb_seq_item #(DATA_SIZE, ADDR_SIZE) req);

    addr_t base_addr;
    addr_t addr;
    int slave_id;

    if(!has_addr_map)
      return;

    addr = req.get_addr();
    slave_id = addr_map.map(addr, base_addr);

    if(slave_id < 0) begin
      uvm_report_warning("mapper", "using default slave 0");
      slave_id = 0;
    end

    req.set_slave_id(slave_id);
    req.set_addr(addr - base_addr);

  endfunction

  task run();

    m_bus_if.master.en = 0;
    m_bus_if.master.sel = 0;

    forever begin  
      @(posedge m_bus_if.master.clk);
    
      $display("DRIVER: clk");
      
      if(m_bus_if.rst == 1) begin
        m_bus_if.master.en <= 0;
        m_bus_if.master.sel <= 0;
        m_state = INACTIVE;
        continue;
      end

      // $display("%0t: master: sel: %08b  en: %0b  wr: %0b",
      //          $time, m_bus_if.master.sel,
      //          m_bus_if.master.en, m_bus_if.master.write);

      // Conceptual state-machine to emulate bus protocol activity
      case(m_state)

        INACTIVE : begin

          // Get next transaction in the input stream
          seq_item_port.get(m_req);
          map(m_req);

          // If not idle, setup bus controls to transition to a START state

          if (m_req.is_idle()) begin
            m_bus_if.master.sel <= 0;
            m_state = INACTIVE;
            continue;
          end

          m_bus_if.master.en <= 0;
          m_bus_if.master.sel <= 1 << m_req.get_slave_id();
          m_state = START;

          m_bus_if.master.addr  <= m_req.get_addr() ;

          // Setup bus controls for write

          if (m_req.is_write()) begin
            m_bus_if.master.write <= 1;
            m_bus_if.master.wdata <= m_req.get_wdata() ;
          end
          else
            m_bus_if.master.write <= 0;

        end // INACTIVE

        START : begin

          // Setup bus controls to transition to an ACTIVE state

          // turn on the select bit that represents
          // the slave we want to talk to.
          m_bus_if.master.sel <= (1 << m_req.get_slave_id());
          m_bus_if.master.en <= 1;
          m_state = ACTIVE;

        end // START

        ACTIVE : begin

          // create the response as a clone of the request
          assert($cast(m_rsp, m_req.clone()));

          if (!m_req.is_write()) begin
            m_bus_if.master.write <= 0;
            m_rsp.set_rdata(m_bus_if.master.rdata);
          end

          // Setup bus controls to transition to an INACTIVE state

          m_bus_if.master.en <= 0;
          m_bus_if.master.sel <= 0;
          m_state = INACTIVE;

          m_rsp.set_id_info(m_req);
          seq_item_port.put(m_rsp);

        end // ACTIVE

      endcase

    end  

  endtask

endclass


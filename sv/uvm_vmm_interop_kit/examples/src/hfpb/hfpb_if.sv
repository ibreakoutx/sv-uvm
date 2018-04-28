//------------------------------------------------------------------------------
// Copyright 2010 Synopsys Inc.
//
// All Rights Reserved Worldwide
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License.  You may obtain
// a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
// License for the specific language governing permissions and limitations
// under the License.
//------------------------------------------------------------------------------

interface clk_rst;

  bit clk;
  bit rst;

endinterface

interface hfpb_if #(int DATA_SIZE = 8, int ADDR_SIZE = 16) (input bit clk, input bit rst);

  bit [7:0] sel;  // 8 slaves
  bit en;
  bit write;
  bit [ADDR_SIZE-1:0] addr;
  bit [DATA_SIZE-1:0] rdata;
  bit [DATA_SIZE-1:0] wdata;

  modport master(
    input clk,
    output sel,
    output en,
    output write,
    output addr,
    input rdata,
    output wdata
  );

  modport slave(
    input clk,
    input sel,
    input en,
    input write,
    input addr,
    output rdata,
    input wdata
  );

  modport monitor(
    input clk,
    input sel,
    input en,
    input write,
    input addr,
    input wdata,
    input rdata
  );

endinterface

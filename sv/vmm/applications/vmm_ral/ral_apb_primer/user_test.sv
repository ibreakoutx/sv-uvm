/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

// 
// -------------------------------------------------------------
//    Copyright 2004-2008 Synopsys, Inc.
//    All Rights Reserved Worldwide
// 
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
// 
//        http://www.apache.org/licenses/LICENSE-2.0
// 
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
// 


`include "tb_env.sv"

program test;

vmm_log log = new("User Defined", "Test");
tb_env env = new;

initial
begin
   bit [`VMM_RAL_DATA_WIDTH-1:0] reg_value;
   vmm_rw::status_e status;

   env.cfg_dut();

//    explicit write procedure after cfg_dut()
//    reading pre-configured registers with frontdoor access 

      `vmm_note(log, $psprintf("Registers were configured with..."));
      env.ral_model.CHIP_ID_CHIP_ID.read(status, reg_value);
      `vmm_note(log, $psprintf("CHIP ID was preconfigured to %0h", reg_value));
      env.ral_model.PRODUCT_ID.read(status, reg_value);
      `vmm_note(log, $psprintf("PRODUCT ID was preconfigured to %0h", reg_value));
      env.ral_model.REVISION_ID.read(status, reg_value);
      `vmm_note(log, $psprintf("REVISION ID was preconfigured to %0h", reg_value));

//    writing registers with frontdoor access

      env.ral_model.MODE.write(status, 3'h3);
      env.ral_model.TXEN.write(status, 1'h1);
      env.ral_model.MASK_READY.write(status, 1'h1);

//    reading registers with backdoor access

      env.ral_model.MODE.peek(status, reg_value);
      `vmm_note(log, $psprintf("Peek: STATUS Register has been written with MODE = %0h", reg_value));

      env.ral_model.TXEN.peek(status, reg_value);
      `vmm_note(log, $psprintf("Peek: STATUS Register has been written with TXEN = %0h", reg_value));

      env.ral_model.MASK_READY.peek(status, reg_value);
      `vmm_note(log, $psprintf("Peek: MASK Register has been written with READY = %0h", reg_value));

//   env.run_for = 10;   
   env.run();
end
endprogram

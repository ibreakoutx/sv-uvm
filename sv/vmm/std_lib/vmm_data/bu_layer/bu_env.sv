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
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from Synopsys Inc. In the event of publication,
// the following notice is applicable:
//
// (C) COPYRIGHT 2003 SYNOPSYS INC.  ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------
// Filename    : $Id: bu_env.sv,v 1.1.1.1 2009/04/24 14:14:01 fdelgust Exp $ $Author: fdelgust $ $DateTime$
//
// Created by  : Janick Bergeron, Synopsys Inc. 05/09/2001
//               $Author: fdelgust $
//
// Description : Base class for managing verification environment
//               run flow
//
// Usage       : 
//
// Notes       : 
//-----------------------------------------------------------------------------


class bu_env extends vmm_env ;

//   extern function new(string name = "Verif Env");
function new(string name) ;
   super.new(name);
endfunction

function void build() ;
   super.build();
endfunction


//    extern  task gen_cfg();
//    extern  task build();
    extern  task cfg_dut();
    extern  task start();
    extern  task wait_for_end();
    extern  task stop();
    extern  task cleanup();
    extern  task restart(bit reconfig = 0);
    extern  task report();

endclass

/*
function bu_env::new(string name) ;
   super.new(name);
endfunction

	
task bu_env::gen_cfg() ;
   super.gen_cfg();
endtask
*/
/*
task bu_env::build() ;
   super.build();
endtask
*/

task bu_env::cfg_dut() ;
   super.cfg_dut();
endtask


task bu_env::start() ;
   super.start();
endtask


task bu_env::wait_for_end() ;
   super.wait_for_end();
endtask


task bu_env::stop() ;
   super.stop();
endtask


task bu_env::cleanup() ;
   super.cleanup();
endtask


task bu_env::restart(bit reconfig) ;
   super.restart(reconfig);
endtask


task bu_env::report() ;
   super.report();
endtask

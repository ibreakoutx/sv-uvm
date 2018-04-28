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
// Filename    : $Id: bu_xactor.sv,v 1.1.1.1 2009/04/24 14:14:01 fdelgust Exp $ $Author: fdelgust $ $DateTime$
//
// Created by  : Janick Bergeron, Synopsys Inc. 05/09/2001
//               $Author: fdelgust $
//
// Description : Base class for transactors
//
// Usage       : 
//
// Notes       : 
//-----------------------------------------------------------------------------
class bu_xactor extends vmm_xactor ;

  function new(string  name,
            string  instance,
            int stream_id = -1);
   super.new(name,instance,stream_id);
   endfunction



//   extern  task start_xactor();
//   extern  task stop_xactor();
   extern function void start_xactor();
   extern function void stop_xactor();
   extern function void reset_xactor(reset_e rst_typ = SOFT_RST);
   extern function void xactor_status(string prefix = "");

//   extern virtual task reset_xactor(int rst_typ = 0);

//   extern  task xactor_status(string prefix = "");

   extern  task main();

endclass


/*
function bu_xactor::new(string  name,
                     string  instance,
                     int id ) ;
   super.new(name, instance, id);
endfunction */

/*
task bu_xactor::start_xactor() ;
   super.start_xactor();
endtask
*/
function void bu_xactor::start_xactor();
   super.start_xactor();
endfunction

/*
task bu_xactor::stop_xactor() ;
   super.stop_xactor();
endtask
*/
function void bu_xactor::stop_xactor();
   super.stop_xactor();
endfunction

/*
task bu_xactor::reset_xactor(int rst_typ) ;
   super.reset_xactor(rst_typ);
endtask
*/
function void bu_xactor::reset_xactor(reset_e rst_typ );
   super.reset_xactor(rst_typ);
endfunction
  

/*
task bu_xactor::xactor_status(string prefix) ;
   super.xactor_status(prefix);
endtask
*/
function void bu_xactor::xactor_status(string prefix);
   super.xactor_status(prefix);
endfunction

task bu_xactor::main() ;
   super.main();
endtask

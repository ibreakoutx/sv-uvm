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
// Filename    : $Id: bu_data.sv,v 1.1.1.1 2009/04/24 14:14:01 fdelgust Exp $
//
// Created by  : Janick Bergeron, Synopsys Inc. 05/09/2001
//               $Author: fdelgust $
//
// Description : Business-unit base class for all data and transaction
//               descriptor objects
//
// Usage       : 
//
// Notes       : 
//-----------------------------------------------------------------------------


class bu_data extends vmm_data ;

   extern function new(vmm_log log);
   
   extern  task display(string prefix = "");
   extern  function string psdisplay(string prefix = "");

   extern  function bit is_valid(bit     silent = 1,
                          int kind   = -1);

   extern  function vmm_data allocate();
   extern  function vmm_data copy(vmm_data to = null);
   
   extern  function bit compare(input vmm_data   to,
				output string diff,
                                input int  kind = -1); //,
																														//	ref string diff);

   extern  function int unsigned byte_size(int kind = -1);

   extern  function int unsigned byte_pack (ref logic [7:0] bytes[],
					input int unsigned offset=0 ,
                                 	input int  kind = -1);

/*;(int       offset = 0,
                               int       kind   = -1,
	         																													ref bit [7:0] bytes[*]);*/

   /*extern  function int unsigned byte_unpack(const ref logic [7:0] bytes[*],
                                    input int unsigned offset = 0,
				    input int len = -1, 	
                                    input int   kind   = -1); */
/*
extern function int byte_unpack(bit [7:0] bytes[*],
                                        int   offset = 0,
                                        int   kind   = -1);
*/

   extern  function bit load(int file);
//   extern  task save(int file);
   extern function void save(int file);
endclass
   

function bu_data::new(vmm_log log);
   super.new(log);
endfunction


task bu_data::display(string prefix ) ;
   super.display(prefix);
endtask


function string bu_data::psdisplay(string prefix );
   psdisplay = super.psdisplay(prefix);
endfunction


function bit bu_data::is_valid(bit     silent ,
                                int kind  );
   is_valid = super.is_valid(silent, kind);
endfunction


function vmm_data bu_data::copy(vmm_data to ) ;
   if (to == null) 
					begin
      //error("bu_data::copy() cannot copy to new instance");
      //return;
  end 
   super.copy_data(to);
   copy = to;
endfunction


function vmm_data bu_data::allocate() ;
   //error("The allocate() method of a bu_data derivative has not be implemented\n");
   allocate = null;
endfunction


function bit bu_data::compare(input vmm_data   to,
			      output string diff,  	
                              input int    kind); //,
   //                           ref string diff) ;
   //error("The compare() method of a bu_data derivative has not be implemented\n");
   compare = 0;
endfunction


function int unsigned bu_data::byte_size(int kind );
   //error("The byte_size() method of a bu_data derivative has not be implemented\n");
   byte_size = 0;
endfunction


function int unsigned bu_data::byte_pack( ref logic [7:0] bytes[],
					input int unsigned offset  ,
                                 	input int    kind ); //  ,
				 //ref bit [7:0] bytes[*]) ;
   //error("The bu_data::byte_pack() method has not be implemented in a derivative\n");

   byte_pack = 0;
endfunction

/*
function int unsigned bu_data::byte_unpack(const ref logic [7:0] bytes[*],
                                    input int unsigned offset,
				    input int len, 	
                                    input int   kind); 
	  bit [7:0] bytes[*],
            int   offset,
            int   kind ) ; 
   //error("The bu_data::byte_unpack() method has not be implemented in a derivative\n");
   
   byte_unpack = 0;
endfunction
*/

/*task bu_data::save(int file) ;
   //error("The bu_data::save() method has not be implemented in a derivative\n");
   
endtask
*/
function void bu_data::save(int file);
   //error("The bu_data::save() method has not be implemented in a derivative\n");
endfunction


function bit bu_data::load(int file) ;
   //error("The bu_data::load() method has not be implemented in a derivative\n");
   load = 0;
   
endfunction

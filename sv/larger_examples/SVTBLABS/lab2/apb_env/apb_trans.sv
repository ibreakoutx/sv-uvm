/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

/***************************************************************************
 *
 * File:        $RCSfile: apb_trans.sv,v $
 * Revision:    $Revision: 1.5 $  
 * Date:        $Date: 2003/07/02 15:47:08 $
 *
 *******************************************************************************
 *
 * APB Transaction Structure
 *
 *******************************************************************************
 */

class apb_trans;
// LAB: Create a random address, data, and transaction, 
// using data types defined in hdl/root.v


  task display(string prefix);
// LAB: Display the time, transaction's type, address, and data field
  endtask: display


  function apb_trans copy();
// LAB: Construct a new() apb_trans and fill it with this's information
// Don't forget to return the handle
  endfunction: copy
    
endclass

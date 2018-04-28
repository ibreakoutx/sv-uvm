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
 * File:        $RCSfile: apb_master.sv,v $
 * Revision:    $Revision: 1.8 $  
 * Date:        $Date: 2003/07/15 15:18:31 $
 *
 *******************************************************************************
 *
 * Basic Transaction Verification Module aimed at
 * creating read() and write() transactions based
 * on APB management Interface
 *
 *******************************************************************************
 */


`define APB_MASTER_IF	apb_master_if.master_cb
  
class apb_master;

    // APB Interface (Master side)
    virtual apb_if.Master apb_master_if;

    // APB Transaction mailboxes
    mailbox gen2mas, mas2scb;

    // Verbosity level
    bit verbose;
  
    // Constructor
    function new(virtual apb_if.Master apb_master_if, 
                 mailbox gen2mas, mas2scb,
                 bit verbose=0);

      this.gen2mas       = gen2mas;
      this.mas2scb       = mas2scb;
      this.apb_master_if = apb_master_if;
      this.verbose       = verbose;
    endfunction: new
    
    // Main daemon. Runs forever to switch APB transaction to
    // corresponding read/write/idle command
    task main();
       apb_trans tr;

       if(verbose)
         $display($time, ": Starting apb_master");

       forever begin
        // Wait & get a transaction
        gen2mas.get(tr);
  
        // Decide what to do now with the incoming transaction
        case (tr.transaction)
          // Read cycle
          READ:
            read(tr);

          // Write cycle
          WRITE:
            write(tr);

          // Idle cycle
          default:
            idle();
        endcase

        if(verbose)
          tr.display("Master");
      end

       if(verbose)
         $display($time, ": Ending apb_master");

    endtask: main


    // Reset the DUT then go to active mode
    task reset();
      `APB_MASTER_IF.Rst <= 0;
      idle();
      ##5 `APB_MASTER_IF.Rst <= 1;
   endtask: reset


    // Put the APB Bus in idle mode
    task idle();
      `APB_MASTER_IF.PAddr   <= 0;
      `APB_MASTER_IF.PSel    <= 0;
      `APB_MASTER_IF.PWData  <= 0;
      `APB_MASTER_IF.PEnable <= 0;
      `APB_MASTER_IF.PWrite  <= 0;
      ##1 `APB_MASTER_IF.PWrite  <= 0;
   endtask: idle


   // Implementation of the read() method
   //    - drives the address bus,
   //    - select the  bus,
   //    - assert Penable signal,
   //    - read the data and return it.
   task read(apb_trans tr);
     // Drive Control bus
     `APB_MASTER_IF.PAddr  <= tr.addr;
     `APB_MASTER_IF.PWrite <= 1'b0;
     `APB_MASTER_IF.PSel   <= 1'b1;

     // Assert Penable
     ##1 `APB_MASTER_IF.PEnable <= 1'b1;

     // Deassert Penable & return the read data
     ##1 `APB_MASTER_IF.PEnable <= 1'b0;
     tr.data = `APB_MASTER_IF.PRData;
     mas2scb.put(tr);
  endtask: read
        

  // Perform a write cycle
   //    - Drive the address bus,
   //    - Select the  bus,
   //    - Drive data bus
   //    - Assert Penable signal,
  task  write(apb_trans tr);
     // Drive Control bus
     `APB_MASTER_IF.PAddr  <= tr.addr;
     `APB_MASTER_IF.PWData <= tr.data;
     `APB_MASTER_IF.PWrite <= 1'b1;
     `APB_MASTER_IF.PSel   <= 1'b1;

     // Assert Penable
     ##1 `APB_MASTER_IF.PEnable <= 1'b1;

     // Deassert it
     ##1 `APB_MASTER_IF.PEnable <= 1'b0;
     mas2scb.put(tr);
  endtask: write

endclass: apb_master

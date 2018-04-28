/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



`ifndef APB_IF__SV
`define APB_IF__SV

interface apb_if(input bit pclk);
   wire [31:0] paddr;
   wire        psel;
   wire        penable;
   wire        pwrite;
   wire [31:0] prdata;
   wire [31:0] pwdata;

   clocking mck @(posedge pclk);
      output paddr, psel, penable, pwrite, pwdata;
      input  prdata;

      sequence at_posedge;
         1;
      endsequence : at_posedge
   endclocking: mck

   clocking sck @(posedge pclk);
      input  paddr, psel, penable, pwrite, pwdata;
      output prdata;

      sequence at_posedge;
         1;
      endsequence : at_posedge
   endclocking: sck

   clocking pck @(posedge pclk);
      input paddr, psel, penable, pwrite, prdata, pwdata;
   endclocking: pck

   modport master(clocking mck);
   modport slave(clocking sck);
   modport passive(clocking pck);

endinterface: apb_if

`endif

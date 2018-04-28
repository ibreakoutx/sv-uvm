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
// ATM cell functional coverage model
//

class atm_cover ;

   protected atm_cell cell;
   protected event cover_it;

   covergroup atm_header @ (this.cover_it);
//      coverage_event = sync(ALL, this.cover_it) async;

     GFC: coverpoint  cell.gfc;
     VPI: coverpoint  cell.vpi {
         bins zero= {8'h00};
         bins ones= {8'hFF};
         wildcard bins walk1_0 = {8'bxxxxxxx1} iff (cell.vpi != 8'hFF);
         wildcard bins walk1_1 = {8'bxxxxxx1x} iff (cell.vpi != 8'hFF);
         wildcard bins walk1_2 = {8'bxxxxx1xx} iff (cell.vpi != 8'hFF);
         wildcard bins walk1_3 = {8'bxxxx1xxx} iff (cell.vpi != 8'hFF);
         wildcard bins walk1_4 = {8'bxxx1xxxx} iff (cell.vpi != 8'hFF);
         wildcard bins walk1_5 = {8'bxx1xxxxx} iff (cell.vpi != 8'hFF);
         wildcard bins walk1_6 = {8'bx1xxxxxx} iff (cell.vpi != 8'hFF);
         wildcard bins walk1_7 = {8'b1xxxxxxx} iff (cell.vpi != 8'hFF);

         wildcard bins walk0_0 = {8'bxxxxxxx0} iff (cell.vpi != 8'h00);
         wildcard bins walk0_1 = {8'bxxxxxx0x} iff (cell.vpi != 8'h00);
         wildcard bins walk0_2 = {8'bxxxxx0xx} iff (cell.vpi != 8'h00);
         wildcard bins walk0_3 = {8'bxxxx0xxx} iff (cell.vpi != 8'h00);
         wildcard bins walk0_4 = {8'bxxx0xxxx} iff (cell.vpi != 8'h00);
         wildcard bins walk0_5 = {8'bxx0xxxxx} iff (cell.vpi != 8'h00);
         wildcard bins walk0_6 = {8'bx0xxxxxx} iff (cell.vpi != 8'h00);
         wildcard bins walk0_7 = {8'b0xxxxxxx} iff (cell.vpi != 8'h00);
      }
     CLP:coverpoint  cell.clp;
     PT :coverpoint  cell.pt;
     HEC:coverpoint  cell.hec {
         bins good = {0};
         bins bad ={[1:255]};

         wildcard bins walk1_0 = {8'bxxxxxxx1};
         wildcard bins walk1_1 = {8'bxxxxxx1x};
         wildcard bins walk1_2 = {8'bxxxxx1xx};
         wildcard bins walk1_3 = {8'bxxxx1xxx};
         wildcard bins walk1_4 = {8'bxxx1xxxx};
         wildcard bins walk1_5 = {8'bxx1xxxxx};
         wildcard bins walk1_6 = {8'bx1xxxxxx};
         wildcard bins walk1_7 = {8'b1xxxxxxx};
      }
   endgroup

   task cover_task(atm_cell cell);
      this.cell = cell;
      -> this.cover_it;
endtask

endclass

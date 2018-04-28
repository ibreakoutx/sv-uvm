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
// Simple dropbox design to pass messages between two physical interfaces.
// Used as an example to illustrate the multiple domain and base address
// configurability of RAL
//
// Left-side memory map:
//
//     CFG(0x0): Left-side base address (laddr[15:9]) (write-once)
//
//     laddr(0x000): Right-size base address (raddr[15:9]) (write-once)
//     laddr(0x001): RW register
//     laddr(0x002): WO register
//     laddr(0x003-0x005): Wide RW register (little endian)
//     laddr(0x006): RO/W1C/RC register
//     laddr(0x008): RW[0] register
//     laddr(0x009): RW[1] register
//     laddr(0x00A): RW[2] register
//     laddr(0x00B): RW[3] register
//     laddr(0x00C): RO register
//     laddr(0x010): Shared RW register
//     laddr(0x011): Shared RW register (write-only)
//     laddr(0x1--): RW memory
//     laddr(0x2--): Shared RW memory
//     laddr(0x3--): Shared RW memory (write-only)
//
// Right-side memory map:
//
//     raddr(0x001): RW register
//     raddr(0x002): WO register
//     raddr(0x010): Shared RW register
//     raddr(0x011): Shared RW register (read-only)
//     raddr(0x1--): RW memory
//     raddr(0x2--): Shared RW memory
//     raddr(0x3--): Shared RW memory (read-only)
//
//

`ifndef DROPBOX__SV
`define DROPBOX__SV

module dropbox(
  // Left side interface
  input        lcfg,   // In-band device configuration
  input        ls,     // Device select
  input [15:0] laddr,  // Address
  inout [15:0] ldata,  // R/W data
  input        lrd,    // Read strobe
  input        lwr,    // Write strobe

  // Right side interface
  input        rs,     // Device select
  input [15:0] raddr,  // Address
  inout [15:0] rdata,  // R/W data
  input        rrd,    // Read strobe
  input        rwr,    // Write strobe

  input        clk, rst);


//
// Architectural registers and memories
//
reg [15:10] lbase, rbase;
reg         lb_set, rb_set;
reg [ 7: 0] lrw_reg, rrw_reg, rw_reg[4];
reg [47: 0] lrw_wide;
reg [ 7: 0] lwo_reg, rwo_reg;
reg [ 1: 0] ro_bits, w1c_bits, rc_bits;
reg [ 7: 0] srw_reg0;
reg [ 7: 0] srw_reg1;
reg [15: 0] lrw_mem [256], rrw_mem[256];
reg [15: 0] srw_mem0 [256];
reg [15: 0] srw_mem1 [256];


always @ (posedge clk)
begin
   if (rst) begin
      lbase = '0; lb_set = 0;
      rbase = '0; rb_set = 0;
      lrw_reg = '0;
      rrw_reg = '0;
      lrw_wide = 48'hFEDC_BA98_7654;
      rw_reg[0] = '0;
      rw_reg[1] = '0;
      rw_reg[2] = '0;
      rw_reg[3] = '0;
      lwo_reg = '0;
      rwo_reg = '0;
      srw_reg0 = '0;
      srw_reg1 = '0;
      ro_bits  = 2'b10;
      w1c_bits = 2'b10;
      rc_bits  = 2'b10;
   end
end


//
// Left-side read cycles
//
reg [15:0] lrdat;
assign ldata = lrdat;
assign sel = lrd & ls;

always
begin
   lrdat = 'z;
   wait (sel === 1'b1);

   if (lcfg) begin
      // Configuration cycle
      case (laddr[7:0])
        8'h00: lrdat = lbase;
      endcase
   end
   else if (laddr[15:10] == lbase) begin
      // Normal cycle
      casez (laddr[9:0])
        10'h000: lrdat = rbase;
        10'h001: lrdat = lrw_reg;
        10'h002: lrdat = '0;
        10'h003: lrdat = lrw_wide[15: 0];
        10'h004: lrdat = lrw_wide[31:16];
        10'h005: lrdat = lrw_wide[47:32];
        10'h006: begin
           lrdat = {ro_bits, w1c_bits, rc_bits};
           rc_bits = 2'b00;
        end
        10'h008: lrdat = rw_reg[0];
        10'h009: lrdat = rw_reg[1];
        10'h00A: lrdat = rw_reg[2];
        10'h00B: lrdat = rw_reg[3];
        10'h00C: lrdat = 8'h5C;
        10'h010: lrdat = srw_reg0;
        10'h011: lrdat = '0;
        10'h1??: lrdat = lrw_mem[laddr[7:0]];
        10'h2??: lrdat = srw_mem0[laddr[7:0]];
        10'h3??: lrdat = '0;
      endcase
   end

   wait (sel !== 1'b1);
end


//
// Left-side write cycles
//
always
begin
   wait ((lwr & ls) === 1'b1);
   wait ((lwr & ls) === 1'b0);

   if (lcfg) begin
      // Configuration cycle
      case (laddr[7:0])
        8'h00: begin
           if (!lb_set) lbase = ldata;
           lb_set = 1;
        end
      endcase
   end
   else if (laddr[15:10] == lbase) begin
      // Normal cycle
      casez (laddr[9:0])
        10'h000: begin
           if (!rb_set) rbase = ldata;
           rb_set = 1;
        end
        10'h001: lrw_reg = ldata;
        10'h002: lwo_reg = ldata;
        10'h003: lrw_wide[15: 0] = ldata;
        10'h004: lrw_wide[31:16] = ldata;
        10'h005: lrw_wide[47:32] = ldata;
        10'h006: w1c_bits &= ~ldata[3:2];
        10'h008: rw_reg[0] = ldata;
        10'h009: rw_reg[1] = ldata;
        10'h00A: rw_reg[2] = ldata;
        10'h00B: rw_reg[3] = ldata;
        10'h010: srw_reg0 = ldata;
        10'h011: srw_reg1 = ldata;
        10'h1??: begin
           lrw_mem[laddr[7:0]] = ldata;
           $write("DUT: Wrote %h to lrw_mem[%0d]\n", ldata, laddr[7:0]);
        end
        10'h2??: srw_mem0[laddr[7:0]] = ldata;
        10'h3??: srw_mem1[laddr[7:0]] = ldata;
      endcase
   end
end

//
// Right-side read cycles
//
reg [15:0] rrdat;
assign rdata = rrdat;

always
begin
   rrdat = 'z;
   wait ((rrd & rs) === 1'b1);
   //@(posedge (rrd && rs));

   if (raddr[15:10] == rbase) begin
      casez (raddr[9:0])
        10'h001: rrdat = rrw_reg;
        10'h002: rrdat = '0;
        10'h040: rrdat = srw_reg0;
        10'h041: rrdat = srw_reg1;
        10'h1??: rrdat = srw_mem0[raddr[7:0]];
        10'h2??: rrdat = srw_mem1[raddr[7:0]];
        10'h3??: rrdat = rrw_mem[raddr[7:0]];
      endcase
   end

   wait ((rrd & rs) === 1'b0);
   //@(negedge (rrd && rs));
end


//
// Right-side write cycles
//
always
begin
   @(negedge (rwr && rs));

   if (raddr[15:10] == rbase) begin
      casez (raddr[9:0])
        10'h001: rrw_reg = rdata;
        10'h002: rwo_reg = rdata;
        10'h040: srw_reg0 = rdata;
        10'h1??: srw_mem0[raddr[7:0]] = rdata;
        10'h3??: rrw_mem[raddr[7:0]] = rdata;
      endcase
   end
end

endmodule

`endif

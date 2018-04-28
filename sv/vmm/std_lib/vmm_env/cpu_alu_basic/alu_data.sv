/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


class alu_data extends vmm_data;
   typedef enum bit [2:0] {ADD=3'b000, SUB=3'b001, MUL=3'b010, LS=3'b011, RS=3'b100} kind_t;
   rand kind_t kind;
   rand bit [3:0] a, b;
   rand bit [6:0] y;

   //constraint cst_user;

   static vmm_log log = new("alu_data", "class");

   extern function new();
   extern virtual function void display(string prefix=""); 
   extern virtual function vmm_data allocate();
   extern virtual function vmm_data copy(vmm_data to=null );
   extern virtual function bit compare(vmm_data to, output string diff, input int kind=-1 );
   extern virtual function string psdisplay(string prefix="" ); 
endclass

`vmm_channel(alu_data)
`vmm_atomic_gen(alu_data, "AluGen")
`vmm_scenario_gen(alu_data, "AluScnGen")

function alu_data::new(); 
  super.new(this.log);
endfunction

function vmm_data alu_data::allocate();
   alu_data tr = new;
   allocate = tr;
endfunction
   
function void alu_data::display(string prefix = ""); 
  $display("%s", this.psdisplay(prefix));
endfunction

function string alu_data::psdisplay(string prefix = ""); 
  psdisplay = $psprintf("%s:%s a=%x b=%x y=%x", prefix, this.kind.name, this.a, this.b, this.y);
endfunction

function vmm_data alu_data::copy (vmm_data to = null);
   alu_data data = null;
   if (to == null) begin
       data = new();
   end else if (!$cast(data,to)) begin
        `vmm_fatal(this.log, "Attempting to copy a non-alu_data instance");
        copy = null;
        return copy;
    end
    super.copy_data(data);
    data.kind = this.kind;
    data.a    = this.a;
    data.b    = this.b;
    return(data);
endfunction

function bit alu_data::compare (vmm_data to, output string diff, input int kind = -1);
   alu_data tr;
   diff = "";
   if (!$cast(tr, to)) begin
      diff = "Not a alu_data instance";
      compare = 0;
      if (!compare) diff = "Difference found";
      return compare;
   end
   //compare = this.object_compare(tr);
   compare = 1;
   //`vmm_warning(log, "COMPARE NYI IN alu_data class");
endfunction




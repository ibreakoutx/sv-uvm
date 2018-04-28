/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class Packet extends vmm_data;
 // static vmm_log log = new("Packet", "class");
  rand int      sa, da;
  rand bit[7:0] payload[];

  constraint valid {
    sa inside { [0:15] };
    da inside { [0:15] };
    payload.size inside { [1:32] };
  }


  `vmm_data_member_begin(Packet)
    `vmm_data_member_scalar (sa,DO_ALL)
    `vmm_data_member_scalar (da,DO_ALL)
    `vmm_data_member_scalar_array (payload,DO_ALL)
  `vmm_data_member_end(Packet)

  virtual function bit do_compare(input vmm_data to, output string diff, input int kind = -1);
    Packet pkt;
    if(to == null) begin
      diff = "***No Target Compare Object!!!***";
      return(0);
    end
    if($cast(pkt, to)) begin
      if (this.payload.size() != pkt.payload.size()) begin
        diff = "***Mismatching Payload Size!!!***";
        return(0);
      end
      foreach(this.payload[i]) begin
        if (this.payload[i] == pkt.payload[i]) begin end
        else begin
          diff = "***Mismatching Payload Content!!!***";
          return(0);
        end
      end
      diff = "Successful Compare";
      return(1);
    end
    diff = "***Not Object of the same Class!!!***";
    return(0);
  endfunction

  virtual function int unsigned do_byte_unpack (const ref logic [7:0] bytes[],
                input int unsigned  offset = 0,
                input int len = -1,
                input int kind = -1 );
   integer i;
   integer j;

   i = offset;
   for (j=0; j<4; j++) begin
    $display ("assigning byte[%0d] to sa[%0d]",i+j,j);
    this.sa[j] = bytes[i+j];
                       end
   for (j=0; j<4; j++) begin
     $display ("assigning byte[%0d] to da[%0d] ",i+j+4,j);
     this.da[j] = bytes[i+j+4];
                       end
   $display ("array size is %0d bytes ",bytes.size());
   this.payload = new[bytes.size() - 8];
   for (j=8; j<bytes.size(); j++) begin
     $display ("assigning byte[%0d] to payload[%0d] ",i+j, j-8);
     this.payload[j-8] = bytes[i+j];
                                  end
   return (1);
  endfunction

endclass

`vmm_channel(Packet)
`vmm_atomic_gen(Packet, "Packet Gen")


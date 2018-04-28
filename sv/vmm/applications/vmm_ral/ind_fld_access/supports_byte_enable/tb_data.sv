/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/





class tb_data extends vmm_data;

  typedef enum bit {READ=1'b0, WRITE=1'b1} kind_e;
  rand bit [7:0] addr;
  rand bit [1:0] byte_en;
  rand bit [15:0] data;
  rand kind_e  kind;

  static vmm_log log = new("tb_data", "class");

  function new();
    super.new(log);
  endfunction

  virtual function string psdisplay(string prefix = "");
    psdisplay = $psprintf("%s %s, addr=0x%x, data=0x%x, byte_en=0x%x", prefix, kind.name, addr, data, byte_en);
  endfunction

  virtual function vmm_data allocate();
     tb_data tr = new;
     allocate = tr;
  endfunction

endclass
`vmm_channel(tb_data)

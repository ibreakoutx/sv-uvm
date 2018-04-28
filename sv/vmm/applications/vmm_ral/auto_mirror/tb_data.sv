

class tb_data extends vmm_data;

  typedef enum bit {READ=1'b0, WRITE=1'b1} kind_e;
  rand bit [7:0] addr;
  rand bit [7:0] data;
  rand kind_e  kind;

  static vmm_log log = new("tb_data", "class");

  function new();
    super.new(log);
  endfunction

  virtual function string psdisplay(string prefix = "");
    psdisplay = $psprintf("%s %s, addr=0x%x, data=0x%x", prefix, kind.name, addr, data);
  endfunction

  virtual function vmm_data allocate();
     tb_data tr = new;
     allocate = tr;
  endfunction

endclass
`vmm_channel(tb_data)

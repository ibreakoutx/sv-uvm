UVM_TESTNAME = test_read_modify_write
 
all: clean comp run 

clean:
	rm -rf simv* csrc vcdplus.vpd urgReport tr.log ucli.key vc_hdrs.h DVEfiles

comp: clean 
	vcs -sverilog -timescale=1ns/1ns -debug_all +define+UVM_TR_RECORD -ntb_opts uvm +incdir+../sv xbus_tb_top.sv -l comp.log -lca

run:
	simv +UVM_TESTNAME=$(UVM_TESTNAME) -l simv.log



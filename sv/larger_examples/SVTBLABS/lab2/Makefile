FILES = hdl/root.v hdl/top.v hdl/mem.v apb_env/apb_if.sv
IFILES = apb_env/apb_gen.sv apb_env/apb_master.sv apb_env/apb_trans.sv
FLAGS = -sverilog -debug_all +incdir+apb_env


test: 	tests/test.sv ${FILES} ${IFILES}	
	vcs -R ${FLAGS} ${FILES} tests/test.sv


clean: 	
	@rm -rf csrc simv* *.tcl *.vpd .res* ucli* .ucli* *.old *.txt *.db 
	@rm -rf *.log *~ */*~ .*/*~ .*/*/*~


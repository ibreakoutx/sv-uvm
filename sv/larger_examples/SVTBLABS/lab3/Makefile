FILES = hdl/root.v hdl/top.v hdl/mem.v apb_env/apb_if.sv
IFILES = env/scoreboard.sv env/env.sv apb_env/apb_gen.sv \
	apb_env/apb_master.sv apb_env/apb_monitor.sv apb_env/apb_trans.sv
FLAGS = -sverilog -debug_all +incdir+env+apb_env+env


run: 	tests/test.sv ${FILES} ${IFILES}	
	vcs -R ${FLAGS} ${FILES} tests/test.sv

DIR = $(shell basename `pwd`)
tar:	clean
	cd ..;tar cvfz ${DIR}.tgz ${DIR}
	@ls -l ../${DIR}.tgz

clean: 	
	@rm -rf csrc simv* *.tcl *.vpd .res* ucli* .ucli* *.old *.txt *.db 
	@rm -rf *.log *~ */*~ .*/*~ .*/*/*~


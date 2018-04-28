FILES = hdl/root.v hdl/top.v hdl/mem.v apb_env/apb_if.sv
IFILES = env/scoreboard.sv env/env.sv apb_env/apb_gen.sv \
	apb_env/apb_master.sv apb_env/apb_monitor.sv apb_env/apb_trans.sv
FLAGS = -sverilog -debug_all +incdir+env+apb_env


00 debug: 	tests/test_00_debug.sv ${FILES} ${IFILES}	
	@echo "Running debug test"
	vcs -R ${FLAGS} ${FILES} tests/test_00_debug.sv

01 directed:	tests/test_01_directed.sv ${FILES} ${IFILES}
	@echo "Running directed test"
	vcs -R ${FLAGS} ${FILES} tests/test_01_directed.sv

02 constrained: 	tests/test_02_constrained.sv ${FILES} ${IFILES}
	@echo "Running constrained test"
	vcs -R ${FLAGS} ${FILES} tests/test_02_constrained.sv

03 cvr_driven:	tests/test_03_cvr_driven.sv ${FILES} ${IFILES}
	@echo "Running coverage driven test"
	vcs -R ${FLAGS} ${FILES} tests/test_03_cvr_driven.sv

all:	debug directed constrained cvr_driven

report:
	urg -dir .


DIR = $(shell basename `pwd`)
tar:	clean
	cd ..;tar cvfz ${DIR}.tgz ${DIR}
	@ls -l ../${DIR}.tgz

clean: 	
	@rm -rf csrc simv* *.tcl *.vpd .res* ucli* .ucli* *.old *.txt *.db 
	@rm -rf *.log *~ */*~ .*/*~ .*/*/*~


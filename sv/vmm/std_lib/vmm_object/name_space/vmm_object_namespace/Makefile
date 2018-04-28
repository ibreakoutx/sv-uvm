ifdef VMM_HOME
OPTS = +incdir+$(VMM_HOME)/sv
else
OPTS = -ntb_opts rvm
endif


all: clean comp run

clean:
	rm -rf simv* csrc *.log vc* ucli*

comp: namespace.sv
	vcs -sverilog  $(OPTS) namespace.sv -l comp.log	

run:
	./simv -l run.log

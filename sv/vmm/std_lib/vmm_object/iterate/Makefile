
all: clean comp run

clean:
	rm -rf simv* csrc *.log  vc* ucli*

comp: iter.sv
	vcs -sverilog  -ntb_opts rvm iter.sv -l comp.log	

run:
	simv -l run.log

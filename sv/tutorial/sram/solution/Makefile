all: clean comp run

clean:
	\rm -rf csrc simv* *.log 

comp:
	vcs -sverilog ../rtl/sram.v -l comp.log

run:
	simv -l run.log


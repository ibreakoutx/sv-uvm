
all:	clean comp run

clean:
	\rm -rf simv* csrc* *.log 
comp:
	vcs  -sverilog threads_example3.v  -l comp.log 
run:
	./simv -l run.log



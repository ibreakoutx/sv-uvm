
all:	clean comp run

clean:
	\rm -rf simv* csrc* *.log 
comp:
	vcs  -sverilog threads_example.v  -l comp.log 
run:
	./simv -l run.log



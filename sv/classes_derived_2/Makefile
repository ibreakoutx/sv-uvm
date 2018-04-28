
all:	clean comp run

clean:
	\rm -rf simv* csrc* *.log
comp:
	vcs  -sverilog  example_chaining_class.v   -l comp.log 
run:
	./simv -l run.log


all:	clean comp run
clean:
	\rm -rf simv* csrc* *.log
comp:
	vcs  -sverilog   example_class_in_module.v  -l comp.log 
run:
	./simv -l run.log

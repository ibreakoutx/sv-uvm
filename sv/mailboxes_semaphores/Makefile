
all:	clean comp run

clean:
	\rm -rf simv* csrc* *.log 
comp:
	vcs  -sverilog  semaphores_example.v    -l comp.log 
run:
	./simv -l run.log


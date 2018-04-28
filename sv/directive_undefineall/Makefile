all:	clean comp run 

clean:
	\rm -rf simv* csrc *.key
comp:
	vcs test.sv -sverilog
run:
	./simv

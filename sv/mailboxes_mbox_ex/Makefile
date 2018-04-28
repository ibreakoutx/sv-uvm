
all:	clean comp run

clean:
	\rm -rf simv* csrc* *.log 
comp:
	vcs  -sverilog   test.sv  -l comp.log 
run:
	./simv -l run.log


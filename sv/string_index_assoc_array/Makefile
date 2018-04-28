
all:	clean comp run
clean:
	\rm -rf simv* csrc* *.log
comp:
	vcs  -sverilog  str_index_assoc_array.sv  -l comp.log 
run:
	./simv -l run.log

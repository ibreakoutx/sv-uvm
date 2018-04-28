
all:	clean comp run

clean:
	\rm -rf simv* csrc* *.log .vcsmx_rebuild
comp:
	vcs  -sverilog +incdir+${VCS_HOME}/etc/systemverilog testList.sv -l comp.log 
run:
	./simv -l run.log


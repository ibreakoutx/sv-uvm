
all:	join_none join_any join 

clean:
	\rm -rf simv* csrc* *.log 

join_none: clean comp_join_none  run_none



comp_join_none:
	vcs -sverilog +define+JOIN_NONE fork_join.v -l comp_none.log
run_none:
	simv -l run_none.log




join_any: clean comp_join_any   run_any

comp_join_any :
	vcs -sverilog +define+JOIN_ANY fork_join.v -l comp_any.log
run_any:
	simv -l run_any.log



join: clean comp_join run_join
comp_join :
	vcs -sverilog fork_join.v -l comp_join.log
run_join: 
	simv -l run_.log


	
	

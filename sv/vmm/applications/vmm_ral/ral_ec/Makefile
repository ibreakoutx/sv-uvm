all: clean comp_ral run_ral comp_no_ral run_no_ral

clean:
	rm -rf csrc  simv* vcdplus.vpd *.log *.h ucli.key 

gen:
	ralgen -l sv -t ec ec.ralf

comp_ral: gen	
	vcs -l comp_ral.log -sverilog -ntb_opts rvm -debug_all \
		ec_intf.if.svi ec_ral_test.sv ec.v ec_top.v
run_ral:
	simv -l run_ral.log 

comp_no_ral:	
	rm -rf csrc/ ec.xml simv*  vcdplus.vpd ral_ec.sv *.tcl *.xml 
	vcs -l no_ral_comp.log -sverilog -ntb_opts rvm -debug_all \
		ec_bfm.sv ec_env.sv  ec_intf.if.svi ec_top.v  ec_test.sv ec.v

run_no_ral:
	simv -l no_ral_run.log +rvm_log_default=debug

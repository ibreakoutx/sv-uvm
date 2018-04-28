
VMM	= -ntb_opts rvm

OPTS	= 

VCS	= vcs -sverilog +verilog1995ext+.v $(VMM) \
              +warn=noBCNACMBP 

all: comp run

comp:
	$(VCS) $(OPTS) test.sv 

run:
	simv

clean:
	rm -rf simv* csrc *.log vc_*.h *.vpd ucli.key


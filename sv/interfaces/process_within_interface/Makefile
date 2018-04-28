CMP_OPTS = -sverilog -debug_all

TOP_FILE = top.v

SOURCE = interface.sv

all: clean comp run

comp:
	vcs $(CMP_OPTS) $(SOURCE) $(TOP_FILE) test.sv -l comp.log

run:
	simv -l run.log

clean:
	rm -rf simv simv.* vc_hdrs.h csrc *.log *.vpd *.swp DVEfiles ucli.key

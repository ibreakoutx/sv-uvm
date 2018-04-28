# SYNOPSYS CONFIDENTIAL -- This is an unpublished, proprietary work
# of Synopsys, Inc., and is fully protected under copyright and trade
# secret laws. You may not view, use, disclose, copy, or distribute
# this file or any information contained herein except pursuant to a
# valid written license from Synopsys.

VERB	= @
UVM_VMM_PKG = uvm_vmm_pkg.svp

all: $(UVM_VMM_PKG)

$(UVM_VMM_PKG): 
	$(VERB) ./incl_uvm.pl -l >$@

clean:
	$(VERB) rm -f $(UVM_VMM_PKG)

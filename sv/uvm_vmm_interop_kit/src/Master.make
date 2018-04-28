# SYNOPSYS CONFIDENTIAL -- This is an unpublished, proprietary work
# of Synopsys, Inc., and is fully protected under copyright and trade
# secret laws. You may not view, use, disclose, copy, or distribute
# this file or any information contained herein except pursuant to a
# valid written license from Synopsys.

VERB	= @
UVM_VMM_PKG = uvm_vmm_pkg.svp

install all: $(UVM_VMM_PKG) 

SOURCE = \
	avt_adapters.sv	\
	avt_analysis2notify.sv	\
	avt_analysis_channel.sv	\
	avt_channel2uvm_tlm.sv	\
	avt_converter.sv	\
	avt_notify2analysis.sv	\
	avt_uvm_tlm2channel.sv	\
	avt_uvm_vmm_env.sv	\
	avt_uvm_vmm_log_fmt.sv	\
	avt_uvm_vmm_timeline.sv	\
	avt_vmm_uvm_env.sv	\
	avt_vmm_uvm_report_server.sv	\
	avt_vmm_uvm_timeline.sv	\
	uvm_vmm_pkg.sv	

$(UVM_VMM_PKG): $(SOURCE) 
	$(VERB) ./incl_uvm.pl -l >$@

clean:
	$(VERB) rm -f $(UVM_VMM_PKG)


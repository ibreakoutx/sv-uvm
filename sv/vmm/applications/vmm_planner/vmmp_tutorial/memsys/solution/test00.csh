#!/bin/csh -f

vcs -sverilog   memsys0.v -f memsys.f memsys.test_top.v -cm assert+line+fsm+cond -lca

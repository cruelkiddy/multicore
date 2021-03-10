`$@` is the name of the target being generated, and `$<` the first prerequisite (usually a source file). 



$(addsuffix .d, $(VLSTEM) $(SVSTEM) $(VHSTEM) $(HDSTEM))



DEPDIR = .deps

%.d in .deps









\# directories

SRCDIR          = source

INCDIR          = include

TBDIR               = testbench

MAPDIR          = mapped

FPGADIR         = fpga

SCRDIR          = scripts

LIBDIR          = work

DEPDIR          = .deps



\# commands and flags

SYN                 = synthesize

MAKEDEP         = hdldep

VSIM                = vsim

VLOG                = vlog

VCOM                = vcom

VERFLAGS        = +acc -sv12compat -mfcu -lint +incdir+$(INCDIR)

VHDFLAGS        = -93 +acc -lint

SIMTIME         = -all








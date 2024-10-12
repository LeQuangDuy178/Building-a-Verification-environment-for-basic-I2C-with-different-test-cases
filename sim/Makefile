# Define variables
TESTNAME = testbench
TB_NAME = testbench
RADIX = 16 # Hexadecimal
SEED = 1 # Control by user define for randomization speed
RUNARG = -

all: build run

PHONY: all build run wave help clean
# Phony will make the targets not be associated with other same target name

build:
  vlib work
  vmap work work
  vlog -svf compile.f | tee compile.log

run:
  vsim -sv seed $(SEED) -debugDB-1 $(TESTNAME).log -voptargs=+acc-assertdebug -c $(TB_NAME) -do "log -r/; run -all;" +$(TESTNAME)

wave:
  vsim -i-view vsim.wlf do "add wave vsim:/$(TB_NAME)/*; radix $(RADIX)" &

clean:
  rm -rf work
  rm -rf vsim.dbg
  rm -rf .ini
  rm -rf .log
  rm -rf .wlf

help:
  @echo ""
  @echo "**********************************************************************"
  @echo "* make build: compile the design and testbench"
  @echo "* make run  : run simulation"
  @echo "* make all   : compile and run simulation"
  @echo "* make wave  : open waveform"
  @echo "* make clean : clean all compiled data"
  @echo "**********************************************************************"
  @echo ""
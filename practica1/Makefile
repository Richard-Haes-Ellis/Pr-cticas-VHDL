# Syntax of a Makefile target:
#
# target: dependency1 dependency2 ...
#	process (command to generate target from dependencies)

# If no targets are specified when calling make, it will build the first target
# in the file. The first target is usually called 'all'
all: tb_driver.ghw driver.bin

# Phony targets are always executed, even if a file with the same name exists
# These are typically short names for other recipes
.PHONY: all prog clean

##################
### Simulation ###
##################

# Analyze vhdl sources for simulation
protocol_common.o: protocol_common.vhd
	ghdl -a protocol_common.vhd

driver.o: driver.vhd
	ghdl -a driver.vhd

tb_driver.o: tb_driver.vhd
	ghdl -a tb_driver.vhd

# Generate simulation executable
tb_driver: protocol_common.o tb_driver.o driver.o 
	ghdl -e tb_driver

# Generate simulation waveform
tb_driver.ghw: tb_driver
	./tb_driver --wave=tb_driver.ghw

# Open gtkwave
view: tb_driver.ghw
	gtkwave tb_driver.ghw

######################
### Implementation ###
######################

# # Synthesize
# driver.json: driver.vhd
# 	yosys -m ghdl -p 'ghdl driver.vhd -e driver; synth_ice40 -json driver.json'

# # Place and route
# driver.asc: driver.json
# 	nextpnr-ice40 --up5k --package sg48 --pcf driver.pcf --json driver.json --asc driver.asc

# # Bitstream generation
# driver.bin: driver.asc
# 	icepack driver.asc driver.bin

# # Configure the FPGA
# prog: driver.bin
# 	iceprog driver.bin

###############
### Cleanup ###
###############

# Clean:
clean:
	rm -f *.o *.ghw work-obj??.cf tb_driver
	rm -f *.json *.asc *.bin


#---------------------------------------------------------------------------------------------
# Makefile
# --------------------------------------------------------------------------------------------
# Author: Fernando Ojeda L.                                                           Apr-2021
#---------------------------------------------------------------------------------------------
# Description:
#---------------------------------------------------------------------------------------------
# This makefile contains the targets needed to compile and simulate the RTL design and Testbench
# for Mentor Graphics Modelsim/Questasim
# 
#---------------------------------------------------------------------------------------------
# Commands:
#---------------------------------------------------------------------------------------------
#
# --> make compile          | Creates and maps libraries and then compile files
#
# --> make run              | Executes simulator in command line mode
#
# --> make gui              | Executes simulator in graphic user mode
#
# --> make gui_cov          | Executes simulator in graphic user mode with code coverage enabled
#
# --> vlib                  | Creates a design library, Modelsim will store the compiled design
#                             units in it. The default desing library is referred as work
#
# --> vmap                  | Maps a design library so that Modelsim can locate it.
#
# --> vlog                  | compile a Verilog source file
# --> vcom                  | Compile a VHDL source file
# -work                     - Specify a logical name or pathname of a library that is to be mapped
#                             to the logical library work
#
# --> vsim                  | Run Modelsim
# -c                        - Run in command line mode
# -L                        - Specify the libraries to search for design units instantiated from
#                             verilog and VHDL
# -l                        - Save transcript data to logfile
# -t                        - Specify simulator time resolution
# -wlf                      - Set waveform data log
# -do file                  - Execute do file
#
#---------------------------------------------------------------------------------------------

# TOP Entity
TOP = FFT_tb

# Main path to questasim
QUESTASIM_PATH = C:/questasim64_10.4e/win64
DO = ./do

# QuestaSim command paths
VLIB = $(QUESTASIM_PATH)/vlib
VMAP = $(QUESTASIM_PATH)/vmap
VLOG = $(QUESTASIM_PATH)/vlog
VCOM = $(QUESTASIM_PATH)/vcom
VSIM = $(QUESTASIM_PATH)/vsim

LIBRARIES = -L ./lib/fft_lib

HALT_ON_FAIL = 1
export HALT_ON_FAIL

compile: clean
	@echo "*** Compiling RTL and TestBench ***"

# Create FFT design library
	$(VLIB) ./lib/fft_lib;

# Create Work design library
	$(VLIB) work

# Map design libraries
	$(VMAP) work ./lib/fft_lib

# Compile verilog design and testbench
	$(VLOG) +cover=bcsf -vlog01compat -work ./lib/fft_lib \
	"./cos_rom.v" \
	"./DDS.v"     \
	"./FFT.v"     \
	"./FFT_tb.v"

run:
	@echo "*** Executing in BATCH Mode ***"
	$(VSIM) -c -novopt -g/FFT_tb/gtest=$(TEST) $(LIBRARIES) -l ./FFT.log -t 10fs -do $(DO)/run.do $(TOP)

gui:
	@echo "*** Executing in GUI Mode ***"
	$(VSIM) -gui -modelsimini ./modelsim.ini -novopt -g/FFT_tb/gtest=$(TEST) $(LIBRARIES) -l ./FFT.log -wlf vsim-wlf -t 10fs -do $(DO)/gui_fft.do $(TOP)

gui_cov:
	@echo "*** Executing in GUI Mode with coverage enabled ***"
	$(VSIM) -gui -modelsimini ./modelsim.ini -novopt -g/FFT_tb/gtest=$(TEST) -coverage -voptargs="+cover=bcstf" $(LIBRARIES) -l ./FFT.log -wlf vsim-wlf -t 10fs -do $(DO)/gui_fft.do $(TOP)

clean:
	@echo "*** Cleaning Output Files and Libraries ***"
	if [ -d "./lib/fft_lib" ]; then rm -rf ./lib/fft_lib; fi
	if [ -d "./work" ]; then rm -rf work; fi
	rm -f *.log
	rm -f *.vcom
	rm -f *.vhd
	rm -f *.mpf
	rm -f *.mti
	rm -f *.wlf
	rm -f vsim-wlf
	rm -f coverage_results
	rm -f modelsim.ini

# FPGA
Digital signal processing design and verification projects

-------------------------------------------------------------------------
1. CIC
-------------------------------------------------------------------------
This project implements a 3-stage cascade integrate comb filter (CIC)
with a very simple testbench, a sum of a high frequency and low frequency
signals generated through a DDS is inserted to the CIC module in order to
demonstrate that the filter is able to remove the low frequency component
and to only output the high frequency component which is also decimated.

-------------------------------------------------------------------------
2. FFT
-------------------------------------------------------------------------
This project implements a 64-FFT decimation in frequency module with a more
detailed testbench wich provides the option to insert several waveforms in
order to test the proper functionality of the module. Both the RTL design
and the Testbench are implemented in Verilog. The testbench provides the 
option to insert the following test waveforms:

1) Specific FFT-bin set:

2) Rectangular wave input:

3) Single Sine input: 

4) DC input:


A Makefile is provided with the following targets:

$make clean                      -> This target will remove all output files and
                                    design libraries.

$make compile                    -> This target will remove all output files and
                                    design libraries, then will create and map the
                                    design libraries, compile the verilog RTL and
                                    Testbench files.

$make run TEST=<Test_number>     -> This target will run the test in batch mode.
                                    A Test_number from 1 to 4 needs to be set.

$make gui TEST=<Test_number>     -> This target will run the test in graphic user
                                    mode, a preconfigured waveform will be loaded
                                    and the test will run until finish execution.
                                    A Test_number from 1 to 4 needs to be set.

$make gui_cov TEST=<Test_number> -> This target will run the test in graphic user
                                    mode, a preconfigured waveform will be loaded
                                    and the test will run until finish execution.
                                    Also, a coverage report will be generated and 
                                    loaded in the simulator in order to check 
                                    assertions on statements, branches, conditions,
                                    toggles and fsm's.
                                    A Test_number from 1 to 4 needs to be set.
                                    
Examples:
$make run TEST=1
$make gui TEST=2
$make gui_cov TEST=3

Notes:
1.- When executing in gui mode, do not forget to set the format waveform to analog(automatic)
    in order to see the waveforms properly.

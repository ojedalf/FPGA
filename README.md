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
order to test the proper functionality of the module. The testbench provides
the option to insert the following test waveforms:

1) Specific FFT-bin set:

2) Rectangular wave input:

3) Single Sine input: 

4) DC input:
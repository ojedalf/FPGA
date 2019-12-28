/*------------------------------------------------------------------------------------
   Testbench
--------------------------------------------------------------------------------------
   Author: Fernando Ojeda L.
--------------------------------------------------------------------------------------
   Description:
--------------------------------------------------------------------------------------
   The DUT corresponds to a decimating low pass 3-stage CIC filter, a low frequency
   plus a high frequency 256-sinewave is applied at the input and it is expected that
   the high frequency component gets filtered and the low frequency component decimated
   by 32. Thus having at the output a 32-sinewave
-------------------------------------------------------------------------------------*/


`timescale 1ns/1ns

module FIR2_tb();

//inputs regs
reg reset;
reg clk;
reg [7:0] impulse;

//outputs wires
wire [25:0] fir_out;

//nodes
wire [7:0] dds_fir2;


// **********  Main ***************


// Reset
initial
begin
  reset = 0; 
  #10
  reset = 1;
  #20
  reset = 0;
end

// Clock
//CLock
initial 
begin
	clk = 1'b0;
end

always 
begin
	#10               // 10*timescale = half cycle
	clk  = ~clk;      // clock = 20ns
end


// impulse
initial
begin
	impulse <=  0;
	#70
	impulse <= 8'b01111111;
	#20
	impulse <= 0;
end



// Instantiation
FIR2 fir2_inst
(
	.reset(reset),
	.clk(clk),
	.x(dds_fir2),   // input to the filter (dds_fir2) or (impulse)
	.y(fir_out)
);


DDS dds_inst
(
	.clk(clk),
	.rst(reset),
	.phase(8'b1),
	.yy(),          // single sinewave
	.y2(dds_fir2),  // two overlapped sinewaves, low freq + high freq  
	.y3()           // impulse response
);

endmodule










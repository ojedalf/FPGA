/*-----------------------------------------------------------------------------
   Decimating Cascade Integrator Comb (CIC) Filter
-------------------------------------------------------------------------------
   Author: Fernando Ojeda L.
-------------------------------------------------------------------------------
   Description:
-------------------------------------------------------------------------------
   This is a low pass filter implemented with a 3-stage CIC structure using a 
   downsampling factor equal to 32.   
   
   CIC filters are known for not using multipliers, they are an efficient
   implementation of the recursive moving average filter.
   
   Signed (2'complemented) should be used to avoid overflow in the integrators

   Register size must be (2*N+1)*N*log2(D)
   where N=3, D=32
   Register size = 120 bits
   
-------------------------------------------------------------------------------
   Filter Characteristics:
-------------------------------------------------------------------------------   
   
   fs:
   Gain: 8343
   attenuation:
   ripple:
   
-------------------------------------------------------------------------------
   Diagram:
-------------------------------------------------------------------------------
   x  - input
   y  - output
   In - Integrator n stage
   Dn - Downsampler by n
   Cn - Comb n stage
	
   x --->|CIC|---> y

   x ---->|I1|-->|I2|-->|I2|-->|D32|-->|C1|-->|C2|-->|C3|---> y
-------------------------------------------------------------------------------*/

`include "DDS.v"  

module FIR2
(
input reset,
input clk,
input signed [7:0] x,
output signed [25:0] y
);


// integrators
reg signed [25:0] integrator1;
reg signed [25:0] integrator2;
reg signed [25:0] integrator3;

// combs
reg signed [25:0] comb1;
reg signed [25:0] comb1_d1;
reg signed [25:0] comb1_d2;
reg signed [25:0] comb1_output;
reg signed [25:0] comb2_d1;
reg signed [25:0] comb2_d2;
reg signed [25:0] comb2_output;
reg signed [25:0] comb3_d1;
reg signed [25:0] comb3_d2;
reg signed [25:0] comb3_output;

reg [5:0] count;
reg take_sample;


// ****************  Main ********************

// downsampling control
always@(posedge clk or posedge reset)
begin
    if (reset)
        count <= 0;
    else begin
	if (count == 31)  begin
	    count <= 0;
	    take_sample <= 1;
	    end
	else begin
	    count <= count + 1;
	    take_sample <= 0;
	    end
    end
end


// CIC
always@(posedge clk or posedge reset)
begin
    if (reset) begin
		integrator1  <= 0;
		integrator2  <= 0;
		integrator3  <= 0;
	    comb1        <= 0;
	    comb1_d1     <= 0;
	    comb1_d2     <= 0;
	    comb1_output <=	0;	
	    comb2_d1     <=	0;	
	    comb2_d2     <= 0;
	    comb2_output <=	0;	
	    comb3_d1	 <=	0;
	    comb3_d2	 <=	0;
	    comb3_output <=	0;	
		
	end
    else begin
		// integrators
		integrator1 <= integrator1 + x;
		integrator2 <= integrator2 + integrator1;
		integrator3 <= integrator2 + integrator2;
	end
	
	// downsampling
    if (take_sample == 1) begin
		// comb1 
		comb1        <= integrator3;
		comb1_d1     <= comb1;
		comb1_d2     <= comb1_d1;
		comb1_output <= comb1 - comb1_d2;
		// comb2
		comb2_d1     <= comb1_output;
		comb2_d2     <= comb2_d1;
		comb2_output <= comb1_output - comb2_d2;
		// comb3
		comb3_d1     <= comb2_output;
		comb3_d2     <= comb3_d1;
		comb3_output <= comb2_output - comb3_d2;
	end
end

    // Output
	assign y = comb3_output;

endmodule












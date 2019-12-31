/*-----------------------------------------------------------------------------
   Decimating in frequency 64-Fast Fourier Transform (FFT)
-------------------------------------------------------------------------------
   Author: Fernando Ojeda L.                                          Dic-2016
-------------------------------------------------------------------------------
   Description:
-------------------------------------------------------------------------------
   The FFT is implemented in a serial processing form using a radix-2 algorithm.
   The input buffers need first to be filled with 64 samples from the real and 
   imaginary input signals before processing their frequency response.
   
   For 64 points, 6 stages are required, each with N/2 butterflies. Therefore,
   6(N/2) = 192 cycles are required to compute the FFT for 64 input samples.
   
   To guarantee an output signal value of one in magnitud and avoid overflow, 
   the input must be limited to 1/sqrt(2). After every butterfly, the magnitude
   is doubled, thus an scaling of 1/2 is required.
   
   Rounding to the nearest value is applied after every multiplier when passing
   from 32 to 16 bits in order to avoid DC bias.
-------------------------------------------------------------------------------
   FFT Characteristics:
-------------------------------------------------------------------------------   
   FFT module of 64 points    
   Radix-2 algorihm 
   Decimation in Frequency    
   Bit reversal at the output 
   Stages = log2(64) = 6       

   16 bits == sign + 1 integer + 14 fraction  
-------------------------------------------------------------------------------
   Diagram:
-------------------------------------------------------------------------------   
                ______
   x_real ---> | FFT | ---> fft_real  
   y_imag ---> |     | ---> fft_imag
               ------   
-------------------------------------------------------------------------------*/

module FFT
(
	input clk,
	input reset,
	input signed [15:0]  x_real,
	input signed [15:0]  y_imag,
	output reg signed [15:0] fft_real,
	output reg signed [15:0] fft_imag
);


/*--------------------------------------------------------
   Declarations
--------------------------------------------------------*/
reg  [3:0] state;
parameter start = 0, load = 1, calc = 2, update = 3, reverse = 4;

// Counters
reg [7:0] count;           // N-point counter
reg [6:0] gcount;          // SubDFT counter
reg [6:0] rcount;          // Reverse index counter

integer k;
integer N = 64;

// twidle factors
reg signed [15:0] cos;
reg signed [15:0] sin; 
reg [6:0] w;               // Twiddle factor index
reg [6:0] dw;              // Twiddle factor offset

reg signed [15:0] difference_real;
reg signed [15:0] difference_imag;

// Input buffer
reg  signed [15:0] x_real_buffer64 [0:63];
reg  signed [15:0] y_imag_buffer64 [0:63];

reg signed [31:0] product_real1;
reg signed [31:0] product_real2;
reg signed [31:0] product_imag1;
reg signed [31:0] product_imag2;

reg signed [15:0] shift_productr1;
reg signed [15:0] shift_productr2;
reg signed [15:0] shift_producti1;
reg signed [15:0] shift_producti2;

reg [3:0] stage;
reg [6:0] i1;
reg [6:0] i2;
reg [6:0] k1;
reg [6:0] k2;


/*--------------------------------------------------------
   Module instantiation
--------------------------------------------------------*/
cos_rom cos_rom_inst();   // Twiddle factors


/*--------------------------------------------------------
   Main 
--------------------------------------------------------*/

// ******** Update twiddle factors *******
always@(posedge clk or posedge reset)
begin
	if (reset) begin
		cos <= 0;
		sin <= 0;
	end
	else begin
		cos_rom_inst.cos_rom_task(w,cos);
		cos_rom_inst.sin_rom_task(w,sin);
	end
end


// ********* State Machine ****************
always@(posedge clk or posedge reset)
begin
	if (reset)
	begin
		state           <= start;
		count           <= 0;       // N-point counter
		gcount          <= 0;       // SubDFT counter
		rcount          <= 0;
		stage           <= 1;      
		i1              <= 0;
		i2              <= N/2;
		k1              <= N;
		k2              <= N/2;
		difference_real <= 0;
		difference_imag <= 0;
		product_real1   <= 0;
		product_real2   <= 0;
		product_imag1   <= 0;
		product_imag2   <= 0;
	end else
	    
	case (state)
	
	// Initial conditions when computing a new set of data
	start:                         
	begin
		state            <= load;
		count            <= 0;
		gcount           <= N/2;         // group counter
		rcount           <= 0;
		stage            <= 1;
		w                <= 0;
		dw               <= 1;
		i1               <= 0;           // input butterfly index begin 
		i2               <= N/2;         // input butterfly index end
		k1               <= N;           // group index begin
		k2               <= N/2;         // group index end
		difference_real  <= 0;
		difference_imag  <= 0;
		product_real1    <= 0;
		product_real2    <= 0;
		product_imag1    <= 0;
		product_imag2    <= 0;
		shift_productr1  <= 0;
		shift_productr2  <= 0;
		shift_producti1  <= 0;
		shift_producti2  <= 0;
	end
	
	// Serial to parallel: in every cycle load 1 sample
	load:                                           
	begin
		x_real_buffer64[count] <= x_real;
		y_imag_buffer64[count] <= y_imag;
					
		count <= count + 1;
				
		if (count == N) begin
			state <= calc;
			w     <= 1; 
		end
		else
			state <= load;
	end
	
	// Butterfly Computation
	calc:                                             
	begin
		if (stage < 7) begin	       
			difference_real       = (x_real_buffer64[i1] - x_real_buffer64[i2]);   // The order of the statements is very important
			x_real_buffer64[i1]   = (x_real_buffer64[i1] + x_real_buffer64[i2]);  
  
			difference_imag       = (y_imag_buffer64[i1] - y_imag_buffer64[i2]);
			y_imag_buffer64[i1]   = (y_imag_buffer64[i1] + y_imag_buffer64[i2]); 	              

			product_real1         =  cos*difference_real;
			product_real2         =  sin*difference_imag; 	       	       	       
			shift_productr1       =  product_real1 >> 14;
			shift_productr2       =  product_real2 >> 14;
			x_real_buffer64[i2]  <=  shift_productr1 + shift_productr2;           // truncation to 16 bits

			product_imag1         =  cos*difference_imag;  
			product_imag2         =  sin*difference_real;
			shift_producti1       =  product_imag1 >> 14;
			shift_producti2       =  product_imag2 >> 14;
			y_imag_buffer64[i2]  <=  shift_producti1 - shift_producti2;           // truncation to 16 bits
	
			// new group
			if (w == 32-dw)       
				w  <= 0;
			else
				w  <= w  + dw;
		
			// new stage
			if (i2 == 62)        
				dw    <= dw*2;
						
			state <= update;         
		end
		else
			state <= reverse;
		
		count <= 0;
	end

	// Update indexes
	update:                                      
	begin
		state <= calc;       
	         
		if (stage <= 6) begin
			if (i1 < gcount-1) begin             // if true stay in current group (subDFT)		    
				i1     = i1 + 1;
				i2     = i1 + k2;                // Keep offset of k2 between i1 and i2
				//w      <= w  + dw;             // Twiddle factors offset
			end
	
			else begin                           // Go next group
				if (i2 < N-1) begin              // if true stay in current stage and update group
					i1  = i1 + k2 + 1;           // Jump index to next group
					i2  = i1 + k2;        
					gcount <=  i2;    
					//w <= 0;
				end
				else begin                       // Go next stage
					k1     <= k2;
					k2      = k2/2;              // must be fixed in each stage because defines the offset between i1 and i2
					gcount  = k2;                // To jump between groups, change gcount, store current k2 value
					i1     <= 0;
					i2      = k2;
					//w      <= 0;
					//dw     <= dw*2;            // Update Twiddle factors offset
					stage  <= stage + 1;
				end
			end	
		end
		else begin
			state <= reverse;
			count <= 0;
		end
	end

	// Reverse Output bits
	reverse:
	begin
		for(k = 0;k <= 5;k = k + 1)
			rcount[k] = count[5-k];              // blocking statement must be combinational in one cycle
		  
		fft_real <= x_real_buffer64[rcount];
		fft_imag <= y_imag_buffer64[rcount];
		 
		count  = count + 1;
		 
		if (count >= N)
			state <= start;
		else 
			state <= reverse;
		 
	end
	
	endcase
end

endmodule




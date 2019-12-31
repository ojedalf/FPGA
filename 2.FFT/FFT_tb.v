/*------------------------------------------------------------------------------------
   Testbench
--------------------------------------------------------------------------------------
   Author: Fernando Ojeda L.                                                 Dic-2016
--------------------------------------------------------------------------------------
   Description:
--------------------------------------------------------------------------------------
   The DUT corresponds to a decimating in frequency 64-point FFT in radix-2 algorithm 
   when one complete cylce 256-sinewave is applied at the real-input, it is expected 
   that the real and imaginary outputs generate a single sample in its corresponding
   frequency bin without frequency spreading.
   
---------------------------------------------------------------------------------------
   Test:
---------------------------------------------------------------------------------------   
   1) Specific FFT-bin set:
      Each bin is stimulated at a time in order to generate a single sinewave with its
	  corresponding number of cycles at the output.
	  Bin 1 ... 1 sine cycle
	  Bin 2 ... 2 sine cycles
	  Bin n ... n sine cycles
   
   
   2) Rectangular wave input:
      A sinc waveform is expected at the real and imaginary outputs
	  Note: Output is not symmetric, it is in natural order, fftshift would be needed 
	  in order to see the sinc properly.
   
   
   3) Single Sine input: 
      An integer number of sine cycles is applied at the real input so it is expected
	  that their corresponding output bins are excited without frequency spread.

   
   4) DC input:
      When Aplying a DC vaveform, all input bins to the same value. It is expected that
      the output bin0 is excited with a magnitud equal to the sum of the magnitudes of 
      all the input bins. For instance all inputs are 32d in magnitude, then the output
      bin0 magnitude would be equal to 32d*(64_samples) = 16320d	  

---------------------------------------------------------------------------------------
   Modelsim notes:
---------------------------------------------------------------------------------------  
   1. When compiling and loading the simulation click the "run-all" button.
      A window will pop-up with the message "are you sure you want to finish",
	  select "No" and check/update your waveform window

   2. Right click in a corresponding waveform and select format -> analog(automatic)
      and Radix -> Sfixed in order to see the waveforms properly.
	  
   3. Update the analog format each time you run a simulation in order to scale the
      analog waveform properly.
 
-------------------------------------------------------------------------------------*/
`timescale  1ns/1ns

module FFT_tb;


/*--------------------------------------------------------
   Declarations
--------------------------------------------------------*/

// Inputs reg
reg clk;
reg reset;

// Outputs wire
wire [15:0]  fft_real_tb; 
wire [15:0]  fft_imag_tb;

// Nodes
wire [15:0] dds_fft_node;
reg [15:0] x_real_s;
reg [15:0] y_imag_s;
reg [7:0] phase_s;
reg[7:0] sel;

// Integers
integer k;

/*--------------------------------------------------------
   Hierarchical referencing
--------------------------------------------------------*/
wire [7:0] bin_t = FFT_tb.fft_inst.count;
wire [3:0] state_t = FFT_tb.fft_inst.state;



/*--------------------------------------------------------
   Task declaration
--------------------------------------------------------*/
task test;
input [6:0]  number; 

begin

    $display("Applying zeroes to the real and imag inputs");
	sel = 0;
    #10_000                                                    // wait for 10us
															   
	case (number)                                              
															   
	// Test 1                                                  
	7'd1:                                                      
	begin                                                      
		for(k = 0;k <= 10;k = k + 1) begin                     
			$display("Stimulate only bin %d ", k+1);           
			wait(state_t == 4'b1 & bin_t == k);                // load_state and bin_number
			sel = 1;                                           
			#40                                                
			sel = 0;                                           
			#20_000;                                           // wait for 20us
		end                                                    
	end                                                        
															   
	// Test 2                                                  
	7'd2:                                                      
	begin                                                      
		$display("Applying an 8-sample rectangular input");    
		wait(state_t == 4'b1 & bin_t == 2);                    // load_state and bin_number
		sel = 1;                                               
		wait(state_t == 4'b1 & bin_t == 9);                    // load_state and bin_number
		sel = 0;                                               
		#20_000;                                               // wait for 10us
	end
	
	// Test 3
	7'd3:
	begin
		$display("Applying sine only to the real input");
		phase_s = 32;
		wait(state_t == 4'h0 & bin_t == 8'h40);
		sel = 2;
		#20_000;                                               // wait for 20us
	end
	
	// Test 3
	7'd4:
	begin
		$display("Applying a DC waveform at the real and imaginary inputs");
		sel = 1;
		#20_000;                                               // wait for 20us
	end
	
	endcase
end
endtask



/*--------------------------------------------------------
   Initialization sequence
--------------------------------------------------------*/

// Reset initialization
initial
begin
	reset = 1'b0;
	#10
	reset = 1'b1;
	#10
	reset = 1'b0;
end

// Clock initial value
initial
begin
	phase_s = 1;
	clk = 1'b0;
end

// 50MHz clock generation 
always 
begin
	#10
	clk = ~clk;    // 20 ns period
end


/*--------------------------------------------------------
   DUT instantiation
--------------------------------------------------------*/
FFT fft_inst
(

.clk(clk),
.reset(reset),
.x_real(x_real_s),        // input
.y_imag(y_imag_s),        // input
.fft_real(fft_real_tb),   // Output
.fft_imag(fft_imag_tb)    // Output
);

/*--------------------------------------------------------
   Model instantiation
--------------------------------------------------------*/
DDS dds_inst
(
.clk(clk),
.rst(reset),
.phase(phase_s),
.yy(dds_fft_node),
.y2(),
.y3()
);


/*--------------------------------------------------------
   Test sequence
--------------------------------------------------------*/
initial 
begin
	test(1);    // Select a test
	$finish;
end



/*--------------------------------------------------------
   Always blocks
--------------------------------------------------------*/

// Mux inputs to the FFT
always@(posedge clk)
begin
	case (sel)
	0:
	begin 
		x_real_s <= 0;
		y_imag_s <= 0;
	end 	
	
	1:
	begin 
		x_real_s <= 16'h00FF;
		y_imag_s <= 16'h00FF;
	end 
	
	2:
	begin 
		x_real_s <= dds_fft_node;
		y_imag_s <= 0;
	end 

	3:
	begin
		x_real_s <= dds_fft_node;
		y_imag_s <= dds_fft_node;
	end

	4:
	begin
		x_real_s <= 16'h00FF;
		y_imag_s <= 16'h00FF;
	end

	5:
	begin
		x_real_s <= 16'h00FF;
		y_imag_s <= 16'h00FF;
	end

endcase
end

endmodule

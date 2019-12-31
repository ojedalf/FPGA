/*-------------------------------------------------------------------------------------------
   Twiddle Factors
---------------------------------------------------------------------------------------------
   Author: Fernando Ojeda L.                                                         Dic-2016
---------------------------------------------------------------------------------------------
   Description:
---------------------------------------------------------------------------------------------
   This file contains two tasks that correspond to the FFT twiddle factors, which is basically
   a Cosine and a Sine LUT.
-------------------------------------------------------------------------------------------*/

module cos_rom;

// ***********  Cosine LUT  **************

task cos_rom_task;
 input [6:0]  w; 
 output reg signed  [15:0] cos; 

   begin
case (w) 
     7'd  0 : cos <= 16'b 100000000000000;  
     7'd  1 : cos <= 16'b  11111110110001;  
     7'd  2 : cos <= 16'b  11111011000101;  
     7'd  3 : cos <= 16'b  11110100111110;  
     7'd  4 : cos <= 16'b  11101100100001;  
     7'd  5 : cos <= 16'b  11100001110001;  
     7'd  6 : cos <= 16'b  11010100110111;  
     7'd  7 : cos <= 16'b  11000101111001;  
     7'd  8 : cos <= 16'b  10110101000001;  
     7'd  9 : cos <= 16'b  10100010011010;  
     7'd 10 : cos <= 16'b  10001110001110;  
     7'd 11 : cos <= 16'b   1111000101011;  
     7'd 12 : cos <= 16'b   1100001111110;  
     7'd 13 : cos <= 16'b   1001010010100;  
     7'd 14 : cos <= 16'b    110001111100;  
     7'd 15 : cos <= 16'b     11001000110;  
     7'd 16 : cos <= 16'b               0;  
     7'd 17 : cos <= 16'b1111100110111010;  
     7'd 18 : cos <= 16'b1111001110000011;  
     7'd 19 : cos <= 16'b1110110101101100;  
     7'd 20 : cos <= 16'b1110011110000010;  
     7'd 21 : cos <= 16'b1110000111010100;  
     7'd 22 : cos <= 16'b1101110001110001;  
     7'd 23 : cos <= 16'b1101011101100110;  
     7'd 24 : cos <= 16'b1101001010111111;  
     7'd 25 : cos <= 16'b1100111010000111;  
     7'd 26 : cos <= 16'b1100101011001001;  
     7'd 27 : cos <= 16'b1100011110001110;  
     7'd 28 : cos <= 16'b1100010011011111;  
     7'd 29 : cos <= 16'b1100001011000001;  
     7'd 30 : cos <= 16'b1100000100111011;  
     7'd 31 : cos <= 16'b1100000001001111;  
   endcase
   end
endtask


// **********  Sine LUT  *****************

task sin_rom_task;
input [6:0] w;
output reg signed [15:0] sin;
begin
     case (w) 
     7'd  0 : sin <= 16'b               0;  
     7'd  1 : sin <= 16'b1111100110111010;  
     7'd  2 : sin <= 16'b1111001110000011;  
     7'd  3 : sin <= 16'b1110110101101100;  
     7'd  4 : sin <= 16'b1110011110000010;  
     7'd  5 : sin <= 16'b1110000111010100;  
     7'd  6 : sin <= 16'b1101110001110001;  
     7'd  7 : sin <= 16'b1101011101100110;  
     7'd  8 : sin <= 16'b1101001010111111;  
     7'd  9 : sin <= 16'b1100111010000111;  
     7'd 10 : sin <= 16'b1100101011001001;  
     7'd 11 : sin <= 16'b1100011110001110;  
     7'd 12 : sin <= 16'b1100010011011111;  
     7'd 13 : sin <= 16'b1100001011000001;  
     7'd 14 : sin <= 16'b1100000100111011;  
     7'd 15 : sin <= 16'b1100000001001111;  
     7'd 16 : sin <= 16'b1100000000000000;  
     7'd 17 : sin <= 16'b1100000001001111;  
     7'd 18 : sin <= 16'b1100000100111011;  
     7'd 19 : sin <= 16'b1100001011000001;  
     7'd 20 : sin <= 16'b1100010011011111;  
     7'd 21 : sin <= 16'b1100011110001110;  
     7'd 22 : sin <= 16'b1100101011001001;  
     7'd 23 : sin <= 16'b1100111010000111;  
     7'd 24 : sin <= 16'b1101001010111111;  
     7'd 25 : sin <= 16'b1101011101100110;  
     7'd 26 : sin <= 16'b1101110001110001;  
     7'd 27 : sin <= 16'b1110000111010100;  
     7'd 28 : sin <= 16'b1110011110000010;  
     7'd 29 : sin <= 16'b1110110101101100;  
     7'd 30 : sin <= 16'b1111001110000011;  
     7'd 31 : sin <= 16'b1111100110111010;  
   endcase
end
endtask

endmodule

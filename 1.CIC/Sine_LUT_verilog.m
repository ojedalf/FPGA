%------------------------------------------------------------------------------
% Sine LUT generator
%------------------------------------------------------------------------------
% Author: Fernando Ojeda L.
%------------------------------------------------------------------------------
% Description:
%------------------------------------------------------------------------------
% Sine wave implemented in fixed point Q15 format, 16 bits
% 1 sign + 15 fractional bits 
% 
% Signals are generated with double precision values, thus when fitting into 
% 16-bit value registers, the signal values need to be rounded to reduce the 
% quantization error
%
% Remember Matlab is column major and index = 1
%-------------------------------------------------------------------------------

clc;
clear;

N = 1200;
Fs = 1000;
t = (0:N-1)/Fs;

sigma = 0.01;
rng('default')

y4 = chirp(t,100,1,300)+sigma*randn(size(t));  % Chirp signal

y1    = 0.8*sin(2*pi*(1/256)*(0:255));         % low frequency 256-sine
y2    = 0.1*sin(2*pi*(65/256)*(0:255));        % high frequency 256-sine

% select output signal 
y = y1+y2;

plot(y);
grid;

% Signal quantization
bits = 16;
yq   = round(y*2^(bits-1))/(2^(bits-1));       % Round the integer value to reduce quantization noise  
q    = quantizer([16 14]);                     % [wordlength fractionlength], [sign(1) integer(1) fraction(14)] 

% Convert to binary format
for i = 1:256
  b(i)   = str2double(num2bin(q,yq(i)));
end

% Add index [0:255] row 
A = [0:255; b];


% Print to a text file in verilog format
fileID = fopen('sinLUT.txt','w');              % File needs to ve located in a valid Matlab path
 
fprintf(fileID,'module sin_LUT \n');
fprintf(fileID,'( \n');
fprintf(fileID,' input   enable, \n');
fprintf(fileID,' input   clk, \n');
fprintf(fileID,' input   [%1d:0] index, \n',16);
fprintf(fileID,' output  reg  [%1d:0] sine, \n',bits-1);
fprintf(fileID,'); \n\n');


fprintf(fileID,'always @(posedge CLK)\n');
fprintf(fileID,' if (enable) \n');
fprintf(fileID,'   case (index) \n');
             
fprintf(fileID,'     8''d%3d : chirp <= 16''b%16.0f;  \n', A);  % convert to fixed point %16.0f,   '' = '
fprintf(fileID,'   endcase\n');
fprintf(fileID,'endmodule\n');
fclose(fileID);

% myDFT - Compute the Discrete Fourier Transform (DFT) of a signal y 
% without using MATLAB's built-in fft() function
% Vectorization technique used instead of looping to compute the DFT
function XMat = myDFT(x)
N = length(x);  % Length of the input signal
n = 0:N-1;  % Time index vector (row)
k = (-floor(N/2):ceil(N/2)-1)';   % Frequency index vector centered around 0
u2 = exp(-1j * 2 * pi * k * n / N);   % DFT matrix using Euler's formula
XMat = u2 * x';   % Vectorization: Compute DFT: matrix multiplication (forces y to column)
end
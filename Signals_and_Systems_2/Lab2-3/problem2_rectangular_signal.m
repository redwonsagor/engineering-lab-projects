%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     IE-SS2-Lab 2                   %
%                       Group 2                      %
%                  Date : 12.06.2025                 %
%        Author: Charles Ikenna Eboson 2667542       %
%                Mir Md Redwon Sagor 2613747         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem 3: Dual Tones Analysis 

% --- Generate and plot the rectangular signal --- %
fs = 8000;                  % Sampling frequency (Hz)
T = 1 / fs;                  % Sampling period
duration = 0.004;            % Signal duration (4 ms)
N = 2^nextpow2(fs*duration); % Number of samples (power of 2)
fprintf('Value of N = %f\n\n', N);

t = (0:N-1) * T;           % Time vector (in seconds)
n = 0:N-1;                 % Sample index vector for stem plots

x = zeros(size(t));
x((t >= 0) & (t <= 0.002)) = 1; % Rectangular pulse from 0 to 2 ms

% Plot the signal x(t)
figure;
stem(n, x, 'filled');  % Convert time to ms for better labeling
xlabel('Sample Index n');
ylabel('Amplitude');
title('Rectangular Signal (2 ms duration) - Discrete Samples');
grid on;

% Alternative: plot with time axis in ms
figure(2);
stem(t*1000, x, 'filled'); % CHANGED: Use stem, Convert time to ms
xlabel('Time (ms)');
ylabel('Amplitude');
title('Rectangular Signal (2 ms duration) - Time Domain');
grid on;

%% PROBLEM 2(b)(ii): Plot amplitude spectrum using DFT
% Zero-padding before DFT
N_original = length(x);
N_padded = 4 * N_original;  % e.g. pad to 4 times original length

X = fft(x, N_padded);       % Apply DFT with zero-padding
f = (-N_padded/2:N_padded/2-1)*(fs/N_padded); % Adjust frequency vector
X_shifted = fftshift(X);

figure(3);
stem(f, abs(X_shifted), 'filled');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Amplitude Spectrum of Rectangular Signal (DFT with Zero-padding)');
grid on;
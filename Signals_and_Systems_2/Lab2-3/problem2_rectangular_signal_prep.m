% Parameters
T = 0.002;               % Pulse width in seconds (2 ms)
f = linspace(-5000, 5000, 1000);  % Frequency range for plotting (in Hz)

% Amplitude Spectrum
X_mag = T * abs(sinc(T * f));     % sinc in MATLAB is normalized: sinc(x) = sin(pi*x)/(pi*x)

% Plot
figure;
plot(f, X_mag, 'LineWidth', 2);
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
title('Amplitude Spectrum of Rectangular Pulse (0 \leq t \leq 2 ms)');
grid on;
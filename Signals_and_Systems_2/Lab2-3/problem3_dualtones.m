%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     IE-SS2-Lab 2                   %
%                       Group 2                      %
%                  Date : 12.06.2025                 %
%        Author: Charles Ikenna Eboson 2667542       %
%                Mir Md Redwon Sagor 2613747         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem 3: Dual Tones Analysis 

%% ========================================================================
%% PROBLEM 3: DUAL TONES (DTMF)
%% ========================================================================

%% PROBLEM 3(a): Read and understand background section
% Background understanding required - see PDF page 3
% DTMF frequency table provided in background section

%% PROBLEM 3(b): Load and play audio file
[signal, fs] = audioread('touchtone1.wav');
fprintf('Playing touchtone1.wav...\n');
soundsc(signal, fs); % plays the loaded audio file
pause(length(signal)/fs + 1); % Waits for audio to finish plus 1 second

%% PROBLEM 3(c): Plot signal in time domain
figure(1);
t = (0:length(signal)-1)/fs;
plot(t, signal); % Keep as plot for audio (represents continuous-like signal)
xlabel('Time (s)');
ylabel('Amplitude');
title('Dual Tone Signal in Time Domain');
grid on;

%% PROBLEM 3(d): Plot amplitude spectrum (with zero-padding and symmetric frequency axis)

% Set zero-padding factor (e.g. 4x for better frequency resolution)
N_original = length(signal);
N_padded = 4 * N_original;

% Compute zero-padded FFT
X = fft(signal, N_padded);
X_shifted = fftshift(X);

% Frequency vector from -fs/2 to fs/2
f = (-N_padded/2:N_padded/2-1)*(fs/N_padded);

% Full spectrum plot (DFT coefficients are discrete)
figure(2);
subplot(2,1,1);
stem(f, abs(X_shifted), 'filled'); 
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Full Amplitude Spectrum of Dual Tone Signal (Zero-padded DFT)');
grid on;

% Restricted frequency range for DTMF: -1600 Hz to 1600 Hz
subplot(2,1,2);
freq_indices = find(f >= -1600 & f <= 1600);
stem(f(freq_indices), abs(X_shifted(freq_indices)), 'filled');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Dual Tone Spectrum (-1600 to 1600 Hz, Zero-padded)');
xlim([-1600 1600]);
grid on;


%% PROBLEM 3(e): Write DTMF generation function
% Function to generate dual tones is in generate_dualtones.m
% Parameters: fs = 8kHz, digit duration = 75ms, break duration = 30ms

%% PROBLEM 3(f): Create dual tone signal of your phone number
fprintf('\n=== ENTER YOUR PHONE NUMBER HERE ===\n');
phone_number = [7, 9, 5, 8, 3, 4, 2, 1, 9, 0, 3, 2]; % *** Phone number ***
fprintf('Using phone number: ');
fprintf('%d\n', phone_number);

% Generate the dual tone signal
phone_signal = generate_dualtones(phone_number);

% PROBLEM 3(f): Play the phone number signal
fprintf('Playing your phone number as DTMF tones...\n');
soundsc(phone_signal, fs); % This will play phone number
pause(length(phone_signal)/fs + 1); % Wait for audio to finish

% PROBLEM 3(f): Plot phone number in time domain
figure(3);
t_phone = (0:length(phone_signal)-1)/fs;
subplot(2,1,1);
plot(t_phone, phone_signal); % Keep as plot for audio
xlabel('Time (s)');
ylabel('Amplitude');
title('Phone Number Dual Tone Signal in Time Domain');
grid on;

% PROBLEM 3(f): Plot phone number in frequency domain
% Zero-padding before DFT
N_original = length(phone_signal);
N_padded = 4 * N_original;  % e.g. pad to 4 times original length

X_phone = fft(phone_signal, N_padded);
f_phone = (-N_padded/2:N_padded/2-1)*(fs/N_padded); % Adjust frequency vector
X_phone_shifted = fftshift(X_phone);

% Plot full spectrum
figure;
stem(f_phone, abs(X_phone_shifted), 'filled');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Full Spectrum of Phone Number Dual Tone Signal');
grid on;

% Zoom into DTMF band with negative freqs included
figure;
freq_indices_phone = find(f_phone >= -1600 & f_phone <= 1600);
stem(f_phone(freq_indices_phone), abs(X_phone_shifted(freq_indices_phone)), 'filled');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('DTMF Spectrum (-1600 Hz to 1600 Hz)');
grid on;

%% ========================================================================
%% PROBLEM 3: ANALYSIS AND VERIFICATION
%% ========================================================================

% Display frequencies used in DTMF system
fprintf('\n=== DTMF Frequency Information ===\n');
disp('DTMF Frequency Table:');
disp('Row frequencies: 697, 770, 852, 941 Hz');
disp('Column frequencies: 1209, 1336, 1477 Hz');

% Show which frequencies correspond to each digit in number
fprintf('\nYour phone number frequency breakdown:\n');
row_freqs = [697, 770, 852, 941];
col_freqs = [1209, 1336, 1477];

for i = 1:length(phone_number)
    digit = phone_number(i);
    if digit == 0
        row = 4; col = 2;
    else
        row = floor((digit-1)/3) + 1;
        col = mod(digit-1, 3) + 1;
    end
    fprintf('Digit %d: %d Hz + %d Hz\n', digit, row_freqs(row), col_freqs(col));
end
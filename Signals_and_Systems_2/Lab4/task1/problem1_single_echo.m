%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     IE-SS2-Lab 2                   %
%                       Group 2                      %
%                  Date : 03.07.2025                 %
%        Author: Charles Ikenna Eboson 2667542       %
%                Mir Md Redwon Sagor 2613747         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clc;

fprintf('=== Problem 1: Single Echo Filter===\n');

%% Part (b)(i): Implement and test single echo filter

% Parameters
alpha = 0.5;
R = 3;

% Create delta function for testing (impulse response)
N_samples = 50;
delta = [1 zeros(1, N_samples-1)];

% Test the single echo filter
fprintf('\nTesting single echo filter with delta function...\n');
y_single = single_echo_filter(delta, alpha, R);

%% Part (b)(ii): Frequency response 'H' analysis 

fprintf('\n--- Frequency Response Analysis  ---\n');

% Compute DFT of impulse response
N_fft = 1024; % Number of samples
H_single = fft(y_single, N_fft);

% Create frequency vector (0 to fs)
f_norm = (0:N_fft-1) / N_fft; % Normalized frequency (0 to 1)
f_half = f_norm(1:N_fft/2); % 0 to 0.5 (0 to fs/2)  Extracts the first half of the frequencies for H

% SQUARED magnitude response as required
figure(1);
subplot(2,1,1);
plot(f_half, abs(H_single(1:N_fft/2)).^2);  % SQUARED magnitude
title('Single Echo Filter - SQUARED Magnitude Response |H(f)|^2 (alpha = 0.5)');
xlabel('Normalized Frequency (f/fs)');
ylabel('|H(f)|^2');
grid on;

subplot(2,1,2);
plot(f_half, angle(H_single(1:N_fft/2)) * 180/pi);
title('Single Echo Filter - Phase Response (alpha = 0.5)');
xlabel('Normalized Frequency (f/fs)');
ylabel('Phase (degrees)');
grid on;

% Test with alpha = 1
fprintf('\nTesting with alpha = 1...\n');
y_single_alpha1 = single_echo_filter(delta, 1, R);
H_single_alpha1 = fft(y_single_alpha1, N_fft);

figure(2);
subplot(2,1,1);
plot(f_half, abs(H_single_alpha1(1:N_fft/2)).^2);  % SQUARED magnitude
title('Single Echo Filter - SQUARED Magnitude Response |H(f)|^2 (alpha = 1)');
xlabel('Normalized Frequency (f/fs)');
ylabel('|H(f)|^2');
grid on;

subplot(2,1,2);
plot(f_half, angle(H_single_alpha1(1:N_fft/2)) * 180/pi);
title('Single Echo Filter - Phase Response (alpha = 1)');
xlabel('Normalized Frequency (f/fs)');
ylabel('Phase (degrees)');
grid on;

fprintf('\nPhase response explanation for alpha = 1:\n');
fprintf('When alpha = 1, the filter has unity gain for the delayed component.\n');
fprintf('The phase response shows linear phase characteristics.\n');
fprintf('At frequencies where the delay causes 180° phase shift, destructive\n');
fprintf('interference occurs, creating notches in the frequency response.\n');

%% Part (b)(iii): Apply to sound file 

fprintf('\n--- Applying Filter to Audio File (FIXED) ---\n');

try
    % Actually load and process audio file
    [audio_data, fs] = audioread('memphis.wav');
    fprintf('Audio file loaded successfully\n');
    fprintf('Sampling rate: %d Hz\n', fs);
    fprintf('Audio length: %.2f seconds\n', length(audio_data)/fs);
    
    % Use only first channel if stereo
    if size(audio_data, 2) > 1
        audio_data = audio_data(:, 1);
        fprintf('Using first channel (mono)\n');
    end
    
    % Calculate R for approximately 100ms delay
    R_audio = round(0.1 * fs); % 100ms time delay
    actual_delay = R_audio / fs * 1000; % in milliseconds
    fprintf('Delay samples for ~100ms: R = %d\n', R_audio);
    fprintf('Actual delay: %.1f ms\n', actual_delay);
    
    % Apply single echo filter with different parameters
    fprintf('\nApplying filters with different parameters...\n');
    
%% Test 1: alpha = 0.5, R for 100ms
% 100ms delay
R_audio_100ms = round(0.1 * fs); % 100ms delay
actual_delay_100ms = R_audio_100ms / fs * 1000; % Convert to milliseconds
audio_filtered_1 = single_echo_filter(audio_data, 0.5, R_audio_100ms);
audiowrite('memphis_echo_alpha05_100ms.wav', audio_filtered_1, fs);
fprintf('Saved: memphis_echo_alpha05_100ms.wav (alpha=0.5, delay=%.1fms)\n', actual_delay_100ms);

%% Test 2: alpha = 0.3, R for 100ms
R_audio_100ms = round(0.1 * fs); % 100ms delay
actual_delay_100ms = R_audio_100ms / fs * 1000; % Convert to milliseconds
audio_filtered_2 = single_echo_filter(audio_data, 0.3, R_audio_100ms);
audiowrite('memphis_echo_alpha03_100ms.wav', audio_filtered_2, fs);
fprintf('Saved: memphis_echo_alpha03_100ms.wav (alpha=0.3, delay=%.1fms)\n', actual_delay_100ms);

%% Test 3: alpha = 0.7, R for 100ms
R_audio_100ms = round(0.1 * fs); % 100ms delay
actual_delay_100ms = R_audio_100ms / fs * 1000; % Convert to milliseconds
audio_filtered_3 = single_echo_filter(audio_data, 0.7, R_audio_100ms);
audiowrite('memphis_echo_alpha07_100ms.wav', audio_filtered_3, fs);
fprintf('Saved: memphis_echo_alpha07_100ms.wav (alpha=0.7, delay=%.1fms)\n', actual_delay_100ms);

%% Test 4: alpha = 0.5, R for 200ms
R_audio_200ms = round(0.2 * fs); % 200ms delay
actual_delay_200ms = R_audio_200ms / fs * 1000; % Convert to milliseconds
audio_filtered_4 = single_echo_filter(audio_data, 0.5, R_audio_200ms);
audiowrite('memphis_echo_alpha05_200ms.wav', audio_filtered_4, fs);
fprintf('Saved: memphis_echo_alpha05_200ms.wav (alpha=0.5, delay=%.1fms)\n', actual_delay_200ms);

%% Test 5: alpha = 0.5, R for 50ms
R_audio_50ms = round(0.05 * fs); % 50ms delay
actual_delay_50ms = R_audio_50ms / fs * 1000; % Convert to milliseconds
audio_filtered_5 = single_echo_filter(audio_data, 0.5, R_audio_50ms);
audiowrite('memphis_echo_alpha05_50ms.wav', audio_filtered_5, fs);
fprintf('Saved: memphis_echo_alpha05_50ms.wav (alpha=0.5, delay=%.1fms)\n', actual_delay_50ms);

%% Now repeat the above steps for other test cases (alpha = 0.3, 0.7, etc.)

% 5. Filtered Audio Signal (Time Domain) - alpha = 0.3, 100ms delay
figure;
subplot(2, 2, 1);
plot(audio_filtered_2);
title('Filtered Audio (alpha = 0.3, 100ms delay)');
xlabel('Samples');
ylabel('Amplitude');
grid on;

% 6. Frequency Response of Filtered Audio (Magnitude) - alpha = 0.3, 100ms delay
subplot(2, 2, 2);
H_filtered_2 = fft(audio_filtered_2, N_fft);
plot(f_norm(1:N_fft/2), abs(H_filtered_2(1:N_fft/2)).^2);
title('Frequency Response of Filtered Audio (alpha = 0.3, 100ms delay)');
xlabel('Normalized Frequency (f/fs)');
ylabel('|H(f)|^2');
grid on;

sgtitle('Effects of Echo Filter on Audio (alpha = 0.3, 100ms delay)');

%% Filtered Audio Signal (alpha = 0.7, 100ms delay)
figure;
subplot(2, 2, 1);
plot(audio_filtered_3);
title('Filtered Audio (alpha = 0.7, 100ms delay)');
xlabel('Samples');
ylabel('Amplitude');
grid on;

% Frequency Response of Filtered Audio (Magnitude) - alpha = 0.7, 100ms delay
subplot(2, 2, 2);
H_filtered_3 = fft(audio_filtered_3, N_fft);
plot(f_norm(1:N_fft/2), abs(H_filtered_3(1:N_fft/2)).^2);
title('Frequency Response of Filtered Audio (alpha = 0.7, 100ms delay)');
xlabel('Normalized Frequency (f/fs)');
ylabel('|H(f)|^2');
grid on;

sgtitle('Effects of Echo Filter on Audio (alpha = 0.7, 100ms delay)');

%% Filtered Audio Signal (alpha = 0.5, 200ms delay)
figure;
subplot(2, 2, 1);
plot(audio_filtered_4);
title('Filtered Audio (alpha = 0.5, 200ms delay)');
xlabel('Samples');
ylabel('Amplitude');
grid on;

% Frequency Response of Filtered Audio (Magnitude) - alpha = 0.5, 200ms delay
subplot(2, 2, 2);
H_filtered_4 = fft(audio_filtered_4, N_fft);
plot(f_norm(1:N_fft/2), abs(H_filtered_4(1:N_fft/2)).^2);
title('Frequency Response of Filtered Audio (alpha = 0.5, 200ms delay)');
xlabel('Normalized Frequency (f/fs)');
ylabel('|H(f)|^2');
grid on;

sgtitle('Effects of Echo Filter on Audio (alpha = 0.5, 200ms delay)');

%% Filtered Audio Signal (alpha = 0.5, 50ms delay)
figure;
subplot(2, 2, 1);
plot(audio_filtered_5);
title('Filtered Audio (alpha = 0.5, 50ms delay)');
xlabel('Samples');
ylabel('Amplitude');
grid on;

% Frequency Response of Filtered Audio (Magnitude) - alpha = 0.5, 50ms delay
subplot(2, 2, 2);
H_filtered_5 = fft(audio_filtered_5, N_fft);
plot(f_norm(1:N_fft/2), abs(H_filtered_5(1:N_fft/2)).^2);
title('Frequency Response of Filtered Audio (alpha = 0.5, 50ms delay)');
xlabel('Normalized Frequency (f/fs)');
ylabel('|H(f)|^2');
grid on;

sgtitle('Effects of Echo Filter on Audio (alpha = 0.5, 50ms delay)');


    
    fprintf('\n--- Parameter Variation Effects ---\n');
    fprintf('Alpha effects:\n');
    fprintf('  - Smaller alpha (0.3): Weaker echo, more subtle effect\n');
    fprintf('  - Larger alpha (0.7): Stronger echo, more pronounced effect\n');
    fprintf('  - Alpha = 1: Echo same volume as original\n');
    fprintf('\nR (delay) effects:\n');
    fprintf('  - Smaller R (50ms): Tight echo, may sound like doubling\n');
    fprintf('  - Larger R (200ms): Distinct separate echo\n');
    fprintf('  - R ~100ms: Natural sounding echo\n');
    
    % FIXED: Added option to play audio
    fprintf('\n--- Audio Playback Options ---\n');
    fprintf('To listen to the original and filtered audio:\n');
    
    user_input = input('Play original audio? (y/n): ', 's');
    if strcmpi(user_input, 'y')
        fprintf('Playing original audio...\n');
        sound(audio_data, fs);
        pause(length(audio_data)/fs + 1);
    end
    
    user_input = input('Play filtered audio (alpha=0.5, 100ms delay)? (y/n): ', 's');
    if strcmpi(user_input, 'y')
        fprintf('Playing filtered audio...\n');
        sound(audio_filtered_1, fs);
        pause(length(audio_filtered_1)/fs + 1);
    end
    
catch ME
    fprintf('Error processing audio file: %s\n', ME.message);
    fprintf('Make sure memphis.wav is in the current directory\n');
    fprintf('Current directory: %s\n', pwd);
    fprintf('Files in directory:\n');
    dir('*.wav')
end

fprintf('\n=== Problem 1 Complete (FIXED) ===\n');
fprintf('Key fixes applied:\n');
fprintf('1. ✓ Plots SQUARED magnitude response |H(f)|^2 as required\n');
fprintf('2. ✓ Actually applies filter to sound file (.wav)\n');
fprintf('3. ✓ Tests with different alpha and R values\n');
fprintf('4. ✓ Provides audio playback options\n');
fprintf('\nGenerated files:\n');
fprintf('- memphis_echo_alpha05.wav\n');
fprintf('- memphis_echo_alpha03.wav\n');
fprintf('- memphis_echo_alpha07.wav\n');
fprintf('- memphis_echo_200ms.wav\n');
fprintf('- memphis_echo_50ms.wav\n');
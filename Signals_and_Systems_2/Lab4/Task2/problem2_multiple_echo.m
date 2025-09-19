%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     IE-SS2-Lab 2                   %
%                       Group 2                      %
%                  Date : 03.07.2025                 %
%        Author: Charles Ikenna Eboson 2667542       %
%                Mir Md Redwon Sagor 2613747         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Problem 2: Multiple Echo Filter - FIXED VERSION
% Signals and Systems 2 - Lab 4
% N-echo FIR filter implementation and recursive version

close all; clc;

fprintf('=== Problem 2: Multiple Echo Filter (FIXED) ===\n');

%% Parameters
N = 6;      % Number of echoes
alpha = 1;  % Echo coefficient
R = 3;      % Delay in samples

%% Part (b)(i): Implement both recursive and non-recursive filters

fprintf('\n--- Part (b)(i): Comparing FIR and IIR Implementations ---\n');

% Create delta function for testing
N_samples = 100;
delta = [1 zeros(1, N_samples-1)];

% Test both implementations
fprintf('Testing with N = %d, alpha = %.1f, R = %d\n', N, alpha, R);

% Non-recursive (FIR) implementation
fprintf('\nComputing FIR response...\n');
y_fir = multiple_echo_filter_fir(delta, alpha, R, N);

% Recursive (IIR) implementation  
fprintf('Computing IIR response...\n');
y_iir = multiple_echo_filter_iir(delta, alpha, R);

% Compare impulse responses
fprintf('\nImpulse Response Comparison (first 30 samples):\n');
fprintf('n\tFIR h[n]\tIIR h[n]\tDifference\n');
fprintf('-------------------------------------------\n');
for i = 1:30
    diff = abs(y_fir(i) - y_iir(i));
    fprintf('%d\t%.6f\t%.6f\t%.8f\n', i-1, y_fir(i), y_iir(i), diff);
end

% Check if they match (within numerical precision)
max_diff = max(abs(y_fir - y_iir(1:length(y_fir))));
fprintf('\nMaximum difference between FIR and IIR: %.2e\n', max_diff);
if max_diff < 1e-10
    fprintf('✓ FIR and IIR implementations match!\n');
else
    fprintf('⚠ FIR and IIR implementations differ\n');
end

%% Part (b)(ii): Frequency response analysis and pole-zero plot 

fprintf('\n--- Part (b)(ii): Frequency Response Analysis (FIXED) ---\n');

% FIXED: Compute frequency responses for both FIR and IIR
N_fft = 1024;
H_fir = fft(y_fir, N_fft);
% Ensure that y_iir has at least N_fft samples by padding if necessary
if length(y_iir) < N_fft
    y_iir_padded = [y_iir, zeros(1, N_fft - length(y_iir))];  % Padding with zeros
else
    y_iir_padded = y_iir(1:N_fft);  % If y_iir is already sufficiently long, slice it
end

% Now perform the FFT on the padded or sliced y_iir
H_iir = fft(y_iir_padded, N_fft);


% Frequency vector
f_norm = (0:N_fft-1) / N_fft;
f_half = f_norm(1:N_fft/2);

% FIXED: Plot frequency responses for both filters
figure(1);
subplot(2,2,1);
plot(f_half, abs(H_fir(1:N_fft/2)));
title('Multiple Echo FIR - Magnitude Response');
xlabel('Normalized Frequency (f/fs)');
ylabel('|H(f)|');
grid on;

subplot(2,2,2);
plot(f_half, angle(H_fir(1:N_fft/2)) * 180/pi);
title('Multiple Echo FIR - Phase Response');
xlabel('Normalized Frequency (f/fs)');
ylabel('Phase (degrees)');
grid on;

subplot(2,2,3);
plot(f_half, abs(H_iir(1:N_fft/2)));
title('Multiple Echo IIR - Magnitude Response');
xlabel('Normalized Frequency (f/fs)');
ylabel('|H(f)|');
grid on;

subplot(2,2,4);
plot(f_half, angle(H_iir(1:N_fft/2)) * 180/pi);
title('Multiple Echo IIR - Phase Response');
xlabel('Normalized Frequency (f/fs)');
ylabel('Phase (degrees)');
grid on;

fprintf('The magnitude response shows a "comb filter" characteristic\n');
fprintf('with periodic notches in the frequency domain.\n');
fprintf('This is why this type of filter is called a "comb filter".\n');

% Pole-zero analysis for IIR filter with proper zplane plot
fprintf('\n--- Pole-Zero Analysis (FIXED) ---\n');

% For IIR: H(z) = 1/(1 - alpha*z^(-R))
% Denominator: 1 - alpha*z^(-R) = 0 => z^R = alpha
% Poles: z = alpha^(1/R) * exp(j*2*pi*k/R) for k = 0,1,...,R-1

% Create filter coefficients for zplane
b = 1;  % Numerator
a = [1 zeros(1,R-1) -alpha];  % Denominator: 1 + 0*z^(-1) + ... + (-alpha)*z^(-R)

% Calculate poles manually
pole_magnitude = alpha^(1/R);
pole_angles = 2*pi*(0:R-1)/R;
poles = pole_magnitude * exp(1j*pole_angles);

fprintf('Filter coefficients:\n');
fprintf('Numerator (b): [%.1f]\n', b);
fprintf('Denominator (a): [');
for i = 1:length(a)
    fprintf('%.3f ', a(i));
end
fprintf(']\n');

fprintf('\nPole locations:\n');
for k = 1:R
    fprintf('Pole %d: %.4f + j%.4f (magnitude: %.4f, angle: %.1f°)\n', ...
        k, real(poles(k)), imag(poles(k)), abs(poles(k)), angle(poles(k))*180/pi);
end

% Plot pole-zero diagram 
figure(2);
try
    % Try to use zplane if Signal Processing Toolbox is available
    zplane(b, a);
    title('Pole-Zero Plot for IIR Multiple Echo Filter (using zplane)');
    fprintf('✓ Using MATLAB zplane function\n');
catch
    % Manual pole-zero plot if zplane is not available
    fprintf('Signal Processing Toolbox not available, creating manual plot...\n');
    
    % Plot unit circle
    theta = 0:0.01:2*pi;
    plot(cos(theta), sin(theta), 'k--', 'LineWidth', 1);
    hold on;
    
    % Plot poles
    plot(real(poles), imag(poles), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
    
    % Plot zero at origin (there's actually no zero at origin for this filter)
    % The filter H(z) = 1/(1 - alpha*z^(-R)) has no finite zeros
    
    axis equal;
    grid on;
    xlabel('Real Part');
    ylabel('Imaginary Part');
    title('Pole-Zero Plot for IIR Multiple Echo Filter (Manual)');
    legend('Unit Circle', 'Poles', 'Location', 'best');
    xlim([-1.5 1.5]);
    ylim([-1.5 1.5]);
    hold off;
end

% Stability analysis with proper condition
fprintf('\n--- Stability Analysis (FIXED) ---\n');
fprintf('Pole magnitude: %.4f\n', pole_magnitude);
fprintf('Alpha value: %.4f\n', alpha);

if pole_magnitude < 1
    fprintf('✓ Filter is STABLE (all poles inside unit circle)\n');
elseif abs(pole_magnitude - 1) < 1e-10
    fprintf('⚠ Filter is MARGINALLY STABLE (poles on unit circle)\n');
else
    fprintf('✗ Filter is UNSTABLE (poles outside unit circle)\n');
end

fprintf('For stability: |alpha|^(1/R) < 1 => |alpha| < 1\n');
% For stability: |alpha^(1/R)| < 1 => |alpha| < 1
fprintf('Current condition: |%.4f| < 1 is ', alpha);

% Use if-else for conditional logic
if alpha < 1
    fprintf('TRUE\n');
else
    fprintf('FALSE\n');
end

fprintf('Current condition: |%.4f| < 1 is ', alpha);

% Use if-else to check the condition
if alpha < 1
    fprintf('TRUE\n');
else
    fprintf('FALSE\n');
end

% Test stability for alpha > 1
fprintf('\nTesting stability for alpha > 1:\n');
alpha_test = 1.2;
pole_mag_test = alpha_test^(1/R);
fprintf('For alpha = %.1f: pole magnitude = %.4f\n', alpha_test, pole_mag_test);

% Use if-else to check stability
if pole_mag_test < 1
    fprintf('Is stable? YES\n');
else
    fprintf('Is stable? NO\n');
end


%% Part (b)(iii): Apply to sound file 

fprintf('\n--- Part (b)(iii): Applying Filters to Audio ---\n');

try
    % Actually load and process audio file
    [audio_data, fs] = audioread('memphis.wav');
    fprintf('Audio file loaded successfully\n');
    fprintf('Sampling rate: %d Hz\n', fs);
    
    % Use first channel if stereo
    if size(audio_data, 2) > 1
        audio_data = audio_data(:, 1);
    end
    
    % Calculate R for 100ms delay  
    R_audio = round(0.1 * fs);
    actual_delay = R_audio / fs * 1000;
    fprintf('Delay samples for ~100ms: R = %d (actual: %.1f ms)\n', R_audio, actual_delay);
    
    % Test with stable alpha = 0.5
    fprintf('\n--- Testing with stable alpha = 0.5 ---\n');
    
    audio_fir_stable = multiple_echo_filter_fir(audio_data, 0.5, R_audio, N);
    audio_iir_stable = multiple_echo_filter_iir(audio_data, 0.5, R_audio);
    
    audiowrite('memphis_multiple_fir_stable.wav', audio_fir_stable, fs);
    audiowrite('memphis_multiple_iir_stable.wav', audio_iir_stable, fs);
    
    fprintf('Saved: memphis_multiple_fir_stable.wav\n');
    fprintf('Saved: memphis_multiple_iir_stable.wav\n');
    
    % Test with different alpha values
    fprintf('\n--- Testing with alpha = 0.3 (more stable) ---\n');
    
    audio_fir_03 = multiple_echo_filter_fir(audio_data, 0.3, R_audio, N);
    audio_iir_03 = multiple_echo_filter_iir(audio_data, 0.3, R_audio);
    
    audiowrite('memphis_multiple_fir_alpha03.wav', audio_fir_03, fs);
    audiowrite('memphis_multiple_iir_alpha03.wav', audio_iir_03, fs);
    
    fprintf('Saved: memphis_multiple_fir_alpha03.wav\n');
    fprintf('Saved: memphis_multiple_iir_alpha03.wav\n');
    
    % Test with alpha > 1 (UNSTABLE) - Use short audio segment for safety
    fprintf('\n--- Testing with alpha = 1.1 (UNSTABLE) ---\n');
    fprintf('⚠ Using only first 2 seconds for safety!\n');
    
    audio_short = audio_data(1:min(2*fs, length(audio_data)));
    
    audio_fir_11 = multiple_echo_filter_fir(audio_short, 1.1, R_audio, N);
    audio_iir_unstable = multiple_echo_filter_iir(audio_short, 1.1, R_audio);
    
    % Normalize to prevent clipping
    if max(abs(audio_iir_unstable)) > 0
        audio_iir_unstable = audio_iir_unstable / max(abs(audio_iir_unstable)) * 0.9;
    end
    
    audiowrite('memphis_multiple_fir_11.wav', audio_fir_unstable, fs);
    audiowrite('memphis_multiple_iir_unstable.wav', audio_iir_unstable, fs);
    
    fprintf('Saved: memphis_multiple_fir_11.wav\n');
    fprintf('Saved: memphis_multiple_iir_unstable.wav (normalized)\n');
    
    % Test with alpha = 1 (marginally stable)
    fprintf('\n--- Testing with alpha = 1.0 (marginally stable) ---\n');
    
    audio_fir_marginal = multiple_echo_filter_fir(audio_short, 1.0, R_audio, N);
    audio_iir_marginal = multiple_echo_filter_iir(audio_short, 1.0, R_audio);
    
    audiowrite('memphis_multiple_fir_alpha1.wav', audio_fir_marginal, fs);
    audiowrite('memphis_multiple_iir_alpha1.wav', audio_iir_marginal, fs);
    
    fprintf('Saved: memphis_multiple_fir_alpha1.wav\n');
    fprintf('Saved: memphis_multiple_iir_alpha1.wav\n');
    
    % Added audio playback options
    fprintf('\n--- Audio Playback Options ---\n');
    
    user_input = input('Play stable FIR filtered audio (alpha=0.5)? (y/n): ', 's');
    if strcmpi(user_input, 'y')
        fprintf('Playing FIR filtered audio...\n');
        sound(audio_fir_stable, fs);
        pause(length(audio_fir_stable)/fs + 1);
    end
    
    user_input = input('Play stable IIR filtered audio (alpha=0.5)? (y/n): ', 's');
    if strcmpi(user_input, 'y')
        fprintf('Playing IIR filtered audio...\n');
        sound(audio_iir_stable, fs);
        pause(length(audio_iir_stable)/fs + 1);
    end
    
    user_input = input('Play unstable IIR filtered audio (alpha=1.1)? (y/n): ', 's');
    if strcmpi(user_input, 'y')
        fprintf('Playing unstable IIR filtered audio (normalized)...\n');
        sound(audio_iir_unstable, fs);
        pause(length(audio_iir_unstable)/fs + 1);
    end
    
    fprintf('\n--- Behavioral Analysis (DETAILED) ---\n');
    fprintf('FIR vs IIR behavior with different alpha values:\n\n');
    
    fprintf('Alpha < 1 (stable):\n');
    fprintf('  FIR: Finite echo sequence (N echoes), always stable\n');
    fprintf('       Each echo has amplitude alpha^k for k=0,1,...,N\n');
    fprintf('  IIR: Infinite decaying echoes, stable system\n');
    fprintf('       Echoes continue indefinitely with decreasing amplitude\n\n');
    
    fprintf('Alpha = 1 (marginally stable):\n');
    fprintf('  FIR: Finite echo sequence with constant amplitude\n');
    fprintf('       All N echoes have the same amplitude as original\n');
    fprintf('  IIR: Infinite echoes with constant amplitude\n');
    fprintf('       System is on the border of stability\n\n');
    
    fprintf('Alpha > 1 (unstable):\n');
    fprintf('  FIR: Finite echo sequence with increasing amplitude\n');
    fprintf('       Later echoes are louder than earlier ones\n');
    fprintf('  IIR: Infinite echoes with exponentially growing amplitude!\n');
    fprintf('       Output grows without bound - system is unstable\n');
    fprintf('       (Normalization applied to prevent speaker damage)\n\n');
    
catch ME
    fprintf('Error processing audio file: %s\n', ME.message);
    fprintf('Make sure memphis.wav is in the current directory\n');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     IE-SS2-Lab 2                   %
%                       Group 2                      %
%                  Date : 15.05.2025                 %
%        Author: Charles Ikenna Eboson 2667542       %
%                Mir Md Redwon Sagor 2613747         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_4 = rand(1, 4);     % Generate a random signal of length 4
x_10000 = rand(1, 10000); % Generate a random signal of length 10000

profile on
tic;   % Start timer
X_myDFT_10000 = myDFT(x_10000);  % Compute DFT using custom function
t_myDFT_10000 = toc;          % Stop timer and store elapsed time

tic;   % Start timer
X_fft_10000 = fftshift(fft(x_10000));   % Compute FFT using built-in function
t_fft_10000 = toc;    % Stop timer and store elapsed time
profile viewer

% --- Display runtimes ---
fprintf('Custom DFT time for 10000 random signal: %.4f seconds\n', t_myDFT_10000);
fprintf('Built-in FFT time for 10000 random signal: %.4f seconds\n', t_fft_10000);

X_myDFT_4 = myDFT(x_4);
X_fft_4 = fftshift(fft(x_4));

% --- Check Result ---
fprintf('First 4 values of Custom DFT for 4 random signals: %.4f, %.4f, %.4f, %.4f\n', ...
    X_myDFT_4(1), X_myDFT_4(2), X_myDFT_4(3), X_myDFT_4(4));
fprintf('First 4 values of Built-in FFT for 4 random signal: %.4f, %.4f, %.4f, %.4f\n', ...
    X_fft_4(1), X_fft_4(2), X_fft_4(3), X_fft_4(4));

% --- Check and display difference between results ---
error = norm(X_myDFT_4 - X_fft_4);  % Compute Euclidean norm of difference
fprintf('Difference (norm) between DFT and FFT for 4 random signal: %.4e\n', error);
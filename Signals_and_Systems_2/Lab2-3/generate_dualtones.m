%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     IE-SS2-Lab 2                   %
%                       Group 2                      %
%                  Date : 12.06.2025                 %
%        Author: Charles Ikenna Eboson 2667542       %
%                Mir Md Redwon Sagor 2613747         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = generate_dualtones(digits)
    % generate_dualtones - Generate dual tone signals for a sequence of digits
    % Input: digits - vector of digits (0-9, * as 10, # as 11)
    % Output: y - audio signal containing the dual tones
    
    % Parameters
    fs = 8000;                    % Sampling frequency (Hz)
    digit_duration = 0.075;       % Duration per digit (75 ms)
    break_duration = 0.030;       % Duration of break between digits (30 ms)
    
    % DTMF frequency table
    row_freqs = [697, 770, 852, 941];      % Row frequencies
    col_freqs = [1209, 1336, 1477];        % Column frequencies
    
    % Mapping of digits to row and column indices
    % For digits 1-9:
    %   row = floor((digit-1)/3) + 1
    %   col = mod(digit-1, 3) + 1
    % Special cases for *, 0, #
    
    % Initialize output signal
    y = [];
    
    % Process each digit
    for d = digits
        % Handle special characters
        if d == '*'
            row = 4; col = 1;
        elseif d == 0
            row = 4; col = 2;
        elseif d == '#'
            row = 4; col = 3;
        else
            % Regular digits 1-9
            row = floor((d-1)/3) + 1;
            col = mod(d-1, 3) + 1;
        end
        
        % Get frequencies for this digit
        f1 = row_freqs(row);
        f2 = col_freqs(col);
        
        % Generate time vector for this digit
        t = (0:1/fs:digit_duration-1/fs)';
        
        % Generate dual tone signal (sum of two sine waves)
        digit_signal = sin(2*pi*f1*t) + sin(2*pi*f2*t);
        
        % Normalize amplitude
        digit_signal = 0.5 * digit_signal;
        
        % Generate silence for break
        break_signal = zeros(round(break_duration*fs), 1);
        
        % Append to output signal
        y = [y; digit_signal; break_signal];
    end
end
function y = single_echo_filter(x, alpha, R)
% single_echo_filter Implements a single echo FIR filter
% 
% Input:
%   x - input signal vector
%   alpha - echo gain coefficient
%   R - delay in samples
%
% Output:
%   y - filtered output signal
%
% Difference equation: y[n] = x[n] + alpha * x[n-R]

% Initialize output vector
y = zeros(size(x));

% Apply the difference equation
for n = 1:length(x)
    y(n) = x(n);
    if (n - R) > 0
        y(n) = y(n) + alpha * x(n - R);
    end
end

end
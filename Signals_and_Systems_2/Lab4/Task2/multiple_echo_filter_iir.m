function y = multiple_echo_filter_iir(x, alpha, R)
% MULTIPLE_ECHO_FILTER_IIR Implements N-echo filter using recursive form
%
% Input:
%   x - input signal vector
%   alpha - echo gain coefficient
%   R - delay in samples between echoes
%
% Output:
%   y - filtered output signal
%
% Recursive difference equation: y[n] = x[n] + alpha * y[n-R]

% Initialize output vector
y = zeros(size(x));

% Apply the recursive difference equation
for n = 1:length(x)
    y(n) = x(n);
    if (n - R) > 0
        y(n) = y(n) + alpha * y(n - R);
    end
end

end
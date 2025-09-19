function y = multiple_echo_filter_fir(x, alpha, R, N)
% MULTIPLE_ECHO_FILTER_FIR Implements N-echo FIR filter (non-recursive)
%
% Input:
%   x - input signal vector
%   alpha - echo gain coefficient
%   R - delay in samples between echoes
%   N - number of echoes
%
% Output:
%   y - filtered output signal
%
% Difference equation: y[n] = sum(alpha^k * x[n-k*R]) for k=0 to N

% Initialize output vector
y = zeros(size(x));

% Apply the difference equation
for n = 1:length(x)
    y(n) = x(n); % k=0 term
    for k = 1:N
        if (n - k*R) > 0
            y(n) = y(n) + alpha^k * x(n - k*R);
        end
    end
end

end
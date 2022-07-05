function [v] = mynanvar(x)
%Computes variance of tseries or a numeric vector with missing observations
%without using Matlab's |nanvar| function, which requires Matlab's
%Statistical Toolbox. 
%
% Input: x -- a tseries or a numeric vector
% Output: v -- the variance of the non-NaN elements of x (a scalar)
%
% P.Manchev (pmanchev@imf.org), 20091130

if class(x) == 'Series'
    begper = get(x,'start');
    endper = get(x,'end');
else
    begper = 1;
    endper = length(x);
end

n = 1;
for i = begper : endper
    
    if isnan(x(i))
        continue
    else
        xx(n) = x(i);
        n = n + 1;
    end
    
end

v = var(xx);
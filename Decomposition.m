function [C,L] = Decomposition(s,level,pow)
% Author: Efsun Sarioglu
% computes Haar decomposition
h = length(s);
pow = power(2,pow);
dif = h-pow;
s = s(dif+1:h);
h = length(s);
i = 1;
% C = C/sqrt(h);    % normalize input coefficients
while ((i<level) & (h>2))
    s = DecompositionStep(s,h);
    h = h/2;
    i = i+1;
end;
len = length(s);
C = s(1:len/2);
L = s(len/2+1:len);



function P = binning(T, window)
% Author: Efsun Sarioglu
% Spring 05
% averages the signal for a smoother result
len = length(T);
for (i=1:len-2)
    temp = 0;
    for (j=1:window)
        temp = temp + T(i+j-1);
    end
    P(i) = temp/window;
end
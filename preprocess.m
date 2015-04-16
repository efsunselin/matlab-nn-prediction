function [P] = preprocess(T,type,param)
% prestd
% premnmx
% linear trend removal: differencing
% smoothing: averaging
% noise removal: dwt + reconsturction
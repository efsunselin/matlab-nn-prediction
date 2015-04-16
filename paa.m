function avg = paa(C, window, dataset, graphic)

% Author: Efsun Sarioglu
% Date: 2004

% computes PAA: Piecewise Aggregate Approximation
% C: time series 
% window: window size
% dataset: dataset name ( filename without extension)
% graphic: if 1, plots the processed data; otherwise not
% paa(T,64,'cpu1',1)

len = length(C);
M = len/window;
remainder = rem(len,window);
% if window size does not fit the data, then shift it: disregard first parts of the data
if (remainder>0)    
    T = C((remainder+1):len);
    C = T;
end

avg = [];
temp = 0;
index =1;
for i=1:M
    for j=1:window
        temp = temp + C(index);
        index = index+1;
    end
    averages(i) = temp/window;
    temp = 0;
end
% avg = averages';
avg = averages;
if (graphic)
    subplot(2,1,1);
    data{1} = C;
    t{1} = 'Original Data';
    PlotData(data,'Time (min)','Utilization (%)',t,dataset,1,1);
    subplot(2,1,2);
    data{1} = avg;
    t{1} = 'PAA';
    PlotData(data,'Time (min)','Utilization (%)',t,dataset,1,1);    
end
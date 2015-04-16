function [T, dataset, len, meanT, stdT] = LoadFile(fname, preprocess, graphics)

% Author: Efsun Sarioglu
% Date: Fall 2004

%   loads data from file and preprocesses if parameter set
%   filename : filename 
%   preprocess : if set to 1, data is normalized
%   graphics : if set to 1, raw and processed data plotted
%  [T, dataset, len, meanT, stdT] = LoadFile('cpu1.dat',1,1,0);

% fname = strcat('.\data\',filename);
input=load(fname);               
data=input(:,1);    
clear input; 
T = data';
len = length(data);
meanT = mean(T);
stdT = std(T);
time=0:1:len-1;
dataset=DatasetName(fname);
t1 = 'Original Data';
t2 = 'Offset Translation';
t3 = 'Amplitude Scaling';
t4 = 'Preprocessed Data';
x = 'Time';
y = 'Utilization';
if (preprocess)
%     meanT = mean(T)
%     stdT = std(T)
%     offset = T-meanT
%     amplitude = offset/stdT
% since data is scaled between 0-100, divide it by 100 to scale between 0-1
% for other unprocessed data, premmx should be used.
    % T=T/100; 
    [amplitude,meanT,stdT]=prestd(T);
    offset = T-meanT;
    if (graphics)
         % plot raw data
        temp{1} = T;
        t{1} = t1;
        PlotData(temp,x,y,t,dataset,1,1);
        pause;
        % plot offset translation
        temp{1} = offset;
        t{1} = t2;
        PlotData(temp,x,y,t,dataset,1,1);
        pause;
        % plot amplitude scaling
        temp{1} = amplitude;
        t{1} = t3;
        PlotData(temp,x,y,t,dataset,1,1);
        pause;
        % plot offset translation with raw data
        temp{1} = time;
        temp{2} = T;
        temp{3} = 'b';
        temp{4} = time;
        temp{5} = offset;
        temp{6} = 'r';
        t{1} = t1;
        t{2} = t2;        
        PlotData(temp,x,y,t,dataset,6,2);
        pause;        
        % plot amplitude scaling with raw data
        temp{6} = 'g';
        temp{5} = amplitude;
        t{2} = t3;
        PlotData(temp,x,y,t,dataset,6,2);
        pause;        
        % plot amplitude scaling and offset translation
        temp{2} = offset;
        temp{3} = 'r';
        t{1} = t2;
        PlotData(temp,x,y,t,dataset,6,2);
        pause;        
        % plot raw data, amplitude scaling and offset translation
        temp{7} = time;
        temp{8} = T;
        temp{9} = 'b';
        t{1} = t1;
        t{2} = t2;
        t{3} = t3;
        PlotData(temp,x,y,t,dataset,9,3)
        % plot preprocessed data
        temp{2} = amplitude;
        t{1} = t4;
        PlotData(temp,x,y,t,dataset,2,1);
        % plot original and offset translation
        subplot(2,1,1);
        temp{2} = T;
        t{1} = t1;
        PlotData(temp,x,y,t,dataset,2,1);
        subplot(2,1,2);
        temp{2} = offset;
        t{1} = t2;
        PlotData(temp,x,y,t,dataset,2,1);
        % plot original and amplitude scaling
        subplot(2,1,1);
        temp{2} = T;
        t{1} = t1;
        PlotData(temp,x,y,t,dataset,2,1);
        subplot(2,1,2);
        temp{2} = amplitude;
        t{1} = t3;
        PlotData(temp,x,y,t,dataset,2,1);
        % plot original and offset translation and amplitude scaling
        subplot(3,1,1);
        temp{2} = T;
        t{1} = t1;
        PlotData(temp,x,y,t,dataset,2,1);
        subplot(3,1,2);
        temp{2} = offset;
        t{1} = t2;
        PlotData(temp,x,y,t,dataset,2,1);
        subplot(3,1,3);
        temp{2} = amplitude;
        t{1} = t3;
        PlotData(temp,x,y,t,dataset,2,1);
    end     % if graphics
    T = amplitude;
    meanA = mean(T);        % mean of amplitude
    meanO = std(offset);    % std of offset
    stdO = mean(offset);    % mean of offset
end     % if preprocess
return;

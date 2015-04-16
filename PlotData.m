 function PlotData(data,x,y,t,dataset,length_data,length_title)    

% Author: Efsun Sarioglu
% Date: 12/11/2004

% Plots the data with the given parameters
% Data is cell array, it can have 5 different values: 1,2,3,6,9
% 1: 1 signal. x dimension is not given, only the data is used
% 2: 1 signal. x dimension is given. First one is time, second is the data
% 3: 1 signal. character is given.
% 6: 2 signals will be plotted, third and sixth parameters are the character for plotting ('+', 'm')
% 9: 3 signals, 3*(time, data, char) 
% x: xlabel
% y: ylabel
% t: title cell array
% 1: one data to plot (data=1,2,3)
% 2: 2 signals to plot (data=6)
% 3: 3 signal to plot (data=9)
% dataset: dataset name that is to be displayed in the title

% length_title: length of title list (the title cell may be longer)
% length_data: length of data cell array (the data cell may be longer)

if (length_title==1 & length_data ~= 3)
    header = strcat(t{1},' (b)');
else 
    header = strcat(t{1},' (', data{3},')');
    if (length_data>=6) % 6 or 9
        header = strcat(header,' - ',t{2},' (',data{6},')');
    end
    if (length_data==9)
        header = strcat(header,' - ',t{3},' (',data{9},')');
    end   
end

header = strcat(dataset, ' : ', header );

switch length_data
case 1, % 1 signal, without x data and character
    plot(data{1});
case 2, % 1 signal, without character 
    plot(data{1},data{2});
case 2, % 1 signal
    plot(data{1},data{2},data{3});
case 6, % 2 signals
    plot(data{1},data{2},data{3},data{4},data{5},data{6});
case 9, % 3 signals
    plot(data{1},data{2},data{3},data{4},data{5},data{6},data{7},data{8},data{9});    
end    

xlabel(x);
ylabel(y);
title(header); 
disp(strcat(header,' is plotted'));
disp('Press any key to continue');       
pause;
     
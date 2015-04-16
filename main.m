function [T, a, mse_total, std_total, r] = main(filename, index, n_list, preprocess_flag, feature, feature_parameter, predictionNN, graphic, preprocess_graphic, feature_graphic)

% Author: Efsun Sarioglu
% Date: Fall - Spring 2005
% Given a time series, predicts the next value based on the historic data

% input parameters
% filename: text file, data in columns
% index: index of the column. file can contain more than 1 columns
% n_list: window lengths in an array, or a single value
% n = [5 10 25 50 75 100]
% preprocess: if 1, preprocess the raw data; otherwise not
% feature: feature extraction method name
%           paa: Piecewise Aggregate Approximation
%           dwt: Discrete Wavelet Transform
%           in future: apca, dft, svd, pla
% feature_parameter: parameter that is to be passed to the feature extraction function
%                   paa: size of the window. i.e. 32,64
%                   dwt: method name. i.e. db1, db2,...,db45
% predictionNN: NN architecture that is to be used for the prediction process
% graphic: if 1, plot graphs; otherwise not
% preprocess_graphic: if 1, plot preprocessing graphs; otherwise not
%                     valid if preprocess flag is set to 1
% feature_graphic: if 1, plot feature extraction graphs; otherwise not
%                     valid if feature flag is set to 1
% usage:
% paa example:
% [T, a, error_mse, error_std, r] = main('cpu1.dat',1,64,1,'paa',32,'linear',1,0,1)
% dwt example:
% [T, a, error_mse, error_std, r] = main('cpu1.dat',1,64,1,'dwt',5,'linear',1,0,1)
% output parameters:
% T: processed data
% a: predicted data
% mse_total: mse of the error
% std_total: std of the error
% r: regression factor between target and actual ouput. i.e. r=1. perfect regression

[R, dataset, len, meanT, stdT] = LoadFile(filename,index,preprocess_flag, preprocess_graphic); % preprocess_flag, preprocess_graphic
if (feature=='paa')    
    T = paa(R,feature_parameter,dataset,feature_graphic);

else if (feature =='dwt')
        % feature_parameter : wavelet type
        % Daubechies (dbN), symlets (symN), coiflets (coifN)
       
%         level = wmaxlev(size(R),feature_parameter);
%         if (level>5)
%             level = 5;   
%         end;
% default: haar wavelet = db1
        [C,L] = wavedec(R,feature_parameter,'db1');
        T = appcoef(C,L,'db1'); % last coefficient
        
        % [T,L] = Decomposition(T,feature_parameter,14);
        % for better results thresholding with wdencmp can be applied
        % threshold = 35;        
        % [xc,cxc,lxc,perf0,perfl2] = wdencmp('gbl',R,feature_parameter,level,threshold,'h',1);
        % [THR,SORH,KEEPAPP] = ddencmp('cmp','wv',R);//for wdencmp
        % default
        % wavelet: haar = db1
        % gbl-lvd = global thredhold
        % hard-soft threshold = hard
        % keepapp = 1         
        % wavedec : Multilevel 1-D wavelet decomposition 
        % ddencmp : default parameters for compression
        % wdencmp : compression or denoising
        % dwt : Single-level discrete 1-D wavelet transform
        % wmaxlev: maximum level
        % detcoeff: detail coefficients
        % appcoef: approximation coefficients
        if (feature_graphic==1)
            subplot(2,1,1);
            data{1} = R;
            t{1} = 'Original Data';
            PlotData(data,'Time (min)','Utilization (%)',t,dataset,1,1);
            subplot(2,1,2);
            data{1} = T;
            t{1} = 'DWT';
            PlotData(data,'Time (min)','Utilization (%)',t,dataset,1,1);    
        end
    else
        T = R;
    end
end
% if (preprocess_flag ==1 & preprocess_graphic==1)
%     preprocess(T,dataset);
% end
% if (preprocess_flag==1)
%     T_before_preprocess = T;
%     [T, meanT,stdT] = prestd(T);    
% end
% prepca

%    T defines the signal in time to be predicted:
disp('Size of the dataset');
Q = length(T);
Q
time = 0:1:(Q-1);  
  
    %    Here is a plot of the signal to be predicted:

    if (graphic ==1)
        data{1} = time;
        data{2} = T;
        t{1} = 'Signal to be Predicted';
        PlotData(data,'Time (min)','Utilization (%)',t,dataset,2,1);
    end
    
len_n = length(n_list);
for (j=1:len_n)     % for each different n
     n = n_list(j);      
    switch predictionNN
    case 'linear',
        %    NEWLIND solves for weights and biases which will let
        %    the linear neuron model the system.
        % 1 - linear network
         P = zeros(n,Q);
         for i=1:n
             P(i,(i+1):Q) = T(1,1:(Q-i)); 
         end
        % training
        net = newlind(P,T); % solves for a linear layer
        % testing
        a = sim(net,P); 
        e = T - a;  
        P = zeros(5,Q);
        % get next value
        for i=1:n
             P(i,i:Q) = T(1,1:(Q-i+1)); 
        end        
        a2 = sim(net,P);        
        a2(Q)       
    case 'feedforward',
        % 2- feedforward network
        % can be customized
        % algorithm: trainlm
        % error goal
        % epoch
        % # of neurons: 5
        P = zeros(n,Q);
         for i=1:n
             P(i,(i+1):Q) = T(1,1:(Q-i)); 
         end
        net = newff(minmax(P),[5 1],{'tansig' 'purelin'});
        % training
        [net,tr] = train(net,P,T);
        % testing
        a = sim(net,P);
        pause;
        close;
        e = T - a;     
    % get next value
        for i=1:n
             P(i,i:Q) = T(1,1:(Q-i+1)); 
        end        
        a2 = sim(net,P);  
        a2(Q)
    case 'tdnn',      
        % backup
        T2=T;
        Pi=con2seq(T(1:2));
        P=con2seq(T(2:Q-1));
        T=con2seq(T(3:Q));
        net=newfftd(minmax(T2),[0 1 2],[5 1],{'tansig','purelin'});
        net.trainParam.epochs = 50;
        net= train(net,P,T,Pi); 
        a=sim(net,P,Pi);
        T = [T{:}];
        a = [a{:}];
        e= a - T;
        len = length(T);
        time = [1:len];
    case 'newlin',
    % 4- newlin - works
    % one neuron
    % lr = 0.001 - should be small
    % input delays:5
    % number of passes: 100
    % pf can also be used if further enhancement is needed
         P = T;
         Tseq = con2seq(T);
         Pseq = Tseq;
         lr = 0.001; % paa=0.01, dwt=0.001
         delays = [1:5];
         % 1 neuron, 1 output
         net = newlin(minmax(cat(2,Pseq{:})),1,delays,lr);
         net.adaptParam.passes=100;
         % training + testing
         [net,a,e,pf] = adapt(net,Pseq,Tseq);
         a=cat(2,a{:});
         e=cat(2,e{:});    
    case 'recurrent',
        % newelm
        % epochs:
        % goal:
        % neuron:
        % scale between 0 and 1
        % [T,minT,maxT] = premnmx(T);        
        % T = (T+1)/2;
        P = T;
        Pseq = con2seq(P);
        Tseq = con2seq(T);
        net = newelm(minmax(P),[100 1],{'tansig','purelin'});   % logsig
        net.trainParam.epochs=100;
%        net.trainParam.goal=;
        % training
        net = train(net,Pseq,Tseq);
        % testing
        a = sim(net,Pseq);
        pause;
        close;
        a = seq2con(a);
        a = a{:};
        e = T - a;
case 'rbf',
    % radial basis functions
    % aPost=a;
case 'adaptive',
    % 3- adaline - does not work
         P = T;
         Pi = {1 3};
         net = newlind(P,T,Pi);
         a = sim(net,P,Pi);
         e = T - a;
end

% TESTING
% trastd, tramnx
end
    %    The output signal is plotted with the targets.
    if (graphic ==1)        
        data{1} = time;
        data{2} = T;
        data{3} = '-';
        data{4} = time;
        data{5} = a;
        data{6} = '+';
        t{1} = 'Target Output (T)';
        t{2} = 'Actual Output (A)';
        PlotData(data,'Time (min)','Utilization (%)',t,dataset,6,2);
%         data{2} = T_before_preprocess;
%         data{5} = aPost;
%         t{1} = 'Target Output before procesing (T)';
%         t{2} = 'Actual Output after reconstruction (A)';
%         PlotData(data,'Time (min)','Utilization (%)',t,dataset,6,2);
        
    end

    % Error and Correlation

    disp('Standar Deviation of Error:');
    std_total(j) = std(e)
    mse_total(j) = mse(e);
    [m,b,r] = postreg(a,T);
    disp('Regression');
    pause;
    
    if (graphic ==1)
        data{2} = T;
        data{5} = a;
        t{1} = 'Target Output (T)';
        t{2} = 'Actual Output (A)';
        subplot(2,1,1);
        PlotData(data,'Time (min)','Utilization (%)',t,dataset,6,2);        
        subplot(2,1,2);
        data{2} = e;
        t{1} = 'Error Signal';
        PlotData(data,'Time (min)','Error',t,dataset,2,1);
        subplot(1,1,1);
        PlotData(data,'Time (min)','Error',t,dataset,2,1);        
%         data{2} = mse(e);
%         t{1} = 'MSE';
%         PlotData(data,'Time','MSE',t,dataset,2,1);
%         hold on
%         plot([min(time) max(time)],[0 0],':r')
%         hold off
    end

% RECONSTRUCTION
% poststd, postmnx, idwt, waverec
% not meaningful 
if (feature=='dwt')
    len = length(a);
    C2= C;
    C2(1:len) = a;
    X = waverec(C2,L,'haar');
    disp('Reconstructed');
    plot(X);
    pause;
end
% aPost = poststd(a,meanT,stdT);
% if (graphic==1)
%     subplot(2,1,1);
%     data{2} = aPost;
%     t{1} = 'Reconstructed Output';
%     PlotData(data,'Time (min)','Utilization (%)',t,dataset,2,1);        
%     subplot(2,1,2);
%     data{2} = T_before_preprocess;
%     t{1} = 'Input before preprocess';
%     PlotData(data,'Time (min)','Utilization (%)',t,dataset,2,1);        
% end
% plot the mse and std of error
% if there are more than one window size specified
if (graphic==1 & len_n >1)
    data{1} = n_list;
    data{2} = mse_total;
    t{1} = 'Mean Square Error';
    PlotData(data, 'Window Size','MSE',t,dataset,2,1);
    data{2}=std_total;
    t{1} = 'Standar Deviation';
    PlotData(data,'Window Size','STD',t,dataset,2,1);
end

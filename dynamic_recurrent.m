function [a,e,tr,next] = dynamic_recurrent(T,S,epochs)
% static_linear - Static linear network for time series prediction
% Uses a sliding window of length w
% no validation data
% k-step ahead is handled by recursion, multiple neurons did not work

% Syntax:  [a,e,aTest,eTest,next] = static_nonlinear(P,validation,w,k,S,epoch,T_test)

% Inputs:
%    T          - network target (also input)
%    w          - sliding window size
%    k          - # of steps ahead prediction
%    S          - number of neurons
%    T_test     - test dataset 

% Outputs:
%    a      - network output
%    e      - network error
%    tr     - training record (validation,test)
%    next   - k-step ahead predictions

% Example: 
%    [a,e,tr,next] = static_nonlinear(P,100,32,5,50,100,test)

% Author: Efsun Sarioglu
% University of Arkansas at Little Rock
% Computer Science Department
% email: essarioglu@ualr.edu
% May 2005; Last revision: 12-May-2005

% newff
% parameters
% training function: trainlm (default), trainbfg, trainrp (slower but more memory efficient)
% learning function: learngd, learngdm
% performance function: mse(default), msereg
%------------- BEGIN CODE --------------
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
 %------------- END OF CODE --------------
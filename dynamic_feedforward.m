function [a,e,tr,next] = dynamic_feedforward(T,delay,k,S,epoch,QV,T_test)
% dynamic_feedforward - Dynamic feedforward network for time series prediction
% Uses a Tapped Delay Line (TDL) length delay

% Syntax:  [a,e,tr,next] = dynamic_feedforward(P,delay,k,S,epoch,QV,T_test)

% Inputs:
%    T          - network target (also input)
%    delay      - TDL length
%    k          - # of steps ahead prediction
%    S          - number of neurons
%    epoch      - maximum number of epochs
%    QV         - validation set size
%    T_test     - test dataset 

% Outputs:
%    a      - network output
%    e      - network error
%    tr     - training record (validation,test)
%    next   - k-step ahead predictions

% Example: 
%    [a,e,tr,next] = dynamic_feedforward(P,5,5,50,100,100,test)

% Author: Efsun Sarioglu
% University of Arkansas at Little Rock
% Computer Science Department
% email: essarioglu@ualr.edu
% May 2005; Last revision: 12-May-2005

% newfftd
% parameters
% training function: trainlm (default), trainbfg, trainrp (slower but more memory efficient)
% learning function: learngd, learngdm
% performance function: mse(default), msereg
%------------- BEGIN CODE --------------
T2 = T;
Q = length(T);
QTR = Q - QV;
QT = length(T_test);
V=[];
Test=[];
% training
Pi = con2seq(T(QV+1:QV+delay));
P = con2seq(T(QV+delay+1:Q-1));
T = con2seq(T(QV+delay+2:Q));
% validation
if (QV>0)
    V.Pi = con2seq(T2(1:delay));
    V.P = con2seq(T2(delay:Q-1));
    V.T = con2seq(T2(delay+1:Q));
end
% test
if (QT>0)
    Test.Pi = con2seq(T_test(1:delay));
    Test.P = con2seq(T_test(delay:QT-1));
    Test.T = con2seq(T_test(delay+1:QT));
end
% network design
% parameters
% training algorithm: trainlm (default) trainbfg, trainrp
% learning algroithm: learngdm (default) learngd
% performance function: mse (default) msereg
% delays [1:delay]
net = newfftd(minmax(T2),[0:delay],[S 1],{'tansig','purelin'});
net.trainParam.epochs = epoch;
% training
[net,tr,Y,E,Pf] = train(net,P,T,Pi,'',V,Test); 
a = sim(net,P,Pi);
T = [T{:}];
a = [a{:}];
e = a - T;
%------------- END OF CODE --------------
function [a,e,tr,next] = static_nonlinear(T,w,k,S,epoch,QV,T_test)
% static_nonlinear - Static nonlinear network for time series prediction
% Uses a sliding window of length w

% Syntax:  [a,e,tr,next] = static_nonlinear(P,w,k,S,epoch,QV,T_test)

% Inputs:
%    T          - network target (also input)
%    w          - sliding window size
%    k          - # of steps ahead prediction
%    S          - number of neurons
%    epoch      - maximum number of epochs
%    QV         - validation set length
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
% prepare sliding window
Q = length(T);
QT = length(T_test);
QTR = Q-QV;
V = [];
V.T = T(1:QV);
P = zeros(w,QTR);
for i=1:w
    P(i,(i+1):QTR) = T(1,QV+1:(Q-i)); 
    if (QV>0)
        V.P(i,(i+1):QV) = V.T(1,1:(QV-i));     
    end
    if (QT>0)
        P_test(i,(i+1):QT) = T_test(1,1:(QT-i)); 
    end
end
T = T(QV+1:Q);
% for (j=1:k)
%    T(j,(j+1):QTR) = T(1,1:(QTR-j)); 
% end
if (QT>0)
    Test.P = P_test;
    Test.T = T_test;
end
% design
net = newff(minmax(P),[S 1],{'tansig' 'purelin'});
net.trainParam.epochs = epoch;

% training
% tr: training record (epoch,perf)
[net,tr,a,e] = train(net,P,T,'','',V,Test);
% a = sim(net,P); 
% e = T - a;               

% recursive k step ahead prediction
l=QTR;
for j=1:k
    P = zeros(w,l);
    for i=1:w
        P(i,i:l) = T(1,1:(l-i+1)); 
    end        
    a2 = sim(net,P);        
    next(j) = a2(l);
    l=l+1;
    T(l)=a2(QTR);
end

%------------- END OF CODE --------------
       
 
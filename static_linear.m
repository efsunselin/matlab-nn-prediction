function [a,e,aTest,eTest,next] = static_linear(T,w,k,T_test)
% static_linear - Static linear network for time series prediction
% Uses a sliding window of length w
% no validation data
% k-step ahead is handled by recursion, multiple neurons did not work

% Syntax:  [a,e,aTest,eTest,next] = static_linear(P,validation,w,k,t_Test)

% Inputs:
%    T          - network target (also input)
%    w          - sliding window size
%    k          - # of steps ahead prediction
%    T_test     - test dataset 

% Outputs:
%    a      - network output
%    e      - network error
%    aTest  - test data output
%    eTest  - test data error
%    next   - k-step ahead predictions

% Example: 
%    [a,e,aTest,eTest,next] = static_linear(P,100,32,5,test)

% Author: Efsun Sarioglu
% University of Arkansas at Little Rock
% Computer Science Department
% email: essarioglu@ualr.edu
% May 2005; Last revision: 12-May-2005
%------------- BEGIN CODE --------------
% prepare sliding window
Q= length(T);
P = zeros(w,Q);
for i=1:w
    P(i,(i+1):Q) = T(1,1:(Q-i)); 
end
% training
net = newlind(P,T); % solves for a linear layer
a = sim(net,P); 
e = T - a;               
% recursive k step ahead prediction
% get next value
l=Q;
for j=1:k
    P = zeros(w,l);
    for i=1:w
        P(i,i:l) = T(1,1:(l-i+1)); 
    end        
    a2 = sim(net,P);        
    next(j) = a2(l);
    l=l+1;
    T(l)=a2(Q);
end

% testing
Q_test = length(T_test);
if (Q_test>0)
    P_test = zeros(w,Q_test);
    for i=1:w
        P_test(i,(i+1):Q_test) = T_test(1,1:(Q_test-i)); 
    end
    aTest = sim(net,P_test);        
    eTest =  T_test - aTest;
else
    aTest = [];
    eTest = [];
end
%------------- END OF CODE --------------



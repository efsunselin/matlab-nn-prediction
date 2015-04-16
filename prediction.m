function [a, e] = prediction(T, net, params)
% Author: Efsun Sarioglu
% Spring 05
% Given the input data, network type and some parameters, function predicts the next value in the input
% Parameters:
    % T: input data
    % net: network type
        % linear
        % adaptive linear
        % feedforward: nonlinear
        % elman: recurrent
    % params: cell array consisting of 
        % 1. n: window or TDL length
        % 2. neuron: # of neurons
        % 3. lr: learning rate
        % 4. epochs: # of epochs to converge
        % 5. goal: error goal to reach
        % 6. training algorithms
        % 7. transfer function
    % training, testing
% iterative forecasting should be added
% assign default values
n = 64;
neuron = 5;
l2 = 0.001;
epochs=100;
goal = 0;

n = params{1};
neuron = params{2};
lr = params{3};
epochs = params{4};
goal = params{5};

len = length(T);
switch net
    case 'linear',
         %    NEWLIND solves for weights and biases which will let
         %    the linear neuron model the system.
         % network output is the predicted output
         % P does not include the final value of T so that we can compute the error
         % by comparing the original and predicted value
         P = zeros(n,Q);
         for i=1:n
             P(i,(i+1):Q) = T(1,1:(Q-i)); 
         end
        % training
        net = newlind(P,T); % solves for a linear layer
        a = sim(net,P); 
        e = T - a;               
        % get next value
        P = zeros(n,Q);
        % include the last value of T, so that final output of the network will be 1 step ahead prediction
        for i=1:n
             P(i,i:Q) = T(1,1:(Q-i+1)); 
        end        
        a = sim(net,P);        
        next = a(len);
    case 'adaptive',
        % NEWLIN generates a linear network
            % one neuron ==> 1 output
            % lr = 0.001 - should be small, paa=0.01, dwt=0.001
            % input delays: n
            % number of passes: 100
            % pf can also be used if further enhancement is needed
         P = T;
         Tseq = con2seq(T);
         Pseq = Tseq;               
         delays = [1:n];
         net = newlin(minmax(cat(2,Pseq{:})),1,delays,lr);
         net.adaptParam.passes = 100;
         % training
         [net,a,e,pf] = adapt(net,Pseq,Tseq);
         a = cat(2,a{:});
         e = cat(2,e{:});        
    case 'feedforward',   
        % NEWFF designs a nonlinear network (tansig)
            % algorithm: default trainlm
            % error goal:default 0
            % epoch: default 100
            % # of neurons: 5
        P = zeros(n,Q);
         for i=1:n
             P(i,(i+1):Q) = T(1,1:(Q-i)); 
         end
        net = newff(minmax(P),[neuron 1],{'tansig' 'purelin'});
        net.trainParam.epochs = epochs;
        % training
        [net,tr] = train(net,P,T);
        a = sim(net,P);
        pause;
        close;
        e = T - a;        
         % get next value
        P = zeros(n,Q);
        % include the last value of T, so that final output of the network will be 1 step ahead prediction
        for i=1:n
             P(i,i:Q) = T(1,1:(Q-i+1)); 
        end        
        a = sim(net,P);        
        next = a(len);
    case 'elman',
        % NEWELM: designs a recurrent layer
            % epochs:default 100
            % goal: default 0
            % neuron: default 100
        P = T;
        Pseq = con2seq(P);
        Tseq = con2seq(T);
        net = newelm(minmax(P),[neuron 1],{'tansig','purelin'});   
        net.trainParam.epochs = epochs;
%        net.trainParam.goal=;
        % training
        net = train(net,Pseq,Tseq);
        a = sim(net,Pseq);
        pause;
        close;
        a = seq2con(a);
        a = a{:};
        e = T - a;
    case 'rbf',
        % radial basis functions
    case 'adaline',
        % 3- adaline - does not work
        P = T;
        Pi = {1 3};
        net = newlind(P,T,Pi);
        a = sim(net,P,Pi);
        e = T - a;
end
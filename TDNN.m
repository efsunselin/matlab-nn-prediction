function Y = TDNN(r, neuron, step, delay)
% Author: Efsun Sarioglu
% Spring 2005
% Time Delay Neural Network (TDDN)
% newfftd: feed forward network with tap delay line
% ID: Input Delay t-1, t-2, t-3 --> ID = [1 2 3]
% TDNN(T, neuron, step, delay)
% T: input signal to be predicted
% neuron: number of neurons 
% step: # of steps ahead
% delay: tap delay line length
% TDNN(T,5,1,3)
% len = length(Z);
% Pi = con2seq(Z(:,1:delay-1)); % Pi = con2seq(Z(:,1:delay-1));
% P = con2seq(Z(:,delay:len-step));
% T = con2seq(Z(:,delay+1:len-step+1));;
% delays = [0:delay-1];   % [0 1 2]
% net = newfftd(minmax(Z),delays,[neuron step]);
% net.trainparam.epochs = 500;
% net = train(net,P,T,Pi);    % net = train(net,P,T,Pi);
% Y = sim(net,P,Pi);  % Y = sim(net,P,Pi);  
% e = [Y{:}]-[T{:}];
% plot(e);
% pause;
len=length(r);
pi=con2seq(r(1:2));
p=con2seq(r(2:len-1));
t=con2seq(r(3:len));
net=newfftd(minmax(r),[0 1 2],[5 1],{'tansig','purelin'});
net.trainParam.epochs = 50;
net= train(net,p,t,pi); 
y=sim(net,p,pi);
e=[y{:}]-[t{:}];
title('Error');
plot(e);
pause;
time=[1:len-2];
T = [t{:}];
Y = [y{:}];
title('Actual(+) and target output');
plot(time,T,'-',time,Y,'+');
pause;

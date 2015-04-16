P2 = zeros(n,Q2);
for i=1:n
             P2(i,(i+1):Q2) = T2(1,1:(Q2-i)); 
         end
        net = newlind(P1,T1); % solves for a linear layer
        % testing
        a1 = sim(net,P1); 
        e1 = T1 - a1;  
        
         
a2=sim(net,P2);
e2=T2-a2;
%          for i=1:n
%              P1(i,(i+1):Q1) = T1(1,1:(Q1-i)); 
%          end       
%         net2 = newff(minmax(P1),[5 1],{'tansig' 'purelin'});
%         [net2,tr] = train(net2,P1,T1);
%         a1 = sim(net,P1);
%         e1 = T1 - a1; 
%         a2=sim(net,P2);
%         e2=T2-a2;
 [C2,L2] = wavedec(R2,5,'db1');
 T2 = appcoef(C2,L2,'db1'); % last coefficient
       
 
  for i=1:n  
             P(i,(i+1):Q) = T(1,1:(Q-i));      
  end
  
  for i=1:5
     T2(i,1:Q)=T(1,1:Q);
  end
  
  
  
        P = T;
        Pseq = con2seq(P);
        Tseq = con2seq(T2);
        net = newelm(minmax(P),[50 5],{'tansig','purelin'});   % logsig
        net.trainParam.epochs=100;
        
        
         lr = 0.01; % paa=0.01, dwt=0.001
         delays = [1:5];
         % 1 neuron, 1 output
         net = newlin(minmax(cat(2,Pseq{:})),5,delays,lr);
         net.adaptParam.passes=100;
         % training + testing
         [net,a,e,pf] = adapt(net,Pseq,Tseq);
         a=cat(2,a{:});
         e=cat(2,e{:}); 
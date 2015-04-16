function 
%    NEWLIND solves for weights and biases which will let
         %    the linear neuron model the system.
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
        for i=1:n
             P(i,i:Q) = T(1,1:(Q-i+1)); 
        end        
        a = sim(net,P);        
        next = a(len);
function P = LinearTrend(T)
% Author: Efsun Sarioglu
% Spring 05
% removes linear trend bydifferencing
% length of the dataset reduces by 1
len = length(T);
for (i=2:len)
    temp = T(i)-T(i-1);
    P(i-1)= temp;
end
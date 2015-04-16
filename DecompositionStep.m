function C2 = DecompositionStep(C ,h)
sqrt2 = 2; % sqrt(2);
for (i=1:h/2)
    i2 = 2*i;
    C2(i) = (C(i2-1)+C(i2))/sqrt2;
    C2(h/2+i) = (C(i2-1)-C(i2))/sqrt2;
end


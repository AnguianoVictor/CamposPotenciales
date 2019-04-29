function GA=campopot(Ux,Uy,sig,M)
[f,c]=size(M);

for i=1:f
    for j=1:c
        GA(i,j)=exp(-((i-0.5*Ux)^2+(j-0.5*Uy)^2)/(2*(sig^2)));
    end
end
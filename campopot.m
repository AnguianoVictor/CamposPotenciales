function GA=campopot(Ux,Uy,sig,M)
[f,c]=size(M);

for i=1:f
    for j=1:c
        GA(i,j)=exp(-((i-Ux)^2+(j-Uy)^2)/(2*(sig^2)));
    end
end
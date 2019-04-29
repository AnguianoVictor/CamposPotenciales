function [ xc,yc ] = centroide( im ,columnas)

fy=(sum(im,2)');
fx=sum(im,1);
x=1:length(fx);
y=1:length(fy);


yc=columnas-sum(y.*fy)/sum(fy);
xc=sum(x.*fx)/sum(fx);

end


function [I] = UmbralBase( ima )
%UMBRALBASE Summary of this function goes here
%   Detailed explanation goes here

[filas,columnas]=size(ima);
for i=1:filas
    for j=1:columnas
        if ima(i,j) >= 250 
            I(i,j)=255;
        else
            I(i,j)=0;
        end
    end
end
end


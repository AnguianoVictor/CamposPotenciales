function [I] = UmbralBase( ima, superior,inferior)
%UMBRALBASE Summary of this function goes here
%   Detailed explanation goes here

[filas,columnas]=size(ima);
for i=1:filas
    for j=1:columnas
        if ima(i,j) >= superior && ima(i,j) <= inferior 
            I(i,j)=255;
        else
            I(i,j)=0;
        end
    end
end
end


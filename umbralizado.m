function [I] = umbralizado(ima,umbral)
[filas,columnas]=size(ima);
for i=1:filas
    for j=1:columnas
        if ima(i,j) >= umbral && ima(i,j)<254
            I(i,j)=255;
        else
            I(i,j)=0;
        end
    end
end
end


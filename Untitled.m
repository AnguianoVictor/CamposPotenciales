clc, clear, close all

ima=imread('Laberinto.bmp');
figure,imshow(ima)
gris=double(rgb2gray(ima));
[filas,columnas]=size(gris);

imaR=ima(:,:,1);
imaG=double(ima(:,:,2));
imaB=double(ima(:,:,3));
Immovil = UmbralBase(imaG);
Immeta = UmbralBase(imaB);
figure,imshow(Immeta);
figure,imshow(Immovil);

[metaXc, metaYc] = centroide(Immeta,filas);
[movilXc, movilYc] = centroide(Immovil,filas);
obstaculos=zeros(2,3);
num_obs = 3;
for a=1:num_obs
     [obstaculos(1,a), obstaculos(2,a)] = centroide(umbralizado(ima(:,:,a),125),filas);
end 
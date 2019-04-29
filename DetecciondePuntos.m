clc, clear, close all
ima=imread('Laberinto.bmp');
gris=double(rgb2gray(ima));
[filas,columnas]=size(gris);
imaR=ima(:,:,1);
imaG=double(ima(:,:,2));
imaB=double(ima(:,:,3));
Immovil = UmbralBase(imaG);
Immeta = UmbralBase(imaB);
[metaXc, metaYc] = centroide(Immeta,filas);
[movilXc, movilYc] = centroide(Immovil,filas);
obstaculos=zeros(2,3);
num_obs = 3;
for a=1:num_obs
     [obstaculos(1,a), obstaculos(2,a)] = centroide(umbralizado(ima(:,:,a),125),filas);
end 

tam = 373;
meta=[round(metaXc) round(metaYc)];
movil=[round(movilXc) round(movilYc)];

M=zeros(tam);

for i=1:length(obstaculos)
    M= M + campopot(2.2*obstaculos(1,i),2.2*obstaculos(2,i),10,M);
end
%%Graficamos la meta
M=M-campopot(2.2*meta(2),2.2*meta(1),180,M);
figure,mesh(M);

[x,y]=meshgrid([1:tam],[1:tam]);
[Gx,Gy]=gradient(-M);
figure,quiver(x,y,Gx,Gy);
G = sqrt(Gx.^2+Gy.^2);
figure, imshow(ima);
c1 = movil(1);
c2 = movil(2);
Gx(c1,c2)
Gy(c1,c2)
radii = 3;
iter = 0;
while(c1~=double(0) && c2~=double(0)) %Condición de encuentro de valle.
    iter = iter + 1;
    centers = [c1 filas-c2];
    viscircles(centers,radii,'Color','w'); % Dibujar circulo
    drawnow
    pause(.1)
    vy = Gx(c1,c2);                 % Los datos de retorno de la funcion estan invertidos
    vx = Gy(c1,c2);
    %fprintf('%f y %f es %d y %d\r\n',vx,vy,c1,c2);
    % Coordenadas para el movimiento
    if vx<=0
        c1=c1-1;
    else
        c1=c1+1;
    end
    if vy<=0
        c2=c2-1;
    else
        c2=c2+1;
    end

    if iter >=400
        break;
    end
end
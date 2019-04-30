clc, clear, close all
% Lectura de imagen y muestra
ima=imread('Negro1.bmp');
%figure,imshow(ima);
% Imagen en escala de grises. 
gris = rgb2gray(ima);

% Dimensionamiento de imagen.
[filas,columnas] = size(gris);

% Segmentacion de imagen
imaR=ima(:,:,1);
imaG=ima(:,:,2);
imaB=ima(:,:,3);
    % Obstaculos
Imobs = UmbralBase(imaR,180,255);
[centers,radii] = imfindcircles(Imobs,[10 25],'ObjectPolarity','bright','Sensitivity',0.92);
    % Movil
Immovil = UmbralBase(imaG,150,189);
[centersMovil,radiiMovil] = imfindcircles(Immovil,[10 25],'ObjectPolarity','bright','Sensitivity',0.92);
    % Meta
Immeta = UmbralBase(imaB,200,255);
[centersMeta,radiiMeta] = imfindcircles(Immeta,[20 50],'ObjectPolarity','bright','Sensitivity',0.92);
% Coordenadas de meta, movil y obstaculos. 
metaXc = centersMeta(1);        % x=239   
metaYc = centersMeta(2);        % y=92
movilXc = centersMovil(1);      % x=57
movilYc = centersMovil(2);      % y=303
obstaculos = centers;           % x1=165 y1=206 x2=198 y2=299 x3=95 y3=141

 tam = filas;
% Redondeo de coordenadas. 
meta=[round(metaXc) round(metaYc)];
movil=[round(movilXc) round(movilYc)];
% 
M=zeros(columnas,filas);
% 
 for i=1:length(obstaculos)
     M= M + campopot(obstaculos(i,1),obstaculos(i,2),10,M);
 end
% Graficamos la meta junto con los obstaculos. 
M = M-campopot(meta(1),meta(2),190,M);
figure,mesh(M);

%Obtencion de la matriz de velocidades.
[x,y]=meshgrid(1:filas,1:columnas);
[Gx,Gy]=gradient(-M);
figure,quiver(x,y,Gx,Gy);

% Imagen donde se simulara el movimiento 
figure, imshow(ima);

% Posicion inicial del movil.
c1 = movil(1);
c2 = movil(2);
Gx(c1,c2);
Gy(c1,c2);
radii = 2;
iter = 0;
world = vrworld('modelo.wrl'); 
open(world);
fig = view(world, '-internal'); 
vrdrawnow;
while(c1~=double(0) && c2~=double(0)) %Condición de encuentro de valle.
    iter = iter + 1;
    centers = [c1 c2];
    viscircles(centers,radii,'Color','g'); % Dibujar circulo
    drawnow
    pause(.1)
    vy = Gx(c1,c2);                 % Evaluacion del campo potencial en la nueva posicin
    vx = Gy(c1,c2);
    %fprintf('%f y %f es %d y %d\r\n',vx,vy,c1,c2);
    
    % Algortimo para el movimiento
    if vx<=0
        c1=c1-2;
    else
        c1=c1+2;
    end
    if vy<=0
        c2=c2-2;
    else
        c2=c2+2;
    end

    if iter >=400
        break;
    end
    world.Exported_transform.translation=[c1/10 -0.26 c2/10]; 
    %Cambia la propiedad de rotación del carro
    world.Exported_transform.rotation=[0 0 0 66];
    vrdrawnow;
end



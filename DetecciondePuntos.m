clc,clear,close all
% Lectura de imagen y muestra
    ima=imread('Negro1.bmp');
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
% Creacion de matriz para colocar las gaussianas
    M=zeros(columnas,filas);    
% Colocación de gaussianas en las coordenadas de los obstaculos
     for i=1:length(obstaculos)
         M= M + campopot(obstaculos(i,1),obstaculos(i,2),10,M);
     end
% Graficamos la meta junto con los obstaculos. 
    M = M-campopot(meta(1),meta(2),190,M);
%Obtencion de la matriz de velocidades.
    [x,y]=meshgrid(1:filas,1:columnas);
    [Gx,Gy]=gradient(-M);
    %figure,quiver(x,y,Gx,Gy);
% Posicion inicial del movil.
    c1 = movil(1);
    c2 = movil(2);
    Gx(c1,c2);
    Gy(c1,c2);
    iter = 0;

% Comienzo de simulación, se crea una figura y se guarda en la variable
% para modificar sus propiedades
    fig = figure;
    hold on
    fig.Children.Visible = 'off';
    fig.Children.Clipping = 'off';
    fig.Children.Projection = 'orthographic';

% Se agrega el objeto STL
stl = stlread('test.stl');                       %Se lee los datos del objeto
                                                %y se guarda en la variable fv
p1 = patch(stl,'FaceColor',       'yellow', ...  %Se le da color amarillo 
         'EdgeColor',       'none',        ... %Color de bordes
         'FaceLighting',    'gouraud',     ...   %Iluminacion de curvas
         'AmbientStrength', 0.15);               %Iluminacion del entorno
vert = p1.Vertices;                         %Se guarda todos los vertices del objeto stl
material('metal')           %Se le da la propiedad de color metalico
% Se genera una superficie con la textura de la imagen tomada. 
    texture = imread('Negro1.bmp');
    ground = ones(2);
    groundSurf = surf(linspace(1,293*7,size(ground,1)),linspace(1,391*7,size(ground,2)),ground,'LineStyle','none','AmbientStrength',0.3,'DiffuseStrength',0.8,'SpecularStrength',0,'SpecularExponent',10,'SpecularColorReflectance',1);
    groundSurf.FaceColor = 'texturemap';
    groundSurf.CData = texture;

% Se agrega la propiedad de luz a la camara. 
    camlight('headlight');
% Valor del angulo de vision
    camva(55); 

% Variables de rotación y posicion inicial
rot = eye(3,3); %Initial plane rotation
pos = [c1*7, c2*7,130]; %Initial plane position
hold off
axis([100 340 100 340 110 230])

p1.Vertices = (rot*vert')' + repmat(pos,[size(vert,1),1]);
while(c1~=double(0) && c2~=double(0)) %Condición de encuentro de valle.
    iter = iter + 1;
    centers = [c1 c2];
    vy = Gx(c1,c2);                 % Evaluacion del campo potencial en la nueva posicin
    vx = Gy(c1,c2);
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
    
    pos = [7*c1 7*c2 130];
    p1.Vertices = (rot*vert')' + repmat(pos,[size(vert,1),1]);
    if iter >=120
        break;
    end
    pause(.1)
end



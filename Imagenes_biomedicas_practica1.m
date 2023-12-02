%iMAGENES BIOMEDICAS

%% 

%apartado 1) dicominfo('im5') o dicomread('im5')
imagen=dicomread('im5');
imagen_info=dicominfo('im5');

imshow(imagen)
figure(1)

%apartado 2) imhist(imagen), xlim([0,2000])
%% 

max_imagen=max(max(imagen)); %536 
figure(2)
imshow(imagen,[0,max_imagen])
%con los percentiles sería 
%p1 = prctile(imagen(:), 1);
%p99 = prctile(imagen(:), 99);
%imshow(imagen, [p1, p99]);
%% 

figure(3)
[~, ~]=imhist(imagen); 
imhist(imagen, 65535) 
axis([0 max_imagen 0 2200])
%xlim([0,max_imagen])
%% 
%algoritmo:;
i=double(imagen);
[filas, columnas]=size(imagen);
for i=1:65535
    h(i)=0;
end
for i= 1:filas
    for j=1:columnas
        k=imagen(i,j);
        h(k+1) = h(k+1)+1;
    end
end
figure(4)
plot(h)
axis([0 max_imagen 0 2200])
%% apartado 3

figure(5)
imshow(imagen, [50, 225])%valores donde yo veo mayor diferencia entre el tumor 
% y el cerebro

%% apartado 4
%Cargamos la imagen y la ajustamos automaticamente
imagen=dicomread('im5');
imagen_ajustada=imadjust(imagen);
figure(6)
imshow(imagen_ajustada) %Visualizacion de la imagen
%J = imadjust(I,[LOW_IN; HIGH_IN],[LOW_OUT; HIGH_OUT],gamma=1)
%% 

%negativo de la imagen:
%J = imadjust(I,[LOW_IN; HIGH_IN],[LOW_OUT; HIGH_OUT],gamma=1) se consigue
%cambiando el low_out por el high_out y visceversa, en este caso:
imagen_negativo = imadjust(imagen_ajustada,[0; 1],[1; 0],1);
figure(7)
imshow(imagen_negativo)
%%

%Correccion gamma =2:
%J = imadjust(I,[LOW_IN; HIGH_IN],[LOW_OUT; HIGH_OUT],gamma=2) se consigue
imagen_gamma2 = imadjust(imagen_ajustada,[0; 1],[0; 1],2);
figure(8)
imshow(imagen_gamma2)

%% 

%Ajuste y=sqrt(x), es decir gamma=0,5
%J = imadjust(I,[LOW_IN; HIGH_IN],[LOW_OUT; HIGH_OUT],gamma=0.5) se consigue
imagen_sqrtgamma = imadjust(imagen_ajustada,[0; 1],[0; 1],0.5);
figure(9)
imshow(imagen_sqrtgamma)
%% 
% imshow(imagen, [50, 225])
v=[50,225];
v=v/65535;
imagen_optima= imadjust(imagen,[v(1); v(2)],[0; 1]);
figure(10)
imshow(imagen_optima)
%% 
%con los percentiles se podría calcular con stretchlim(imagen,[0.01,0.99])
%o con p1 = prctile(imagen(:), 1) y p99 = prctile(imagen(:), 99);
[p] = stretchlim(imagen,[0.01,0.99]);
imagen_nueva= imadjust(imagen,[p(1);p(2)],[0; 1]);
figure(11)
imshow(imagen_nueva)

%% 
figure('Name', 'casos anteriores')
subplot(2,3,1);
imshow(imagen_ajustada)
title('imagen automatica')
subplot(2,3,2);
imshow(imagen_negativo)
title('imagen negativa')
subplot(2,3,3);
imshow(imagen_gamma2)
title('imagen gamma=2')
subplot(2,3,4);
imshow(imagen_sqrtgamma)
title('imagen gamma=0.5')
subplot(2,3,5);
imshow(imagen_optima)
title('imagen optima')
subplot(2,3,6);
imshow(imagen_nueva)
title('imagen con percentil 5 y 95')

%% 
%programar algoritmo de la funcion gamma 0,5

imagen=dicomread('im5');
imagen_ajustada=imadjust(imagen);
figure('Name', 'comparación')
subplot(1,2,1);
imagen_sqrtgamma = imadjust(imagen_ajustada,[0; 1],[0; 1],0.5);
imshow(imagen_sqrtgamma)
title('imagen automatica')
subplot(1,2,2);
imshow(ajuste_gamma_sqrt(imagen))
title('algoritmo propio')

%% 
imagen=dicomread('im5');
imagen_ajustada=imadjust(imagen);
figure('Name', 'comparación')
subplot(2,3,1);
imagen_sqrtgamma = imadjust(imagen_ajustada,[0; 1],[0; 1],0.5);
imshow(imagen_sqrtgamma)
title('imagen automatica')
subplot(2,3,2);
imshow(ajuste_gamma_sqrt(imagen))
title('algoritmo con 0 y 1')
subplot(2,3,3);
imshow(ajuste_gamma_sqrt(imagen,0.1,0.9))
title('algoritmo con 0.1 y 0.9')
subplot(2,3,4);
imshow(ajuste_gamma_sqrt(imagen,0.2,0.8))
title('algoritmo con 0.2 y 0.8')
subplot(2,3,5);
imshow(ajuste_gamma_sqrt(imagen,0.2,0.7))
title('algoritmo con 0.2 y 0.7')
subplot(2,3,6);
imshow(ajuste_gamma_sqrt(imagen,0.3,0.8))
title('algoritmo con 0.3 y 0.8')

%% 5 guardar las imagenes
imwrite(imagen,"imagen_original.png");
imwrite(imagen_ajustada,"imagen_ajustada.png");
imwrite(imagen_negativo,"imagen_negativo.png");
imwrite(imagen_gamma2,"imagen_gamma2.png");
imwrite(imagen_sqrtgamma,"imagen_sqrtgamma.png");
imwrite(imagen_optima,"imagen_optima4.png");
imwrite(imagen_nueva,"imagen_percentiles5_95.png");

%% 5.2 uint8( y jpg

imwrite(uint8(imagen),"imagen_original.jpg");
imwrite(uint8(imagen_ajustada),"imagen_ajustada.jpg");
imwrite(uint8(imagen_negativo),"imagen_negativo.jpg");
imwrite(uint8(imagen_gamma2),"imagen_gamma2.jpg");
imwrite(uint8(imagen_sqrtgamma),"imagen_sqrtgamma.jpg");
imwrite(uint8(imagen_optima),"imagen_optima4.jpg");
imwrite(uint8(imagen_nueva),"imagen_percentiles5_95.jpg");
%%
% algoritmo de mejora gamma = 0.5 

function resultado=ajuste_gamma_sqrt(imagen,low_in, high_in)
if nargin < 2
    low_in = 0;
end
if nargin < 3
    high_in = 1;
end

imagen=double(imagen);
imagen = mat2gray(imagen);
[filas, columnas]=size(imagen);
resultado=zeros(filas,columnas);
for i=1:filas
    for j=1: columnas
        pixel=imagen(i,j);
        if (pixel >= low_in && pixel <= high_in)
            resultado(i,j)=((pixel-low_in)/(high_in-low_in))^0.5;
        else if pixel>high_in
                resultado(i,j)=65535;
        else 
            resultado(i,j)=0;
        end 
        end
    end
end 
end 
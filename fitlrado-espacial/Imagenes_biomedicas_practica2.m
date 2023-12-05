%Practica2 imagenesiMAGENES BIOMEDICAS
%Borramos las variables cargadas y cargamos la imagen
clear variables
clc
close all

%Cargamos la imagen y la ajustamos automaticamente
imagen=dicomread('im5');
imagen_ajustada=imadjust(imagen);
figure(1)
imshow(imagen_ajustada) %Visualizacion de la imagen ajustada sin filtro
%% 
h1=fspecial("average",5); %Filtro paso bajo 5x5 
f_paso_sinajuste=imfilter(imagen,h1);
f_paso_bajo=imadjust(f_paso_sinajuste);
f_paso_bajo2=imfilter(imagen_ajustada,h1);

%comparacion
figure('Name', 'Visualización paso bajo 5x5')
subplot(1,3,1);
imshow(imagen_ajustada)
title('Imagen Ajustada sin filtro')
subplot(1,3,2);
imshow(f_paso_bajo)
title('Filtro paso bajo y luego ajustada')
subplot(1,3,3);
imshow(f_paso_bajo2)
title('Imagen ajustada con filtro paso bajo')

%1buscar la forma óptima manualmente
%f_paso_sinajuste=imfilter(imagen,h1);
%imtool(f_paso_sinajuste)
%f_paso_ajustado=imadjust(f_paso_sinajuste, [50000/65536 60000/65536],[0,1]);
%% 
%Filtro sobel
h2=fspecial('sobel'); 
sobel_simple=imfilter(imagen, h2);
sobel_simple=imadjust(sobel_simple);
%imshow(imfilter(imagen_ajustada, h2))

%Filtro sobel doble barrido 
B = double(imagen_ajustada); 
fs = fspecial('sobel'); %vertical
%matriz transpuesta'
fs2 = fs'; %Filtro Sobel, tenemos que hacer filtrado horizontal y vertical
sobel1 = imfilter(B, fs);
sobel2 = imfilter(B, fs2); 
%Calculamos el módulo
sobel = sqrt((sobel1.^2) + (sobel2.^2)); 
sobel = uint16(sobel);

%Filtro sobel doble barrido imagen sin ajustar (mejor hacer un metodo
%aparte en caso de querer seguir trabajando con el sobel)
D=double(imagen); 
sobel11 = imfilter(D, fs);
sobel22 = imfilter(D, fs2); 
%Calculamos el módulo
sobel1 = sqrt((sobel11.^2) + (sobel22.^2)); 
sobel1 = uint16(sobel1);
sobel_Ajustado=imadjust(sobel1);

%comparacion
figure('Name', 'Visualización filtro sobel')
subplot(3,2,1);
imshow(imagen_ajustada)
title('Imagen Ajustada sin filtro')
subplot(3,2,3);
imshow(sobel_simple)
title('Filtro sobel y luego ajustada')
subplot(3,2,4);
imshow(imfilter(imagen_ajustada, h2))
title('Imagen ajustada con filtro sobel')
subplot(3,2,5);
imshow(sobel_Ajustado)
title('filtro sobel (vert y hori) + ajuste') %vertical y horizontal
subplot(3,2,6);
imshow(sobel)
title('Imagen ajustada con filtro sobel (vert y hori)')

%% 
%3Filtro de Prewitt
h3=fspecial('prewitt'); 
prewitt_simple=imfilter(imagen, h3);
prewitt_simple=imadjust(prewitt_simple);
prewitt_simple2=imfilter(imagen_ajustada, h3);

%prewitt en todas las direcciones
%B = double(imagen_ajustada);  esto ya fue cargado anteriormente
fp = fspecial('prewitt');
fp2 = fp';
prewitt1 = imfilter(B, fp);
prewitt2 = imfilter(B, fp2);
prewitt_to = sqrt((prewitt1.^2) + (prewitt2.^2));
prewitt_ajustada1 = uint16(prewitt_to);

%Recomiendo hacer una funcion pero por tiempo lo copie y pegue en otro
%lado, para subirlo lo traje aqui
%D=double(imagen);
prewitt1 = imfilter(D, fp);
prewitt2 = imfilter(D, fp2);
prewitt_sinajuste = sqrt((prewitt1.^2) + (prewitt2.^2));
prewitt_sinajuste = uint16(prewitt_sinajuste);
prewitt_ajustada2 = imadjust(prewitt_sinajuste);
%imshow(prewitt)

%comparacion
figure('Name', 'Visualización filtro Prewitt')
subplot(3,2,1);
imshow(imagen_ajustada)
title('Imagen Ajustada sin filtro')
subplot(3,2,3);
imshow(prewitt_simple)
title('Filtro Prewitt y luego ajustada')
subplot(3,2,4);
imshow(prewitt_simple2)
title('Imagen ajustada con filtro prewitt')
subplot(3,2,5);
imshow(prewitt_ajustada2)
title('filtro prewitt (vert y hori) + ajuste') %vertical y horizontal
subplot(3,2,6);
imshow(prewitt_ajustada1)
title('Imagen ajustada con filtro prewitt (vert y hori)')
%% 
%4Filtro gaussiano de 5x5, con sigma=1.
h4 = fspecial('gaussian', [5 5], 2);
fg = imfilter(imagen_ajustada, h4);

fg_sinajustar = imfilter(imagen, h4);
fg_ajustada = imadjust(fg_sinajustar);

%comparacion
figure('Name', 'Visualización filtro gaussiano 5x5')
subplot(1,3,1);
imshow(imagen_ajustada)
title('Imagen Ajustada sin filtro')
subplot(1,3,2);
imshow(fg)
title('Filtro gaussiano y luego ajustada')
subplot(1,3,3);
imshow(fg_ajustada)
title('Imagen ajustada con filtro gaussiano')
%% 
%5Filtro Laplaciano 
h5 = fspecial ('laplacian'); 
fl = imfilter(imagen_ajustada, h5); 

fl_sinajustar = imfilter(imagen, h5);
fl_ajustada = imadjust(fl_sinajustar);

%comparacion
figure('Name', 'Visualización filtro laplaciano')
subplot(1,3,1);
imshow(imagen_ajustada)
title('Imagen Ajustada sin filtro')
subplot(1,3,2);
imshow(fl_ajustada)
title('Filtro laplaciano y luego ajustada')
subplot(1,3,3);
imshow(fl)
title('Imagen ajustada con filtro laplaciano')
%% 

% 6Filtro logaritmo de una gaussiana (LoG) de 5x5, con sigma=1.
h6 = fspecial("log",[5 5], 1);
flog = imfilter(imagen_ajustada, h6); 

flog_sinajustar = imfilter(imagen, h6);
flog_ajustada = imadjust(flog_sinajustar);

%comparacion
figure('Name', 'Visualización filtro logaritmo de una gaussiana (LoG)')
subplot(1,3,1);
imshow(imagen_ajustada)
title('Imagen Ajustada sin filtro')
subplot(1,3,2);
imshow(flog_ajustada)
title('Filtro LoG y luego ajustada')
subplot(1,3,3);
imshow(flog)
title('Imagen ajustada con filtro LoG')
%% 
figure('Name', 'Todos los Filtros')
subplot(2,3,1);
imshow(imagen_ajustada)
title('Imagen Ajustada')
subplot(2,3,2);
imshow(f_paso_bajo)
title('Filtro Paso Bajo')
subplot(2,3,3);
imshow(sobel_Ajustado)
title('Filtro Sobel')
subplot(2,3,4);
imshow(prewitt_ajustada2)
title('Filtro prewitt')
subplot(2,3,5);
imshow(fg)
title('Filtro Gaussiano')
subplot(2,3,6);
imshow(fl_ajustada)
title('filtro laplaciano')

figure(7)
imshow(flog_ajustada)
title('filtro logaritmo')

%% Apartado 2
%Utilice la funcion edge en los siguientes algoritmos
[imagen_binaria,thresh]= edge(imagen, 'sobel'); %usa sobel por defecto
thresh; %ver umbral automatico
%figure(1)
%imshow(imagen_binaria)

[imagen_manual]= edge(imagen, 'sobel',0.00035); %usa sobel por defecto
%figure(2)
%imshow(imagen_manual)

%comparacion
figure('Name', 'Visualización para función edge')
subplot(1,3,1);
imshow(imagen_ajustada)
title('Imagen Ajustada')
subplot(1,3,2);
imshow(imagen_binaria)
title('Edge con sobel usando umbral automatico')
subplot(1,3,3);
imshow(imagen_manual)
title('Edge con sobel usando umbral manual')
%% 
[imagen_automatica,thresh]= edge(imagen, 'canny');
thresh; %ver umbral automatico
%imshow(imagen_automatica)

canny1= edge(imagen, 'canny', [0.0300 0.0800],sqrt(3));
canny2= edge(imagen, 'canny', [0.0300 0.0800],sqrt(0.5));
canny3= edge(imagen, 'canny', [0 0.1800],sqrt(3));
canny4= edge(imagen, 'canny', [0.006 0.106],sqrt(1.2));

figure('Name', 'Visualización canny')
subplot(3,2,1);
imshow(imagen_ajustada)
title('Imagen Ajustada')
subplot(3,2,2);
imshow(imagen_automatica)
title('Imagen ajustada automaticamente')
subplot(3,2,3);
imshow(canny1)
title('Canny con un sigma elevado')
subplot(3,2,4);
imshow(canny2)
title('Canny con un sigma bajo')
subplot(3,2,5);
imshow(canny3)
title('canny con unos umbrales muy abiertos') 
subplot(3,2,6);
imshow(canny4)
title('canny con unos umbrales muy cerrados')
%imtool(canny4)

%% 3 guardar las imagenes
imwrite(f_paso_bajo,"Filtro_Paso_Bajo.png");
imwrite(sobel_Ajustado,"sobel_Ajustado.png");
imwrite(prewitt_ajustada2,"Filtro_prewitt.png");
imwrite(fg,"Filtro_Gaussiano.png");
imwrite(fl_ajustada,"filtro_laplaciano.png");
imwrite(flog_ajustada,"filtro_logaritmico.png");
imwrite(imagen_manual,"Edge_sobel_manual.png");
imwrite(canny4,"Canny_umbrales_amplios.png");
%% 3 uint8( y jpg
imwrite(uint8(sobel_Ajustado),"sobel_Ajustado.jpg");
imwrite(uint8(prewitt_ajustada2),"Filtro_prewitt.jpg");
imwrite(uint8(fg),"Filtro_Gaussiano.jpg");
imwrite(uint8(fl_ajustada),"filtro_laplaciano.jpg");
imwrite(uint8(flog_ajustada),"filtro_logaritmico.jpg");
imwrite(uint8(imagen_manual),"Edge_sobel_manual.jpg");
imwrite(uint8(canny4),"Edge_Canny_umbrales_amplios.jpg");
%% 
imshow(imadjust(prewitt_filter(imagen)))
%Funciones
function [Gx, Gy, im_mag] = prewitt_filter(im)
%lee la imagen
imagen=double(im);
[filas, columnas]=size(imagen);
Gx=zeros(filas,columnas);
Gy=zeros(filas,columnas);
% Define los kernels Prewitt
prewitt_x = [-1 0 1; -1 0 1; -1 0 1];
prewitt_y = [-1 -1 -1; 0 0 0; 1 1 1];
for i=2:filas-1
    for j=2: columnas-1
        Gx(i,j) =imagen(i,j)* prewitt_x (2,2)+ imagen(i,j+1)* prewitt_x (2,3) + ...
        imagen(i-1,j+1)* prewitt_x (1,3)+ imagen(i-1,j)* prewitt_x (1,2) + ...
        imagen(i-1,j-1)* prewitt_x (1,1)+ imagen(i,j-1)* prewitt_x (2,1) + ...
        imagen(i+1,j-1)* prewitt_x (3,1)+ imagen(i+1,j)* prewitt_x (3,2)+  ...
        imagen(i+1,j+1)*prewitt_x(3,3);
        %con el eje y
        Gy(i,j)=imagen(i,j)* prewitt_y (2,2)+ imagen(i,j+1)* prewitt_y (2,3) + ...
        imagen(i-1,j+1)* prewitt_y (1,3)+ imagen(i-1,j)* prewitt_y (1,2) + ...
        imagen(i-1,j-1)* prewitt_y (1,1)+ imagen(i,j-1)* prewitt_y (2,1) + ...
        imagen(i+1,j-1)* prewitt_y (3,1)+ imagen(i+1,j)* prewitt_y (3,2)+  ...
        imagen(i+1,j+1)*prewitt_y(3,3);

    end
end
% Calcula la magnitud del gradiente
im_mag = sqrt(double(Gx).^2 + double(Gy).^2);
im_mag  = uint16(im_mag );
end

function r = fspecial_propio(imagen, filtro)
s = size(imagen);
r = zeros(s);
for i = 2:s(1)-1
    for j = 2:s(2)-1
        temp = imagen(i-1:i+1,j-1:j+1) .* filtro;
        r(i,j) = sum(temp(:));
    end
end
end
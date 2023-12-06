%Practica3 imagenes biomedicas
%Borramos las variables cargadas y cargamos la imagen
clear variables
clc
close all

%Cargamos la imagen y la ajustamos automaticamente
imagen=dicomread('im5'); %imagen asignada (sin procesar)
imagen_ajustada=imadjust(imagen); %ajuste automatico
%comparacion
figure('Name', 'Observación de la imagen previa a la practica')
subplot(1,2,1);
imshow(imagen)
title('imagen 5 sin procesar')
subplot(1,2,2);
imshow(imagen_ajustada)
title('imagen 5 ajustada')  
%% 1.1 umbralizacion manual
%Al trabajar con una imagen desconocida lo mejor es ver el histograma
figure('Name', 'Histograma de la imagen:'); imhist(imagen) 

%se podría usar el imshow(imagen,[120 270]) pero pienso que esto quedaba
%muy simple y no sé podía controla tan bien la salida binaria

%comparacion
figure('Name', 'Distintos valores para la misma imagen:')
subplot(2,2,1);
imshow(umbral_manual(imagen),[]) 
title('imagen umbralizacion manual (120 a 270)')
subplot(2,2,2);
imshow(umbral_manual(imagen, 195, 270),[]) 
title('umbralizacion intento masa cerebral (195 a 270)')
subplot(2,2,3);
imshow(umbral_manual(imagen, 115, 187),[]) 
title('umbralizacion intento tumor (115 a 187)')
subplot(2,2,4);
imshow(umbral_manual(imagen_ajustada, 17000, 38000),[]) 
title('Imagen ajustada umbralizada ') %Comparamos como se vería si umbralizamos 
% una imagen ajustada (debería verse peor)

%% 1.2 Umbralizacion automatica
imagen_automatica=umbral_automatico(imagen); %debería eliminar el fondo
f1=imagen.*uint16(imagen_automatica); 
%imshow(f1,[])
imagen_automatica2=umbral_automatico(f1);  %eliminar tumor y parte del craneo
f2=f1.*uint16(imagen_automatica2);
%imshow(f2,[])
imagen_automatica3=umbral_automatico(f2); %
f3=f2.*uint16(imagen_automatica3);
%imshow(f3,[])
%Se podría decir que las imagenes_automaticas son imagenes umbralizadas
%binarias y las F1, F2, F3 son esas iteraciones multiplicadas por la imagen
% para obtener los valores reales

%comparacion
figure('Name', '1)algoritmo automatico')
subplot(2,2,1);
imshow(imagen_automatica,[]) 
title('primera iteración, imagen binaria')
subplot(2,2,2);
imshow(f1,[])
title('primera iteracion con distintos niveles de grís')
subplot(2,2,3);
imshow(f2,[])
title('segunda iteracion')
subplot(2,2,4);
imshow(f3,[])
title('tercera iteracion')

%% Métodod de Otsu por MATLAB
imagen_manual=umbral_manual(imagen);
figure('Name', 'Imagen Otsu')
imshow(metodo_otsu(imagen))
title('imagen con el método otsu ')


%% Método de Global Threshold Progrmamado
imagen_global_treshold=umbral_global_treshold(imagen);
figure('Name', 'método de global treshold')
imshow(imagen_global_treshold,[])
title('imagen con el método de Global Threshold Programamado')
%% apartado 3: Umbralización automática ietrativa de una imagen filtrada 
%Filtro gaussiano de 5x5, con sigma=1.
filtro_gaussiano = fspecial('gaussian', [5 5], 1);
imagen_filtrada = imfilter(imagen, filtro_gaussiano);

%title('filtrada y umbralizada')
imagen_automatica=umbral_automatico(imagen_filtrada);
f1=imagen_filtrada.*uint16(imagen_automatica); 

imagen_automatica2=umbral_automatico(f1); 
f2=f1.*uint16(imagen_automatica2);

imagen_automatica3=umbral_automatico_inferior(f2);
f3=f2.*uint16(imagen_automatica3);

%comparacion
figure('Name', '3)algoritmo automatico con un filtro gaussiano')
subplot(2,2,1);
imshow(imagen_automatica,[]) 
title('primera iteración, imagen binaria')
subplot(2,2,2);
imshow(f1,[])
title('primera iteracion con distintos niveles de grís')
subplot(2,2,3);
imshow(f2,[])
title('segunda iteracion')
subplot(2,2,4);
imshow(f3,[])
title('tercera iteracion')


%% Utilizar el algoritmo SLIC
[L, NumLabels] = superpixels(imagen_ajustada, 90)
mask = boundarymask(L);

[L2, NumLabels2] = superpixels(imagen_ajustada, 91);
mask2 = boundarymask(L2);

[L3, NumLabels3] = superpixels(imagen_ajustada, 15);
mask3 = boundarymask(L3);

[L4, NumLabels4] = superpixels(imagen_ajustada, 500);
mask4 = boundarymask(L4);

%comparacion
figure('Name', 'Comparación de distintos N')
subplot(2,2,1);
imshow(imoverlay(imagen_ajustada,mask,'cyan'),'InitialMagnification',50)
title('Aplicado 90 k')
subplot(2,2,2);
imshow(imoverlay(imagen_ajustada,mask2,'green'),'InitialMagnification',50)
title('Aplicado 91 de k')
subplot(2,2,3);
imshow(imoverlay(imagen_ajustada,mask3,'red'),'InitialMagnification',50)
title('Aplicado 15 de k')
subplot(2,2,4);
imshow(imoverlay(imagen_ajustada,mask4,'yellow'),'InitialMagnification',50)
title('Aplicado 500 de k')




SLIC1=SLIC(imagen_ajustada,90);
SLIC2=SLIC(imagen_ajustada,91);
SLIC3=SLIC(imagen_ajustada,15);
SLIC4=SLIC(imagen_ajustada,500);
%comparacion
figure('Name', 'Comparación al calcular el valor medio de cada superpixel')
subplot(2,2,1);
imshow(SLIC1,'InitialMagnification',100)
title('Con 90 divisiones')
subplot(2,2,2);
imshow(SLIC2,'InitialMagnification',100)
title('Con 91 divisiones')
subplot(2,2,3);
imshow(SLIC3,'InitialMagnification',100)
title('Con 15 divisiones')
subplot(2,2,4);
imshow(SLIC4,'InitialMagnification',100)
title('Con 500 divisiones')



%% funciones
function imagen_manual = umbral_manual(imagen, valor_min, valor_max)
if nargin < 2 %si no dan valor_min se tomara como 100 caso im5
    valor_min = 120;
end
if nargin < 3%si no dan valor_max se tomara como 270 caso im5
    valor_max = 270;
end
imagen = double(imagen);
[filas, columnas]=size(imagen);
imagen_manual = zeros(filas,columnas);
for i=1:filas
    for j=1:columnas
        if imagen(i,j)> valor_min && imagen(i,j)< valor_max
            imagen_manual(i,j) = 1; %pone a 1 los pixeles en el rango
        else
            imagen_manual(i,j) = 0; %pone en negro lo demas
        end 
    end
end
imagen_manual=int16(imagen_manual);
end

function imagen_automatica = umbral_automatico(imagen,grado_de_aceptacion)
if nargin < 2 %si no dan un segundo valor se pone automatico
    grado_de_aceptacion = 0;5;
end
%Segmentación con umbral automático
imagen=double(imagen);
cnt=0;% Contador de Iteracioenes
entrada=imagen;
ent=entrada(entrada>0);
T = mean2(ent); % Calculamos el umbral inicial
condicion = true;
while condicion % bucle hasta que tenga un umbral decente
 cnt=cnt+1; %en caso de querer evitar bucles infinitos, podría usar el cnt 
 %para poner un numero maximo de repeticiones
 imagen_automatica = ent>T;
 medI = mean(ent(~imagen_automatica)); % Media de los inferiores al umbral
 medS = mean(ent(imagen_automatica)); % Media de los superiores al umbral
 Tsig = 0.5*(medI+medS); % Umbral para la siguiente iteracion
 condicion=abs(T-Tsig)>grado_de_aceptacion;
 T=Tsig;
end
imagen_automatica = imbinarize(uint16(entrada),T/65535);
end

%probar en caso de que el objeto de estudio se va del umbral automatico
function imagen_automatica = umbral_automatico_inferior(imagen,grado_de_aceptacion)
if nargin < 2 %si no dan un segundo valor se pone automatico
    grado_de_aceptacion = 0.5;
end
%Segmentación con umbral automático
imagen=double(imagen);
cnt=0;% Contador de Iteraciones
entrada=imagen;
ent=entrada(entrada>0);
T = mean2(ent); % Calculamos el umbral inicial
condicion = true;
while condicion % bucle hasta que tenga un umbral decente
 cnt=cnt+1; %en caso de querer evitar bucles infinitos, podría usar el cnt 
 %para poner un numero maximo de repeticiones
 imagen_automatica = ent<T; % Aquí cambiamos la lógica del umbral
 Tsig= mean(ent(~imagen_automatica)); % Media de los inferiores al umbral
  % Umbral para la siguiente iteracion
 condicion=abs(T-Tsig)>grado_de_aceptacion;
 T=Tsig;
end
imagen_automatica = imbinarize(uint16(entrada),T/65535);
end


function imagen_otsu = metodo_otsu(imagen)
imagen=double(imagen);
grises = mat2gray(imagen);
[level, ~]= graythresh(grises);

mejora = round(grises);
mejora2 = uint8(mejora);
imagen_otsu = imbinarize(mejora2, level/255);
end

function imagen_global = umbral_global_treshold(imagen)
%Segmentación con umbral automático
imagen=double(imagen);
cnt=0;% Contador de Iteracioenes
grises = mat2gray(imagen); %convierte la imagen en escala de grises que 
% contiene valores en el intervalo 0 (negro) a 1 (blanco).
T=mean2(grises);
condicion = true;
while condicion % bucle hasta que tenga un umbral decente
 cnt=cnt+1; %en caso de querer evitar bucles infinitos, podría usar el cnt 
 %para poner un numero maximo de repeticiones
 imagen_automatica = grises>T;
 medI = mean(grises(imagen_automatica)); % Media de los inferiores al umbral
 medS = mean(grises(~imagen_automatica)); % Media de los superiores al umbral
 Tsig = 0.5*(medI+medS); % Umbral para la siguiente iteracion
 condicion=abs(T-Tsig)~=0;
 T=Tsig;
end
mejor = round(grises); % Redondeamos la Imagen
mejo3 = uint8(mejor); % La trasformamos a enteros de 8 bits
imagen_global = imbinarize(mejo3, T/255); % Binarizamos la imagen según el threshhold
end

function  salida = SLIC(imagen_ajustada,N)
[L, NumLabels] = superpixels(imagen_ajustada, N);
%mejorando la imagen
salida=zeros(size(imagen_ajustada),'like',imagen_ajustada); 
idx=label2idx(L);
%[filas, columnas]=size(imagen_ajustada);
for i=1:NumLabels
    redidx=idx{i};
    salida(redidx)=mean(imagen_ajustada(redidx));
end 
end
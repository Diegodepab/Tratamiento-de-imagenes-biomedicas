%Cargamos la imagen y la ajustamos automaticamente
%Borramos las variables cargadas y cargamos la imagen
clear variables
clc
close all

%leemos la imagen para tener referencia
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
%% Utilizar uno o varios de los algoritmos de segmentación de imágenes
%1.1 regiongrow usando S como escalar (regiongrow(f, S, T))
%imagen con 250 semillas y 75 umbral
[masa_cerebral, NR1, SI1, TI1] = regiongrow(imagen, 250, 75);
%imagen con 270 semillas y 120 umbral
[solo_craneo, NR2, SI2, TI2] = regiongrow(imagen, 270, 120);
%imagen con 250 semillas y 120 umbral
[craneo_y_cerebro, NR3, SI3, TI3] = regiongrow(imagen, 250, 120);

zona_interes = craneo_y_cerebro - solo_craneo;

figure('Name', 'Comparación de distintas semillas para regiongrow')
subplot(2,2,1);
imshow(masa_cerebral)
title('imagen con masa cerebral')
subplot(2,2,2);
imshow(solo_craneo)
title('imagen con solo craneo')
subplot(2,2,3);
imshow(craneo_y_cerebro)
title('imagen de craneo y zona de interes')
subplot(2,2,4);
imshow(zona_interes)
title('zona de interes')
regiongrow_ejemplo=zona_interes;
%% 1.2 splitmerge v = split_test(B, mindim, fun)
%predicate(imagen) 
splitmerge_final = splitmerge(imagen, 4, @predicate);
imshow(splitmerge_final)

%se recomienda probar valores distintos de mindin y tambien modificar la
%funcion predicate especificamente los valores k y M

%% 1.3 Utilización de algoritmos de detección y extracción de bordes y contornos de la imagen
%1 Filtro sobel
[imagen_binaria,thresh]= edge(imagen, 'sobel'); %usa sobel por defecto
thresh; %ver umbral automatico

sobel_manual= edge(imagen, 'sobel',0.00035);

figure('Name', 'Visualización para función edge')
subplot(1,2,1);
imshow(imagen_binaria)
title('Edge con sobel usando umbral automatico')
subplot(1,2,2);
imshow(sobel_manual)
title('Edge con sobel usando umbral manual')
%codigo del libro:
%g = sqrt(imfilter(imagen,fs,'replicate').^2 + imfilter(imagen,fs','replicate').^2);

%% 1.3.2 (filtro canny)

[imagen_automatica,thresh]= edge(imagen, 'canny');
thresh; %ver umbral automatico
%imshow(imagen_automatica)

%canny manual
canny_seg= edge(imagen, 'canny', [0 0.1800],sqrt(3));


figure('Name', 'Visualización canny')
subplot(1,2,1);
imshow(imagen_automatica)
title('Imagen ajustada automaticamente')
subplot(1,2,2);
imshow(canny_seg)
title('canny con unos umbrales manuales') 

%% Recapitulación de imagenes finales 

figure('Name', 'Comparación de distintos algoritmos de segmentacion usados')
subplot(2,2,1);
imshow(regiongrow_ejemplo)
title('Segmentacion con Regiongrow')

subplot(2,2,2);
imshow(splitmerge_final)
title('Segmentacion con split and merge')

subplot(2,2,3);
imshow(sobel_manual)
title('Segmentacion de bordes mediante sobel')

subplot(2,2,4);
imshow(canny_seg)
title('Segmentacion de bordes mediante Canny')

%% Imagenes trabajadas en APP Image Segmenter
figure('Name', 'Cerebro')
imshow(BW)
title('Segmentacion conseguida')
%% 2. filtrado morfologico 
%2.1 regiongrow
cerrado = bwmorph(regiongrow_ejemplo,"close",1); % Cierre
erosionado = bwmorph(cerrado,"erode",9); % Erosión
limpieza = bwmorph(erosionado,"dilate",4); % dilatado
%bordes =bwmorph(limpieza,"remove",1);

figure('Name', 'antes y despues')
subplot(2,2,1);
imshow(regiongrow_ejemplo)
title('original regiongrow')
subplot(2,2,2);
imshow(cerrado)
title('aplicando close')
subplot(2,2,3);
imshow(erosionado)
title('aplicando close + erode')
subplot(2,2,4);
imshow(limpieza)
title('aplicando close + erode + dilate')

regiongrow_final=limpieza;
%% 2.2 filtrado a splitmerge
cerrado_split = bwmorph(splitmerge_final,"close",1); % erosion

figure('Name', 'antes y despues')
subplot(1,2,1);
imshow(splitmerge_final)
title('original splitmerge')
subplot(1,2,2);
imshow(cerrado_split)
title('aplicando close')

%% 2.3 Filtrado sobel manual
cerrado_sobel = bwmorph(sobel_manual,"close",2); % erosion y dilatado

figure('Name', 'antes y despues')
subplot(1,2,1);
imshow(sobel_manual)
title('original sobel')
subplot(1,2,2);
imshow(cerrado_sobel)
title('aplicando close')

%% 2.4 Filtrado canny
cerrado_sobel = bwmorph(canny_seg,"close",2); % erosion y dilatado


figure('Name', 'antes y despues')
subplot(1,2,1);
imshow(canny_seg)
title('original canny')
subplot(1,2,2);
imshow(cerrado_sobel)
title('aplicando close')

%% Imagenes trabajadas en APP Image Segmenter
cerrado_BW = bwmorph(BW,"close",2); % erosion y dilatado

figure('Name', 'antes y despues')
subplot(1,2,1);
imshow(BW)
title('original')
subplot(1,2,2);
imshow(cerrado_BW)
title('aplicando close')

%% Descriptores 
%area
figure('Name', 'mejor')
imshow(cerrado_BW)
a=regionprops(cerrado_BW,'Area');
areaa=a.Area %6926

%perimetro
p=regionprops(cerrado_BW,'Perimeter');
perimetro=p.Perimeter %351.4090

regiongrow_perimetro = bwmorph(cerrado_BW,"remove",1); % dilatado
figure('Name', 'solo perimetro')
imshow(regiongrow_perimetro) 

%compacidad
Compacidad=(perimetro.^2)/areaa

%% Otros descriptores
Media=mean2(cerrado_BW)

%desviacion tipica
Desviacion=std2(cerrado_BW)

%skewness
S=skewness(cerrado_BW);

%firma de contorno
center=regionprops(cerrado_BW,'Centroid');
boundary=bwboundaries(cerrado_BW);
for i=1: length(center)
	c=center(i).Centroid;
	b=boundary(i);
	x=b{1,1}(:,1);
	y=b{1,1}(:,2);
	d=sqrt((y-c(1)).^2+(x-c(2)).^2);
	t=1:1:length(d);
	figure(i);
	plot(t,d)
end

regionprops(cerrado_BW)
%% Funciones

%1funcion dada por el profe basada en un umbral sobre el nivel de gris (González)
function [g, NR, SI, TI] = regiongrow(f, S, T)
f = double(f);
if numel(S) == 1
   SI = f == S;
   S1 = S;
else
   SI = bwmorph(S, 'shrink', Inf);  
   J = SI;
   S1 = f(J); % Array of seed values.
end
 
TI = false(size(f));
for K = 1:length(S1)
   seedvalue = S1(K);
   S = abs(f - seedvalue) <= T;
   TI = TI | S;
end

[g, NR] = bwlabel(imreconstruct(SI, TI));
end

%1.1.2
function g = splitmerge(f, mindim, fun)
Q = 2^nextpow2(max(size(f)));
[M, N] = size(f);
f = padarray(f, [Q - M, Q - N], 'post');

S = qtdecomp(f, @split_test, mindim, fun);
Lmax = full(max(S(:)));
g = zeros(size(f));
MARKER = zeros(size(f));
% Begin the merging stage.
for K = 1:Lmax 
   [vals, r, c] = qtgetblk(f, S, K);
   if ~isempty(vals)
      for I = 1:length(r)
         xlow = r(I); ylow = c(I);
         xhigh = xlow + K - 1; yhigh = ylow + K - 1;
         region = f(xlow:xhigh, ylow:yhigh);
         flag = feval(fun, region);
         if flag 
            g(xlow:xhigh, ylow:yhigh) = 1;
            MARKER(xlow, ylow) = 1;
         end
      end
   end
end

% Finally, obtain each connected region and label it with a
% different integer value using function bwlabel.
g = bwlabel(imreconstruct(MARKER, g));

% Crop and exit
g = g(1:M, 1:N);
end

function v = split_test(B, mindim, fun)
k = size(B, 3);
v(1:k) = false;
for I = 1:k
   quadregion = B(:, :, I);
   if size(quadregion, 1) <= mindim
      v(I) = false;
      continue
   end
   flag = feval(fun, quadregion);
   if flag
      v(I) = true;
   end
end
end

%1.1.3 mejor resultado
function flag = predicate(region)
sd = std2(region);
m = mean2(region);
k=2.4;
M=150;
flag = abs(M-m)<k*sd;
end 

function [BW,maskedImage] = segmentImage(X)
%segmentImage Segment image using auto-generated code from Image Segmenter app
%  [BW,MASKEDIMAGE] = segmentImage(X) segments image X using auto-generated
%  code from the Image Segmenter app. The final segmentation is returned in
%  BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 24-Nov-2023
%----------------------------------------------------


% Adjust data to span data range.
X = imadjust(X);

% Create empty mask
BW = false(size(X,1),size(X,2));

% Draw ROIs

xPos = [119.3727 117.6341 116.3302 110.2453 106.3336 105.4643 104.1604 103.2912 102.4219 101.9873 101.5526 101.1180 99.8141 99.3795 98.9448 98.0756 97.2063 95.9024 95.4677 95.4677 95.0331 94.5985 93.2946 93.2946 92.8599 92.4253 91.5560 91.5560 91.1214 91.1214 90.2521 90.2521 89.3829 88.9482 88.5136 87.2097 86.7750 86.3404 85.9058 84.1672 82.4287 81.9941 80.6902 80.2555 80.2555 80.2555 80.2555 80.2555 80.2555 79.8209 79.8209 79.8209 79.3862 78.5170 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.0823 78.5170 79.3862 80.2555 80.2555 82.4287 84.1672 84.6019 85.0365 86.7750 88.0789 88.9482 88.9482 90.2521 91.1214 92.4253 93.7292 95.0331 95.4677 96.7716 97.6409 98.0500 99.3795 101.1180 101.9873 104.1604 104.5951 105.4643 106.3336 106.3336 106.7683 107.6375 108.0722 108.5068 108.9414 110.2453 110.6800 111.9839 112.4185 112.8531 115.0263 116.7649 118.5034 118.9380 119.3727 121.1112 121.5458 121.9805 123.2844 123.7190 125.0229 125.4576 125.8922 126.3268 128.0654 130.2385 130.2385 130.2385 130.6732 131.5424 131.9771 132.4117 132.4117 132.8463 134.1503 134.5849 134.5849 135.0195 135.8888 136.7581 137.1927 138.0620 138.4966 138.9312 139.3659 140.6698 141.1044 142.4083 143.2776 144.5815 145.0161 145.4508 145.8854 147.1893 147.6239 148.0586 148.9278 149.7971 151.1010 151.9703 153.7088 154.5781 155.8820 156.3166 157.6205 158.4898 160.6630 161.0976 161.9669 162.8362 163.2708 164.5747 165.0093 165.4440 166.7479 168.4864 168.9211 169.3557 169.7903 171.0942 171.5289 173.2674 173.7020 174.1367 175.4406 175.4406 175.8752 176.3098 177.6138 178.0484 178.4830 179.7869 180.2216 182.3947 182.8294 183.6986 184.1333 184.5679 185.8718 186.7411 187.1757 188.0450 188.4796 188.9143 189.3489 190.6528 191.0874 191.5221 192.3913 192.8260 192.8260 193.2606 193.2606 193.2606 193.6952 193.6952 193.6952 193.6952 194.5645 194.5645 194.5645 194.5645 194.9992 194.9992 194.9992 194.9992 194.9992 195.4338 195.4338 195.4338 195.4338 195.4338 195.4338 195.4338 195.4338 194.5645 193.2606 192.8260 192.3913 191.5221 191.0874 191.0874 190.6528 190.2182 188.0450 187.1757 186.7411 186.7411 185.8718 185.0025 184.1333 183.6986 182.3947 181.5255 179.7869 178.4830 178.0484 178.0484 177.1791 175.8752 175.0059 173.2674 171.5289 171.0942 169.7903 169.7903 169.3557 169.3557 169.7903 171.0942 171.5289 171.5289 171.9635 171.9635 171.5289 171.0942 170.6596 169.7903 169.3557 167.6171 167.1825 165.4440 165.0093 164.5747 162.8362 162.4015 161.9669 160.6630 160.2284 159.7937 158.9244 158.4898 157.6205 156.7513 156.3166 155.8820 155.4474 154.5781 154.1435 153.7088 152.4049 151.9703 150.2317 149.7971 149.3625 148.9278 147.6239 147.1893 145.8854 145.0161 143.7122 143.2776 141.1044 140.2351 138.9312 138.4966 137.1927 136.7581 135.8888 134.5849 132.8463 132.4117 131.9771 130.6732 130.2385 129.8039 128.0654 127.6307 125.8922 125.4576 124.1537 123.7190 122.8497 121.5458 121.1112 119.3727 118.9380 117.6341 117.1995 116.7649 116.3302 115.4610 115.0263 115.8693];
yPos = [135.0195 135.0195 135.4542 138.0620 139.8005 140.2351 141.1044 141.5390 141.5390 141.5390 141.9737 143.2776 143.7122 144.1469 145.4508 145.8854 146.3200 147.6239 148.0586 148.4932 149.7971 150.2317 151.1010 152.4049 152.8396 154.5781 155.0127 156.3166 156.7513 157.1859 157.6205 158.4898 158.4898 158.9244 159.3591 159.7937 159.7937 160.6630 161.0976 161.5323 161.9669 162.8362 163.2708 163.2708 163.7054 164.1401 165.0093 165.4440 165.8786 167.1825 167.6171 168.4864 169.7903 172.8328 174.1367 176.7445 178.0484 178.4830 178.9177 179.3523 180.2216 180.6562 181.5255 182.3947 182.8294 183.2640 183.6986 184.5679 185.0025 185.8718 186.7411 187.1757 187.6104 189.7835 190.2182 191.5221 191.9567 192.3913 193.2606 193.6952 194.5645 195.8684 196.3031 197.6070 198.0416 198.0416 198.4762 200.2148 200.6494 201.9533 202.8226 204.1265 204.5611 204.9958 205.4304 206.2997 206.7343 206.7343 207.1689 208.4728 208.9075 208.9075 209.3421 209.4444 209.7767 211.0806 211.5153 212.8192 213.2538 213.2538 213.2538 213.6885 214.1231 215.4270 215.4270 215.4270 215.8616 216.2963 217.1655 217.6002 217.6002 217.6002 217.6002 218.0348 218.0348 218.4694 218.4694 219.7733 219.7733 219.7733 219.7733 219.7733 219.7733 219.7733 219.7733 219.7733 219.7733 219.3387 218.4694 218.0348 218.0348 217.6002 216.2963 215.4270 214.9924 214.9924 213.6885 213.6885 213.2538 213.2538 213.2538 213.2538 212.8192 212.8192 211.9499 211.9499 211.9499 211.9499 211.9499 211.9499 211.9499 211.9499 211.9499 211.9499 211.9499 212.8192 212.8192 213.2538 213.2538 213.2538 213.2538 213.2538 213.2538 213.6885 214.9924 214.9924 214.9924 214.9924 214.9924 214.9924 214.9924 214.9924 214.9924 213.6885 213.2538 213.2538 212.8192 211.0806 211.0806 210.6460 209.7767 209.3421 208.9075 207.1689 206.7343 206.2997 206.2997 205.4304 205.4304 204.9958 204.5611 204.1265 203.2572 202.8226 202.3879 201.0840 200.2148 200.2148 199.7801 198.4762 198.0416 196.7377 196.3031 195.8684 195.8684 195.4338 194.1299 193.2606 191.9567 189.7835 189.3489 188.0450 187.1757 185.8718 183.6986 182.8294 182.8294 181.5255 181.0908 180.6562 178.9177 178.4830 177.1791 176.7445 176.3098 175.8752 174.5713 173.7020 171.9635 170.2250 169.7903 169.3557 167.6171 166.3132 165.8786 165.4440 165.0093 163.7054 163.2708 162.8362 161.9669 161.9669 161.9669 161.5323 161.5323 161.0976 161.0976 160.6630 160.6630 159.3591 158.9244 158.9244 157.6205 157.1859 156.7513 156.7513 155.4474 155.0127 155.0127 154.5781 154.5781 152.4049 152.4049 150.2317 148.9278 148.0586 147.6239 146.7547 146.7547 146.3200 145.4508 144.1469 143.7122 142.4083 141.5390 141.1044 141.1044 141.1044 141.1044 141.1044 141.1044 140.2351 139.8005 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 139.3659 138.9312 138.0620 137.1927 137.1927 137.1927 135.8888 135.4542 135.4542 135.4542 135.4542 135.4542 135.4542 135.4542 135.4542 135.4542 135.4542 135.4542 135.4542 135.4542 135.0195 135.0195 135.0195 135.0195 135.0195 135.0195 134.5849 134.5849 134.5849 134.5849 134.5849 134.5849 134.5849 134.5849 134.5849 134.5849 134.5849 135.4771];
m = size(BW, 1);
n = size(BW, 2);
addedRegion = poly2mask(xPos, yPos, m, n);
BW = BW | addedRegion;

% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
end
function [output] = HOG(img)
%Histogram of Oriented Gradients
% extraction of features

%1º Passo:resieze da imagem para um tamanho de 128*64
img= imresize(img,[128,64]);
figure(1)
imshow(img)
title('Debug-1-->resize')

%2º Passo: calcular magnitude e gradiente
Ix=img;
Iy=img; 


%linhas
for i=2:size(img,1)-1
    Iy(i,:)=(img(i-1,:)- img(i+1,:));
end

%colunas
for cols=2:size(img,2)-1
    Ix(:,cols)=img(:,cols+1)- img(:,cols-1);
end

modulo=sqrt(Ix.^2 + Iy.^2);
gradiente = atan2(Ix,Iy);
gradiente=rad2deg(gradiente);% angulos entre(0,180)

figure(2)
imshow(modulo)
title('Debug-2-->modulo')

figure(3)
imshow(gradiente)
title('Debug-3-->gradiente')

%3: Passo:
bins= 9;
step_size=180/bins;
tpad=floor(8/2);
cont=0;
feature=[];
for k= 1+tpad:size(img,1)-tpad
    for l= 1+tpad:size(img,2)-tpad

        %descriptores com janela 8*8side
        mag_descriptor=modulo(k-tpad:k+tpad,l-tpad:l+tpad);
        grad_descriptor=gradiente(k-tpad: k+tpad,l-tpad:l+tpad);
        histogram=zeros(1,9);
        
        cont=cont+1;
        for rw=1:size(mag_descriptor,1)
            for cw= 1:size(mag_descriptor,2)
                %
                 alpha= grad_descriptor(rw,cw);
                        
                        % Binning Process (Bi-Linear Interpolation)
                        if alpha>10 && alpha<=30
                            histogram(1)=histogram(1)+ mag_descriptor(rw,cw)*(30-alpha)/step_size;
                            histogram(2)=histogram(2)+ mag_descriptor(rw,cw)*(alpha-10)/step_size;
                        elseif alpha>30 && alpha<=50
                            histogram(2)=histogram(2)+ mag_descriptor(rw,cw)*(50-alpha)/step_size;                 
                            histogram(3)=histogram(3)+ mag_descriptor(rw,cw)*(alpha-30)/step_size;
                        elseif alpha>50 && alpha<=70
                            histogram(3)=histogram(3)+ mag_descriptor(rw,cw)*(70-alpha)/step_size;
                            histogram(4)=histogram(4)+ mag_descriptor(rw,cw)*(alpha-50)/step_size;
                        elseif alpha>70 && alpha<=90
                            histogram(4)=histogram(4)+ mag_descriptor(rw,cw)*(90-alpha)/step_size;
                            histogram(5)=histogram(5)+ mag_descriptor(rw,cw)*(alpha-70)/step_size;
                        elseif alpha>90 && alpha<=110
                            histogram(5)=histogram(5)+ mag_descriptor(rw,cw)*(110-alpha)/step_size;
                            histogram(6)=histogram(6)+ mag_descriptor(rw,cw)*(alpha-90)/step_size;
                        elseif alpha>110 && alpha<=130
                            histogram(6)=histogram(6)+ mag_descriptor(rw,cw)*(130-alpha)/step_size;
                            histogram(7)=histogram(7)+ mag_descriptor(rw,cw)*(alpha-110)/step_size;
                        elseif alpha>130 && alpha<=150
                            histogram(7)=histogram(7)+ mag_descriptor(rw,cw)*(150-alpha)/step_size;
                            histogram(8)=histogram(8)+ mag_descriptor(rw,cw)*(alpha-130)/step_size;
                        elseif alpha>150 && alpha<=170
                            histogram(8)=histogram(8)+ mag_descriptor(rw,cw)*(170-alpha)/step_size;
                            histogram(9)=histogram(9)+ mag_descriptor(rw,cw)*(alpha-150)/step_size;
                        elseif alpha>=0 && alpha<=10
                            histogram(1)=histogram(1)+ mag_descriptor(rw,cw)*(alpha+10)/step_size;
                            histogram(9)=histogram(9)+ mag_descriptor(rw,cw)*(10-alpha)/step_size;
                        elseif alpha>170 && alpha<=180
                            histogram(9)=histogram(9)+ mag_descriptor(rw,cw)*(190-alpha)/step_size;
                            histogram(1)=histogram(1)+ mag_descriptor(rw,cw)*(alpha-170)/step_size;
                        end
            end
        end
        feature(cont,:)=[histogram];
      
    end
end
output=feature;
% [hog1,visualization] = extractHOGFeatures(img);
% subplot(1,2,1);
% imshow(img);
% subplot(1,2,2);
% plot(visualization);
end






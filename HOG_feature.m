function [feature] = HOG_feature(img)
%Histogram of Oriented Gradients
% extraction of features

%1º Passo:resieze da imagem para um tamanho de 128*64
%img= imresize(img,[128,64]);
% figure(1)
% imshow(img)
%title('Debug-1-->resize')

%2º Passo: calculo do gradiente
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

%3ºPasso: cálculo da magnitude e orientação
modulo=sqrt(Ix.^2 + Iy.^2);

gradiente = atand(Ix./Iy); % angulos entre -90 e 90
gradiente=imadd(gradiente,90);% angulos entre 0 e 180

%debug
% figure(2)
% imshow(modulo)
% title('Debug-2-->modulo')
% 
% figure(3)
% imshow(gradiente)
% title('Debug-3-->gradiente')

%4º Passo:Calculo do historgama através da magnitude e sua orientação
%Matriz histograma com dimensão 1*9
bins= 9;
step_size=180/bins;
feature=[];
for k= 0:(size(img,1)/8) -2
    for l= 0:(size(img,2))/8 -2

        %descriptores com janela que varia de tamanho 16*16
        mod_descriptor=modulo(8*k+1:8*k+16, 8*l+1: 8*l+16);
        grad_descriptor=gradiente(8*k+1:8*k+16,8*l+1:8*l+16); 
        block=[];
      
        for x=0:1
            for y=0:1
                %pacth com dimensão 8*8
                mag_descriptor = mod_descriptor(8*x+1:8*x+8, 8*y+1:8*y+8);
                gradpatch= grad_descriptor(8*x+1:8*x+8, 8*y+1:8*y+8);
                histogram=zeros(1,9);

                for rw=1:8
                    for cw= 1:8
                        alpha= gradpatch(rw,cw);

                        %Condições para a definição da matriz de histograma
                        if alpha>10 && alpha<=30
                            histogram(1)=histogram(1)+ mag_descriptor(rw,cw)*abs((30-alpha))/step_size;
                            histogram(2)=histogram(2)+ mag_descriptor(rw,cw)*abs((alpha-10))/step_size;

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
                block=[block histogram];
            end
        end

        
        %normalização através da L2-norm
        block=block/sqrt((norm(block).^2 +0.01));
        feature=[feature block];

    end
end
%Normalização das features através da L2-norm
feature=feature/sqrt(norm(feature).^2+.001);

end






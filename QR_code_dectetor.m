%Trabalho realizado por:
%Telmo Cunha

%Script que serve como base para testar as diferentes funções
clear;clc;close all;

%load do datasets necessários
rootdir = 'QR-Codes-Dataset\';
filelist = dir(fullfile(rootdir, '**\*.jpg')); 
filelist = filelist(~[filelist.isdir]);
load("qrcode.mat")
load("qrcodev2.mat")
load("gTruth.mat")

 for i=1:84
     path = sprintf("%s\\%s", getfield(filelist,{i}, "folder"), getfield(filelist, {i},"name"));
     img= imread(path);
     
     %processamento do dataset
     
     %passa a imagem para grayscale, caso a imgem for rgb, ou seja
     %tridimensional
     if(ndims(img)==3)
         img=rgb2gray(img);
     end
    
     %Permite imagem com mais brilho
     img=imlocalbrighten(img);
     img=im2double(img);
     qrcode=im2double(qrcodev2);
     %resize da imagem para melhor computação, bem como para obter os
     %melhores resultados no hog
     img=imresize(img,[128,64]);
     
     %função que realiza a deteção
     HOG(img,qrcode);
     fprintf('Imagem %d\n',i)
 end

%debug->permite testar um conjunto especifico de imagens
%datadir='QR-Codes-Dataset/QR-Codes-Dataset/Selos-Descaracterizados- Digital';
%datadir='QR-Codes-Dataset/QR-Codes-Dataset/Papel-Normal-80g/Low-Light/Draft-Printing';
%datadir='QR-Codes-Dataset/QR-Codes-Dataset/Papel-Normal-80g/Darker-Light-Condition/Draft-Printing';
%datadir='QR-Codes-Dataset/QR-Codes-Dataset/Rough-Paper/Normal-Room-Light';
%datadir='QR-Codes-Dataset/QR-Codes-Dataset/Photographic-Glossy-Paper/Normal-Room-Light';
%datadir='QR-Codes-Dataset/QR-Codes-Dataset/Rough-Paper/Darker-Light-Condition';
%imglist=dir(sprintf('%s/*.jpg',datadir));
 
%leitura das imagens
%for i= 1:numel(imglist)
%     chamar aqui as funções e mostrar resultado
%     passar o qr_code basico para uma função
    
%     [path, imgname, dummy]= fileparts(imglist(i).name);
%     img = imread(sprintf('%s/%s',datadir, imglist(i).name));
% 
%     if(ndims(img)==3)
%         img=rgb2gray(img);
%     end
%     img=imlocalbrighten(img);
%     %img= imbinarize(img,'adaptive','ForegroundPolarity','dark','Sensitivity',0.5);
%     img=im2double(img);
%     %img=im2double(img);
%     %qrcode=rgb2gray(qrcode);
%     qrcode=im2double(qrcodev2);
%     %cantos=HarrisCorner(img,0.15,1,2,20);
% 
%     img=imresize(img,[128,64]);
%     HOG(img,qrcode);
%     fprintf('Imagem %d\n',i)
%        
% end

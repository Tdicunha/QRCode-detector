clear;
clc;
close all;

%paths dos datasets
% datadir_PN_dark1='QR-Codes-Dataset/QR-Codes-Dataset/Papel-Normal-80g/Darker-Light-Condition/Draft-Printing';
% datadir_PN_dark2='QR-Codes-Dataset/QR-Codes-Dataset/Papel-Normal-80g/Darker-Light-Condition/High-Quality-Printing';
% datadir_PN_dark3='QR-Codes-Dataset/QR-Codes-Dataset/Papel-Normal-80g/Darker-Light-Condition/Standart-Printing';%não esta a sacar images
% 
% datadir_PN_low1='QR-Codes-Dataset/QR-Codes-Dataset/Papel-Normal-80g/Low-Light/Draft-Printing';
% datadir_PN_low2='QR-Codes-Dataset/QR-Codes-Dataset/Papel-Normal-80g/Low-Light/High-Quality-Printing';
% datadir_PN_low3= 'QR-Codes-Dataset/QR-Codes-Dataset/Papel-Normal-80g/Low-Light/Standart-Printing';%não esta a sacar images
% 
% datadir_PN_light1='QR-Codes-Dataset/QR-Codes-Dataset/Papel-Normal-80g/Not-so-Low-Light/Draft-Printing';
% datadir_PN_light2='QR-Codes-Dataset/QR-Codes-Dataset/Papel-Normal-80g/Not-so-Low-Light/High-Quality-Printing';
% datadir_PN_light3='QR-Codes-Dataset/QR-Codes-Dataset/Papel-Normal-80g/Not-so-Low-Light/Standart-Printing';%não esta a sacar images
% 
% datadir_PGP_dark='QR-Codes-Dataset/QR-Codes-Dataset/Photographic-Glossy-Paper/Darker-Light-Condition';
% datadir_PGP_low='QR-Codes-Dataset/QR-Codes-Dataset/Photographic-Glossy-Paper/Low-Light';
% datadir_PGP_light='QR-Codes-Dataset/QR-Codes-Dataset/Photographic-Glossy-Paper/Normal-Room-Light';
% 
% datadir_RP_dark='QR-Codes-Dataset/QR-Codes-Dataset/Rough-Paper/Darker-Light-Condition';
% datadir_RP_low='QR-Codes-Dataset/QR-Codes-Dataset/Rough-Paper/Low-Light';
% datadir_RP_light='QR-Codes-Dataset/QR-Codes-Dataset/Rough-Paper/Normal-Room-Light';
% 
% datadir_SDD='QR-Codes-Dataset/QR-Codes-Dataset/Selos-Descaracterizados- Digital';
% 
% datadir_SCLR_hight='QR-Codes-Dataset/QR-Codes-Dataset/Special-Case-2lines-removed/High-Quality-Printing';
% datadir_SCLR_low='QR-Codes-Dataset/QR-Codes-Dataset/Special-Case-2lines-removed/Low-Quality-Printing';

%alterar para verificar todos as imagens
rootdir = 'QR-Codes-Dataset';
filelist = dir(fullfile(rootdir, '%s/*.jpg')); 
filelist = filelist(~[filelist.isdir]);

for i=1:84
    path = sprintf("%s\%s", getfield(filelist,{i}, "folder"), getfield(filelist, {i},"name"));
    img{i} = imread(path);
end
%imglist=dir(sprintf('%s/*.jpg',datadir_SCLR_hight));

%leitura das imagens
for i= 1:numel(imglist)

%     [path, imgname, dummy]= fileparts(imglist(i).name);
%     img = imread(sprintf('%s/%s',datadir_SCLR_hight, imglist(i).name));
    
    %processamento do dataset
    if(ndims(img)==3)
        img=rgb2gray(img);
    end
    %img=im2double(img);

    %Binary Thresholding
    img1= imbinarize(img,'adaptive','ForegroundPolarity','dark','Sensitivity',0.5);
    img1=im2double(img1);
    figure()
    imshow(img1)

    %função que decteta o QR_code
    %roi=drawrectangle('Label','OuterRectangle','Color',[1 0 0]);
    [msg,~,loc]= readBarcode(img1,"QR-CODE");
    %Text=loc(2,:);
    if(strcmp(msg,'')==0)
        imsg = insertShape(img, "FilledCircle", [loc,repmat(10, length(loc), 1)],"Color","red","Opacity",1);
        figure()
        imshow(imsg)
        disp(msg)
    else 
        disp('NOT FOUND')
        disp(msg)
    end
end

clear;clc;close all;
% rootdir = 'QR-Codes-Dataset';
% filelist = dir(fullfile(rootdir, '%s/*.jpg')); 
% filelist = filelist(~[filelist.isdir]);
% 
% for i=1:84
%     path = sprintf("%s\%s", getfield(filelist,{i}, "folder"), getfield(filelist, {i},"name"));
%     img{i} = imread(path);
% end
datadir_SDD='QR-Codes-Dataset/QR-Codes-Dataset/Selos-Descaracterizados- Digital';
imglist=dir(sprintf('%s/*.jpg',datadir_SDD));

%leitura das imagens
for i= 1:numel(imglist)
    %chamar aqui as funções e mostrar resultado
    %passar o qr_code basuico para uma função
    %.....
    [path, imgname, dummy]= fileparts(imglist(i).name);
    img = imread(sprintf('%s/%s',datadir_SDD, imglist(i).name));

    if(ndims(img)==3)
        img=rgb2gray(img);
    end
    img=im2double(img);

   output= HOG(img);
%    [hog1,visualization] = extractHOGFeatures(img);
   figure()
   subplot(1,2,1);
   imshow(img);
   subplot(1,2,2);
   plot(output);
end

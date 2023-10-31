function [out] = HOG(img,qrcode)
%HOG Summary of this function goes here
%   Detailed explanation goes here

%Primeira busca severa
ind=1;
boundingboxes(1,1:3)=0;
qrcode_feature=HOG_feature(qrcode);
threshold=0.70;
for i= 1:size(img,1)-size(qrcode,1)
    for j=1:size(img,2)-size(qrcode,2)
        window=img(i:i+size(qrcode,1)-1, j:j+size(qrcode,2)-1);
        hogfeature=HOG_feature(window);
        %dif=sqrt(sum((hogfeature-qrcode_feature).^2,'all'));
        precision= (qrcode_feature*hogfeature')./(norm(qrcode_feature)*norm(hogfeature));
        
        %caso for maior que o thresold guarda a hipotese
        if(precision>threshold)
            boundingboxes(ind,:)=[j,i,precision];%boudingboux[coord.x,coordy,pres]
            ind=ind+1;
            %disp('detectou')

        end

    end
end

%caso o valor máximo da precisão não for maior que 90, realiza uma segunda
%busca severa
if(max(boundingboxes(:,3))<0.90)
    %realizar a limpeza das bounding boxes, escolhendo as meolhorres
    %hipóteses
    [B, indexes] = maxk(boundingboxes(:,3),20);%20 valores mais pequenos
    newbox(1,1:3)=0;
    for v=1:length(indexes)
        newbox(v,:)=boundingboxes(indexes(v),:);
    end
    ratio=0.70;
    
    %definição dos parâmetros
    pad=size(qrcode,1)-1;
    dr=size(qrcode,1);
    dc=size(qrcode,2);
    boundingbox(1,1:5)=0;
    count=1;
    while(1)
        
        for l=1:size(newbox,2)
            %coordenadas iniciais do bloco
            x=newbox(l,1);
            y=newbox(l,2);

            %novas janelas
            newqr=qrcode(l:pad,l:pad);
            qrfeat=HOG_feature(newqr);
            window=img(y:y+dr-1,x:x+dc-1);

            for r= 1:size(window,1)-size(newqr,1)
                for c=1:size(window,2)-size(newqr,2)

                    box=window(r:r+size(newqr,1)-1, c:c+size(newqr,2)-1);
                    boxfeat=HOG_feature(box);
                    %dif=sqrt(sum((boxfeat-qrfeat).^2,'all'));%'all'
                    precision= (qrfeat*boxfeat')./(norm(qrfeat)*norm(boxfeat));
                    
                    if((precision > ratio) & ( dc < 24))
                        boundingbox(count,:)=[x+r-1,y+c-1,precision,dr,dc];%boudingboux[coord.x,coordy,prec.,dim.x, dim.y]
                        count=count+1;
                        %disp("new box detected")
                    end

                end
            end
        end

        %novos parametros
        %ratio=ratio+0.05;
        pad=pad-1;
        dr=size(newqr,1);
        dc=size(newqr,2);

        %condição de saída
        check=max(boundingbox(:,3));
        checksize=min(boundingbox(:,4));
        if (check>0.85 && checksize<20)
            break;
        elseif(size(box,1)<7)
            break;
        end
    end
    bounding(:,1:5)=0;
    bounding=boundingbox;
    %display dos várias boundingbox
%     [B, indexes] = maxk(bounding(:,3),8);
%     
%     figure()
%     imshow(img)
%     closest boxes
%     for i=1:length(indexes)
%         x1=bounding(indexes(i),1);
%         x2=bounding(indexes(i),5);
%         y1=bounding(indexes(i),2);
%         y2=bounding(indexes(i),4);
%         hold on
%         rectangle('Position',[x1 y1 x2 y2],'EdgeColor','r');
%     end

    %display do boundingbox com maior precisão
    [B, indexes] = maxk(bounding(:,3),1);
    x1=bounding(indexes(1),1);
    x2=bounding(indexes(1),5);
    y1=bounding(indexes(1),2);
    y2=bounding(indexes(1),4);
    figure()
    imshow(img)
    rectangle('Position',[x1 y1 x2 y2],'EdgeColor','r');
    fprintf('Precisão: %f\n',boundingboxes(indexes(1),3));
else
%     %display dos várias boundingbox
%     [B, indexes] = maxk(boundingboxes(:,3),3);
%     figure()
%     imshow(img)
% 
%     closest boxes
%     for i=1:3
%         x1=boundingboxes(indexes(i),1);
%         x2=x1+(size(qrcode,2)-x1);
%         y1=boundingboxes(indexes(i),2);
%         y2=y1+(size(qrcode,1)-y1);
%         hold on
%         rectangle('Position',[x1 y1 x2 y2],'EdgeColor','r');
%     end

    %display do boundingbox com maior precisão
    [B, indexes] = maxk(boundingboxes(:,3),1);
    x1=boundingboxes(indexes(1),1);
    x2=x1+(size(qrcode,2)-x1);
    y1=boundingboxes(indexes(1),2);
    y2=y1+(size(qrcode,1)-y1);
    figure()
    imshow(img)
    rectangle('Position',[x1 y1 x2 y2],'EdgeColor','r');
    fprintf('Precisão: %f\n',boundingboxes(indexes(1),3));
end
disp('termino da deteção')
end



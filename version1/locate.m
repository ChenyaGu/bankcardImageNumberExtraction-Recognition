function [part]=locate(pic)

grayimage=rgb2gray(imread(pic));%灰度化后的图片
edg=edge(grayimage,'Canny',0.2);
[m,n]=size(edg);

%水平投影
for i=1:m
    X(i)=sum(edg(i,:));
end
%b=1:m;figure,plot(b,X(b)),title('每行水平投影');

%行数从一半起的第一个满足条件的行数超过一定大小的几行
min_i=-1;max_i=-1;
height=0;
threshold=100;%像素个数阈值
threshold_h=20;%高度阈值
while(min_i==-1)
    if height>=30
        threshold=threshold+4;
    else
        threshold=threshold-5;
    end
    height=0;
    for i = m/2:m
        if X(i)>threshold
            if min_i==-1
                min_i=i;%找到卡号行数最小值
            end
            height=height+1;
            if height>=30%高度太大了
                min_i=-1;
                break;
            end
        elseif min_i~=-1&&height>=threshold_h%找到卡号行数最大值
            max_i=i;
            break;
        else%height不够，之前的并不是卡号所在行
            min_i=-1;height=0;
        end
    end
    if threshold<20&&threshold_h==20
        threshold=100;
        threshold_h=16;
        min_i=-1;max_i=-1;
        continue;
    end
    if max_i~=-1
        if max_i>215&&threshold>=20&&threshold_h==20
            min_i=-1;max_i=-1;
        elseif min_i<140&&threshold>=20&&threshold_h==20
            threshold=100;
            threshold_h=16;
            min_i=-1;max_i=-1;
        end
    end
end
part=grayimage(min_i-4:max_i+4,:);
end





function [part]=locate(pic)

grayimage=rgb2gray(imread(pic));%�ҶȻ����ͼƬ
edg=edge(grayimage,'Canny',0.2);
[m,n]=size(edg);

%ˮƽͶӰ
for i=1:m
    X(i)=sum(edg(i,:));
end
%b=1:m;figure,plot(b,X(b)),title('ÿ��ˮƽͶӰ');

%������һ����ĵ�һ��������������������һ����С�ļ���
min_i=-1;max_i=-1;
height=0;
threshold=100;%���ظ�����ֵ
threshold_h=20;%�߶���ֵ
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
                min_i=i;%�ҵ�����������Сֵ
            end
            height=height+1;
            if height>=30%�߶�̫����
                min_i=-1;
                break;
            end
        elseif min_i~=-1&&height>=threshold_h%�ҵ������������ֵ
            max_i=i;
            break;
        else%height������֮ǰ�Ĳ����ǿ���������
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





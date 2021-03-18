function [save_index] = fengef(part)

%pedg=edge(part,'log',0.006);%(4.bmp->0.006)(1.bmp->空)
pedg=edge(part,'Canny',0.2);%
figure,imshow(pedg(:,36:390));
n=size(part,2);

p=[0 1 0;1 1 1;0 1 0];
dpedg=imdilate(pedg,p);
for j=1:n
    Yd(j)=sum(dpedg(:,j));
end
%c=36:390;figure,plot(c,Yd(c)),title('膨胀一次后竖直投影');
clear c;
min_j=-1;max_j=-1;
max_threshold=7;%
%min_threshold=5;%%
sum_threshold=170;%266 170
%mid_w_threshold=9;%%
%mid_threshold=15;%
%mid_count=4;%
index=1;
save_index(index,:)=[0,0];
for j=36:390%
    
    if Yd(j)==min(Yd(max(j-11,36):min(j+11,390)))%(14.bmp->10)(15.bmp->11)
        if min_j==-1
            min_j=j;
        else
            max_j=j;
            if max_j-min_j>13%13
                if max_j-min_j>29&&max_j-min_j<47%2个 29
                    t=max_j;
                    max_j=floor((max_j+min_j)/2);
                    if max(Yd(min_j:max_j))>max_threshold&&sum(Yd(min_j:max_j))>sum_threshold%&&length(find(Yd(min_j:max_j)>mid_threshold))>mid_count
                        %区间内的最大值和累加值大于阈值，否则可能是背景
                        %figure,imshow(part(:,min_j:max_j));
                        save_index(index,:)=[min_j,max_j];
                        index=index+1;
                    end
                    min_j=max_j;max_j=t;
                    clear t;
                    if max(Yd(min_j:max_j))>max_threshold&&sum(Yd(min_j:max_j))>sum_threshold%&&length(find(Yd(min_j:max_j)>mid_threshold))>mid_count
                        %区间内的最大值和累加值大于阈值，否则可能是背景
                        %figure,imshow(part(:,min_j:max_j));
                        save_index(index,:)=[min_j,max_j];
                        index=index+1;
                    end                    
                else
                    if max(Yd(min_j:max_j))>max_threshold&&sum(Yd(min_j:max_j))>sum_threshold%&&length(find(Yd(min_j:max_j)>mid_threshold))>mid_count
                        %区间内的最大值和累加值大于阈值，否则可能是背景
                        %figure,imshow(part(:,min_j:max_j));
                        save_index(index,:)=[min_j,max_j];
                        index=index+1;
                    end
                end
            end
            min_j=j;
            max_j=-1;
        end
    end
end




%end
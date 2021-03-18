function [first_j,last_j,temp2]=correct_min_max(save_index)
index_s=1;%some_r_index的数组下标
len=size(save_index,1);
some_r_index(index_s,:)=[0,0,0];
for index=1:len%save_index的数组下标
    if save_index(index,2)-save_index(index,1)>=16&&save_index(index,2)-save_index(index,1)<=20%单个数字长度比较合适的范围16~20
        some_r_index(index_s,1:2)=[save_index(index,1),save_index(index,2)];
        index_s=index_s+1;
    end
end
clear index;
clear index_s;

len2=size(some_r_index,1);
%save_index的正确率高于均分？len2大，len2>len-4或空格小，不能均分;
%直接调整也要借助标准参考点standard_index和距离correct_len
for i=1:len2
    some_r_index(i,3)=0;
    for j=1:len2
        r=mod(abs(some_r_index(j)-some_r_index(i)),18);
        if r==0||r==1||r==17%间隔比较合适的范围 17~19
            some_r_index(i,3)=some_r_index(i,3)+1;
        end
    end
end
%(some_r_index(:,3)==max(some_r_index(:,3)))&和位置都
standard_index=find((some_r_index(:,2)-some_r_index(:,1)>=17)&(some_r_index(:,2)-some_r_index(:,1)<=19));
%长度比较合适的元素在some_r_index中的索引值

%correct_len=mean(some_r_index(standard_index,2)-some_r_index(standard_index,1));%
correct_len=18;

%以相同方法统计standard_index中满足间隔等于18的元素
len3=size(standard_index,1);
temp=[0,0,0];
for i=1:len3
    temp(i,1:2)=some_r_index(standard_index(i),1:2);
end
for i=1:len3
    temp(i,3)=0;
    for j=1:len3
        r=mod(abs(temp(j)-temp(i)),18);
        if r==0%间隔18
            temp(i,3)=temp(i,3)+1;
        end
    end
end
clear len3;
clear r;
clear i;
clear j;

%取temp最优点作为标准参考点
temp2=temp(find(temp(:,3)==max(temp(:,3))),:);
standard=temp2(1,1:2);


if save_index(1)==some_r_index(1)
    first_j=max(save_index(1),round(save_index(1,2)-correct_len));
else
    first_j=round(standard(1)-round((standard(2)-save_index(1,2))/correct_len)*correct_len);
end

if save_index(len)==some_r_index(len2)
    last_j=min(round(save_index(len)+correct_len),round((save_index(len,2)+save_index(len)+correct_len)/2));
else
    last_j=round(correct_len+standard(1)+round((save_index(len)-standard(1))/correct_len)*correct_len);
end

clear len;
clear len2;

%end
function [first_j,last_j,temp2]=correct_min_max(save_index)
index_s=1;%some_r_index�������±�
len=size(save_index,1);
some_r_index(index_s,:)=[0,0,0];
for index=1:len%save_index�������±�
    if save_index(index,2)-save_index(index,1)>=16&&save_index(index,2)-save_index(index,1)<=20%�������ֳ��ȱȽϺ��ʵķ�Χ16~20
        some_r_index(index_s,1:2)=[save_index(index,1),save_index(index,2)];
        index_s=index_s+1;
    end
end
clear index;
clear index_s;

len2=size(some_r_index,1);
%save_index����ȷ�ʸ��ھ��֣�len2��len2>len-4��ո�С�����ܾ���;
%ֱ�ӵ���ҲҪ������׼�ο���standard_index�;���correct_len
for i=1:len2
    some_r_index(i,3)=0;
    for j=1:len2
        r=mod(abs(some_r_index(j)-some_r_index(i)),18);
        if r==0||r==1||r==17%����ȽϺ��ʵķ�Χ 17~19
            some_r_index(i,3)=some_r_index(i,3)+1;
        end
    end
end
%(some_r_index(:,3)==max(some_r_index(:,3)))&��λ�ö�
standard_index=find((some_r_index(:,2)-some_r_index(:,1)>=17)&(some_r_index(:,2)-some_r_index(:,1)<=19));
%���ȱȽϺ��ʵ�Ԫ����some_r_index�е�����ֵ

%correct_len=mean(some_r_index(standard_index,2)-some_r_index(standard_index,1));%
correct_len=18;

%����ͬ����ͳ��standard_index������������18��Ԫ��
len3=size(standard_index,1);
temp=[0,0,0];
for i=1:len3
    temp(i,1:2)=some_r_index(standard_index(i),1:2);
end
for i=1:len3
    temp(i,3)=0;
    for j=1:len3
        r=mod(abs(temp(j)-temp(i)),18);
        if r==0%���18
            temp(i,3)=temp(i,3)+1;
        end
    end
end
clear len3;
clear r;
clear i;
clear j;

%ȡtemp���ŵ���Ϊ��׼�ο���
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
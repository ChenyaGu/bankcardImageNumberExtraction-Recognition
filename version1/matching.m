clear;
close all;
%------����ģ��ƥ����ַ�ʶ��------
templatePath='F:\��ҵѧϰ\����ͼ����\template\';
fileFormat='.bmp';
templateImage=zeros(33,19,20);  %20������ģ�壬����ֵ�Ѷ�
%��ȡģ��
for i=1:20
    stri=num2str(i-1);
    imagePath=[templatePath,stri,fileFormat];
    tempImage=imread(imagePath);
    templateImage(:,:,i)=tempImage;
    clear imagePath stri tempImage; %ע�����
end

%������ԭrun�����е���䣬���зָ�󱣴浽�ļ�����濴�ܲ��ܴӹ�������ֱ�Ӷ�ȡ
pic='F:\��ҵѧϰ\����ͼ����\ƽ�濨��\11.bmp';
part=locate(pic);
save_index = fengef(part);
count=size(save_index,1);

pedg=edge(part,'Canny',0.2);
temppath='C:\Users\me_chenya\Desktop\single number\'; %�ǵ����������½�һ��ͬ���Ŀ��ļ���
fileFormat='.bmp';
for a=1:count
    stri=num2str(a);
    imagePath=[temppath,stri,fileFormat];
    left=save_index(a,1);
    right=save_index(a,2);
    A=pedg(:,left:right );
    imwrite(A,imagePath);
    clear stri imagePath left right;
end

characterPath='C:\Users\me_chenya\Desktop\single number\';  %����������½����ļ���ͬ��
charFileFormat='.bmp';
characterImage=zeros(33,19,count);  %�и���Ĵ�ʶ���ַ����δ�������
%��ȡ��ʶ���ַ�
for i=1:count
    stri=num2str(i);
    imagePath=[characterPath,stri,charFileFormat];
    tempImage1=imread(imagePath);
    tempImage2=imresize( tempImage1,[33,19]); %�������и���Ĵ�ʶ���ַ���Ϊ��ģ��һ���Ĵ�С
    characterImage(:,:,i)=tempImage2;
    clear imagePath stri tempImage;
end

Y=zeros(1,20);  %YΪ�б���/����ϵ�������㹫ʽ��������ҵ�������Խ��˵����ʶ��ĺ��Ǹ�ģ�����ԽС
fprintf('ʶ���Ŀ���Ϊ��');
for i=1:count
    U=length(find( characterImage(:,:,i))~=0);  %����ÿ����ʶ���ַ�ͼ���а�ɫ���ظ���U
    for j=1:20
        T=length(find( templateImage(:,:,j))~=0); %����ÿ��ģ���ַ�ͼ���а�ɫ���ظ���T
        tempV=characterImage(:,:,i)& templateImage(:,:,j);  
        V=length(find(tempV)~=0);               %��ʶ����ģ�干ͬ�Ĳ��ֵİ����ظ���V
        tempW=xor(tempV,templateImage(:,:,j));  
        W=length(find(tempW)~=0);               %ģ��ͼ����ಿ��W
        tempX=xor(tempV,characterImage(:,:,i));
        X=length(find(tempX)~=0);               %�ַ�ͼ����ಿ��X
        TUV=(T+U+V)/3;
        tempSum=sqrt(((T-TUV)*(T-TUV)+(U-TUV)*(U-TUV)+(V-TUV)*(V-TUV))/2);
        Y(j)=V/(W/T*X/U*tempSum);
    end
    [MAX,indexMax]=max(Y);    %��ƥ���Y����Ӧ�ĸ���Max,indexMaxΪ���Ӧ��Y�е�λ��
%     str=num2str(indexMax-1);
    str=indexMax-1;
    %����ģ�����������⣬ʹ�����·�ʽ�������,���ģ��������࣬�ǵû�Ҫ����case
    switch str
        case {0,10}
            fprintf('0')
        case {1,11}
            fprintf('1')
        case {2,12}
            fprintf('2')
        case {3,13}
            fprintf('3')
        case {4,14}
            fprintf('4')
        case {5,15}
            fprintf('5')
        case {6,16}
            fprintf('6')
        case {7,17}
            fprintf('7')
        case {8,18}
            fprintf('8')
        case {9,19}
            fprintf('9')
    end
%     imagePath=[templatePath,str,fileFormat];
%     image=imread(imagePath); %ƥ�䵽�����Ƶ�ģ���ֱ�Ӱ�����һ������ʾ����
%     figure;
%     imshow(image);
    clear str imagePath indexMax;
end
clear;
close all;
%------基于模板匹配的字符识别------
templatePath='F:\课业学习\数字图像处理\template\';
fileFormat='.bmp';
templateImage=zeros(33,19,20);  %20个数字模板，像素值已定
%读取模板
for i=1:20
    stri=num2str(i-1);
    imagePath=[templatePath,stri,fileFormat];
    tempImage=imread(imagePath);
    templateImage(:,:,i)=tempImage;
    clear imagePath stri tempImage; %注意这句
end

%以下是原run程序中的语句，进行分割后保存到文件里，后面看能不能从工作区中直接读取
pic='F:\课业学习\数字图像处理\平面卡号\11.bmp';
part=locate(pic);
save_index = fengef(part);
count=size(save_index,1);

pedg=edge(part,'Canny',0.2);
temppath='C:\Users\me_chenya\Desktop\single number\'; %记得先在桌面新建一个同名的空文件夹
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

characterPath='C:\Users\me_chenya\Desktop\single number\';  %这里和上面新建的文件夹同名
charFileFormat='.bmp';
characterImage=zeros(33,19,count);  %切割出的待识别字符依次存于其中
%读取待识别字符
for i=1:count
    stri=num2str(i);
    imagePath=[characterPath,stri,charFileFormat];
    tempImage1=imread(imagePath);
    tempImage2=imresize( tempImage1,[33,19]); %把所有切割出的待识别字符改为和模板一样的大小
    characterImage(:,:,i)=tempImage2;
    clear imagePath stri tempImage;
end

Y=zeros(1,20);  %Y为判别函数/相似系数，计算公式在下面可找到，当它越大，说明待识别的和那个模板相差越小
fprintf('识别后的卡号为：');
for i=1:count
    U=length(find( characterImage(:,:,i))~=0);  %计算每个待识别字符图像中白色像素个数U
    for j=1:20
        T=length(find( templateImage(:,:,j))~=0); %计算每个模板字符图像中白色像素个数T
        tempV=characterImage(:,:,i)& templateImage(:,:,j);  
        V=length(find(tempV)~=0);               %待识别与模板共同的部分的白像素个数V
        tempW=xor(tempV,templateImage(:,:,j));  
        W=length(find(tempW)~=0);               %模板图像多余部分W
        tempX=xor(tempV,characterImage(:,:,i));
        X=length(find(tempX)~=0);               %字符图像多余部分X
        TUV=(T+U+V)/3;
        tempSum=sqrt(((T-TUV)*(T-TUV)+(U-TUV)*(U-TUV)+(V-TUV)*(V-TUV))/2);
        Y(j)=V/(W/T*X/U*tempSum);
    end
    [MAX,indexMax]=max(Y);    %将匹配的Y最大对应的赋给Max,indexMax为其对应在Y中的位置
%     str=num2str(indexMax-1);
    str=indexMax-1;
    %由于模板命名的问题，使用以下方式输出卡号,如果模板继续增多，记得还要加入case
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
%     image=imread(imagePath); %匹配到最相似的模板后，直接把它们一个个显示出来
%     figure;
%     imshow(image);
    clear str imagePath indexMax;
end
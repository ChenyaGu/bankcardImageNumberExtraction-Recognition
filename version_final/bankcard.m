function varargout = bankcard(varargin)
% BANKCARD MATLAB code for bankcard.fig
%      BANKCARD, by itself, creates a new BANKCARD or raises the existing
%      singleton*.
%
%      H = BANKCARD returns the handle to a new BANKCARD or the handle to
%      the existing singleton*.
%
%      BANKCARD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BANKCARD.M with the given input arguments.
%
%      BANKCARD('Property','Value',...) creates a new BANKCARD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bankcard_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bankcard_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bankcard

% Last Modified by GUIDE v2.5 05-Nov-2017 18:10:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bankcard_OpeningFcn, ...
                   'gui_OutputFcn',  @bankcard_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before bankcard is made visible.
function bankcard_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bankcard (see VARARGIN)

% Choose default command line output for bankcard
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bankcard wait for user response (see UIRESUME)
% uiwait(handles.figure_bankcard);


% --- Outputs from this function are returned to the command line.
function varargout = bankcard_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function m_file_Callback(hObject, eventdata, handles)
% hObject    handle to m_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_file_open_Callback(hObject, eventdata, handles)
% hObject    handle to m_file_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile( ...
    {'*.bmp;*.jpg;*.png;*jpeg','Image Files(*.bmp;*.jpg;*.png;*jpeg)'; ...
    '*.*','All Files (*.*)'}, ...
    'pick an image');
if isequal(filename,0)||isequal(pathname,0)
    return;
end
axes(handles.axes_src);%用axes命令设定当前操作的坐标轴是axes_src
fpath=[pathname filename];%将文件名和目录名组合成一个完整的路径
%imshow(imread(fpath));%读入图片并且在axes_src上显示
image=imread(fpath);
pic=imresize(image,[270,428],'bicubic');
imshow(pic);

setappdata(handles.figure_bankcard,'pic',pic);
% --------------------------------------------------------------------
function m_file_save_Callback(hObject, eventdata, handles)
% hObject    handle to m_file_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uiputfile({'*.bmp','BMP files',;'*.jpg;','JPG files';'*.txt','Data Files(*.txt)';'All Files(*.*)'});
if isequal(filename,0)||isequal(pathname,0),
    return;
else
    fpath=fullfile(pathname,filename);%获得全路径的另一种方法
end
fid=getappdata(handles.figure,numstring);
imwrite(numstring,fpath);

% --------------------------------------------------------------------
function m_file_exit_Callback(hObject, eventdata, handles)
% hObject    handle to m_file_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure_bankcard);

% --- Executes on mouse press over axes background.
function axes_src_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_src (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function recongnization_Callback(hObject, eventdata, handles)
% hObject    handle to recongnization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function located_Callback(hObject, eventdata, handles)
% hObject    handle to located (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pic=getappdata(handles.figure_bankcard,'pic');
grayimage=rgb2gray(pic);%灰度化后的图片
%thresh=0.15;
%bwimage=im2bw(grayimage,thresh);
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
axes(handles.axes_dst);
part=grayimage(min_i-4:max_i+4,:);
imshow(part);

setappdata(handles.figure_bankcard,'part',part);

% --------------------------------------------------------------------
function match_Callback(hObject, eventdata, handles)
% hObject    handle to match (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%模板匹配
templatePath='F:\课业学习\数字图像处理\最终版本\template\';
fileFormat='.bmp';
templateImage=zeros(33,19,40);  %40个数字模板，像素值已定
%读取模板
for i=1:40
    stri=num2str(i-1);
    imagePath=[templatePath,stri,fileFormat];
    tempImage=imread(imagePath);
    templateImage(:,:,i)=tempImage;
    clear imagePath stri tempImage; %注意这句
end
pic=getappdata(handles.figure_bankcard,'pic');
[part]=locate(pic);
save_index =fengef(part);
[first_j,last_j,standard_index]=correct_min_max(save_index);
if first_j-save_index(1)>6
    save_index(1)=first_j;
end

total_len=last_j-first_j;

index=1;%save_index的数组下标
index_r=1;%right_index的数组下标
index_s=1;%standard_index的数组下标
right_index(index_r,:)=[0,0];
if total_len/19>17&&total_len/19<19%4-4-4-4 16位卡号
    single=total_len/19;
    for t=1:19
        if (save_index(index)>first_j+single*(t-1)-6&&save_index(index)<first_j+single*(t-1)+6)||(save_index(index,2)>first_j+single*t-6&&save_index(index,2)<first_j+single*t+6)
        %min_j在可能正确的区间内
            if mod(t,5)==0%取到了背景花纹所在区间
                index=index+1;
                continue;
            end
            if (standard_index(index_s,3)<3&&size(standard_index,1)<6)||(standard_index(index_s,3)<2&&size(standard_index,1)<8)
                right_index(index_r,:)=[round(first_j+single*(t-1)),round(first_j+single*t)];%直接用标准区间赋值
            else
                if save_index(index,1)==standard_index(index_s,1)
                    right_index(index_r,:)=save_index(index,1:2);
                    if index_s<size(standard_index,1)
                        index_s=index_s+1;
                    end
                else
                    right_index(index_r,1)=round(standard_index(index_s,1)-round((standard_index(index_s,1)-save_index(index))/single)*single);
                    right_index(index_r,2)=round(right_index(index_r,1)+single);
                end
            end
            index=index+1;
            index_r=index_r+1;             
        else
        %min_j不在正确的区间内 可能少取了整个区间（多取则为上面 取到背景花纹所在区间的情况）
            if mod(t,5)==0%是花纹
                continue;
            end
            %判断min_j 看起点是否正确
            if save_index(index)>first_j+single*t-8&&save_index(index,2)>first_j+single*(t+1)-8%少取至少一个区间5
                %在right_index里面保存一个save_index没有的区间
                right_index(index_r,:)=[round(first_j+single*(t-1)),round(first_j+single*t)];%直接用标准区间赋值，适用于少取的区间不止一个的情况
                index_r=index_r+1;
            else
                right_index(index_r,1)=round(standard_index(index_s,1)-round((standard_index(index_s,1)-save_index(index))/single)*single);
                right_index(index_r,2)=round(right_index(index_r,1)+single);
                index_r=index_r+1;
                index=index+1;
            end
        end
    end
    
%     for i=1:index_r-1
%     figure,imshow(part(:,right_index(i):right_index(i,2)));
%     end
    
    %再调整
    for t=2:16
        if t==5||t==9||t==13
            if right_index(t,1)-right_index(t-1,2)>12&&right_index(t,1)-right_index(t-1,2)<24
                continue;
            else
                right_index(t,:)=[round(right_index(t-1,2)+single+0.5),round(right_index(t-1,2)+single*2+0.5)];
            end
        else
            if right_index(t,1)-right_index(t-1,2)<5&&right_index(t,1)-right_index(t-1,2)>-4
                continue;
            else
                right_index(t,:)=[round(right_index(t-1,2)+0.5),round(right_index(t-1,2)+single+0.5)];
            end
        end
    end
 
elseif total_len/17>17&&total_len/17<19%4-6-5 15位卡号
    single=total_len/17;
    for t=1:17
        if save_index(index)>first_j+single*(t-1)-6&&save_index(index)<first_j+single*(t-1)+6
        %min_j在可能正确的区间内
            if mod(t,17)==5||mod(t,17)==12%取到了背景花纹所在区间
                index=index+1;
                continue;
            end
            if save_index(index,1)==standard_index(index_s,1)
                right_index(index_r,:)=save_index(index,1:2);
                if index_s<size(standard_index,1)
                    index_s=index_s+1;
                end
            else
                right_index(index_r,1)=round(standard_index(index_s,1)-round((standard_index(index_s,1)-save_index(index))/single)*single);
                right_index(index_r,2)=round(right_index(index_r,1)+single);
            end
            index=index+1;
            index_r=index_r+1;             
        else
        %min_j或max_j不在正确的区间内 可能少取了整个区间（多取则为上面 取到背景花纹所在区间的情况）
            if mod(t,17)==5||mod(t,17)==12%是花纹
                continue;
            end
            %判断min_j 看起点是否正确
            if save_index(index)>first_j+single*t-8%少取至少一个区间5
                %在right_index里面保存一个save_index没有的区间
                right_index(index_r,:)=[round(first_j+single*(t-1)),round(first_j+single*t)];%直接用标准区间赋值，适用于少取的区间不止一个的情况
                index_r=index_r+1;
            else
                right_index(index_r,1)=round(standard_index(index_s,1)-round((standard_index(index_s,1)-save_index(index))/single)*single);
                right_index(index_r,2)=round(right_index(index_r,1)+single);
                index_r=index_r+1;
                index=index+1;
            end
        end
 
    end
    
%     for i=1:index_r-1
%     figure,imshow(part(:,right_index(i):right_index(i,2)));
%     end
    
    %再调整
    for t=2:15
        if t==5||t==11
            if right_index(t,1)-right_index(t-1,2)>13&&right_index(t,1)-right_index(t-1,2)<24
                continue;
            else
                right_index(t,:)=[round(right_index(t-1,2)+single+0.5),round(right_index(t-1,2)+single*2+0.5)];
            end
        else
            if right_index(t,1)-right_index(t-1,2)<5
                continue;
            else
                right_index(t,:)=[round(right_index(t-1,2)+0.5),round(right_index(t-1,2)+single+0.5)];
            end
        end
    end
end
%%%%%%run程序到此结束


count=size(right_index,1);

pedg=edge(part,'Canny',0.2);
temppath='F:\课业学习\数字图像处理\最终版本\single number\'; %记得先在对应位置新建一个同名的空文件夹
fileFormat='.bmp';
for a=1:count
    stri=num2str(a);
    imagePath=[temppath,stri,fileFormat];
    left=right_index(a,1);
    right=right_index(a,2);
    A=pedg(:,left:right );
    imwrite(A,imagePath);
    clear stri imagePath left right;
end

characterPath='F:\课业学习\数字图像处理\最终版本\single number\';  %这里和上面新建的文件夹同名
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

Y=zeros(1,40);  %Y为判别函数/相似系数，计算公式在下面可找到，当它越大，说明待识别的和那个模板相差越小
fprintf('识别后的卡号为：');
string1=('识别后卡号为：');
set(handles.text7,'string',string1);
numstring='';
for i=1:count
    U=length(find( characterImage(:,:,i))~=0);  %计算每个待识别字符图像中白色像素个数U
    for j=1:40
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
       case {0,10,20,30}
           numstring=strcat(numstring,'0');
       case {1,11,21,31}
           numstring=strcat(numstring,'1');
       case {2,12,22,32}
           numstring=strcat(numstring,'2');
       case {3,13,23,33}
           numstring=strcat(numstring,'3');
       case {4,14,24,34}
           numstring=strcat(numstring,'4');
       case {5,15,25,35}
           numstring=strcat(numstring,'5');
       case {6,16,26,36}
           numstring=strcat(numstring,'6');
       case {7,17,27,37}
           numstring=strcat(numstring,'7');
       case {8,18,28,38}
           numstring=strcat(numstring,'8');
       case {9,19,29,39}
           numstring=strcat(numstring,'9');
   end
    set(handles.text6,'string',numstring);
    fprintf(numstring);
   % set(handles.text6,'String',numstring);
    
   
    %set(handles.text6,'string',numstring);
%     imagePath=[templatePath,str,fileFormat];
%     image=imread(imagePath); %匹配到最相似的模板后，直接把它们一个个显示出来
%     figure;
%     imshow(image);
    clear str imagePath indexMax;
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text6.
function text6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

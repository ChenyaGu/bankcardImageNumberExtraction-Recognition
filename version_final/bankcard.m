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
axes(handles.axes_src);%��axes�����趨��ǰ��������������axes_src
fpath=[pathname filename];%���ļ�����Ŀ¼����ϳ�һ��������·��
%imshow(imread(fpath));%����ͼƬ������axes_src����ʾ
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
    fpath=fullfile(pathname,filename);%���ȫ·������һ�ַ���
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
grayimage=rgb2gray(pic);%�ҶȻ����ͼƬ
%thresh=0.15;
%bwimage=im2bw(grayimage,thresh);
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
axes(handles.axes_dst);
part=grayimage(min_i-4:max_i+4,:);
imshow(part);

setappdata(handles.figure_bankcard,'part',part);

% --------------------------------------------------------------------
function match_Callback(hObject, eventdata, handles)
% hObject    handle to match (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%ģ��ƥ��
templatePath='F:\��ҵѧϰ\����ͼ����\���հ汾\template\';
fileFormat='.bmp';
templateImage=zeros(33,19,40);  %40������ģ�壬����ֵ�Ѷ�
%��ȡģ��
for i=1:40
    stri=num2str(i-1);
    imagePath=[templatePath,stri,fileFormat];
    tempImage=imread(imagePath);
    templateImage(:,:,i)=tempImage;
    clear imagePath stri tempImage; %ע�����
end
pic=getappdata(handles.figure_bankcard,'pic');
[part]=locate(pic);
save_index =fengef(part);
[first_j,last_j,standard_index]=correct_min_max(save_index);
if first_j-save_index(1)>6
    save_index(1)=first_j;
end

total_len=last_j-first_j;

index=1;%save_index�������±�
index_r=1;%right_index�������±�
index_s=1;%standard_index�������±�
right_index(index_r,:)=[0,0];
if total_len/19>17&&total_len/19<19%4-4-4-4 16λ����
    single=total_len/19;
    for t=1:19
        if (save_index(index)>first_j+single*(t-1)-6&&save_index(index)<first_j+single*(t-1)+6)||(save_index(index,2)>first_j+single*t-6&&save_index(index,2)<first_j+single*t+6)
        %min_j�ڿ�����ȷ��������
            if mod(t,5)==0%ȡ���˱���������������
                index=index+1;
                continue;
            end
            if (standard_index(index_s,3)<3&&size(standard_index,1)<6)||(standard_index(index_s,3)<2&&size(standard_index,1)<8)
                right_index(index_r,:)=[round(first_j+single*(t-1)),round(first_j+single*t)];%ֱ���ñ�׼���丳ֵ
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
        %min_j������ȷ�������� ������ȡ���������䣨��ȡ��Ϊ���� ȡ������������������������
            if mod(t,5)==0%�ǻ���
                continue;
            end
            %�ж�min_j ������Ƿ���ȷ
            if save_index(index)>first_j+single*t-8&&save_index(index,2)>first_j+single*(t+1)-8%��ȡ����һ������5
                %��right_index���汣��һ��save_indexû�е�����
                right_index(index_r,:)=[round(first_j+single*(t-1)),round(first_j+single*t)];%ֱ���ñ�׼���丳ֵ����������ȡ�����䲻ֹһ�������
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
    
    %�ٵ���
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
 
elseif total_len/17>17&&total_len/17<19%4-6-5 15λ����
    single=total_len/17;
    for t=1:17
        if save_index(index)>first_j+single*(t-1)-6&&save_index(index)<first_j+single*(t-1)+6
        %min_j�ڿ�����ȷ��������
            if mod(t,17)==5||mod(t,17)==12%ȡ���˱���������������
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
        %min_j��max_j������ȷ�������� ������ȡ���������䣨��ȡ��Ϊ���� ȡ������������������������
            if mod(t,17)==5||mod(t,17)==12%�ǻ���
                continue;
            end
            %�ж�min_j ������Ƿ���ȷ
            if save_index(index)>first_j+single*t-8%��ȡ����һ������5
                %��right_index���汣��һ��save_indexû�е�����
                right_index(index_r,:)=[round(first_j+single*(t-1)),round(first_j+single*t)];%ֱ���ñ�׼���丳ֵ����������ȡ�����䲻ֹһ�������
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
    
    %�ٵ���
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
%%%%%%run���򵽴˽���


count=size(right_index,1);

pedg=edge(part,'Canny',0.2);
temppath='F:\��ҵѧϰ\����ͼ����\���հ汾\single number\'; %�ǵ����ڶ�Ӧλ���½�һ��ͬ���Ŀ��ļ���
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

characterPath='F:\��ҵѧϰ\����ͼ����\���հ汾\single number\';  %����������½����ļ���ͬ��
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

Y=zeros(1,40);  %YΪ�б���/����ϵ�������㹫ʽ��������ҵ�������Խ��˵����ʶ��ĺ��Ǹ�ģ�����ԽС
fprintf('ʶ���Ŀ���Ϊ��');
string1=('ʶ��󿨺�Ϊ��');
set(handles.text7,'string',string1);
numstring='';
for i=1:count
    U=length(find( characterImage(:,:,i))~=0);  %����ÿ����ʶ���ַ�ͼ���а�ɫ���ظ���U
    for j=1:40
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
%     image=imread(imagePath); %ƥ�䵽�����Ƶ�ģ���ֱ�Ӱ�����һ������ʾ����
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

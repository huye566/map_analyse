function varargout = map_slider_analyse(varargin)
% MAP_SLIDER_ANALYSE MATLAB code for map_slider_analyse.fig
%      MAP_SLIDER_ANALYSE, by itself, creates a new MAP_SLIDER_ANALYSE or raises the existing
%      singleton*.
%
%      H = MAP_SLIDER_ANALYSE returns the handle to a new MAP_SLIDER_ANALYSE or the handle to
%      the existing singleton*.
%
%      MAP_SLIDER_ANALYSE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAP_SLIDER_ANALYSE.M with the given input arguments.
%
%      MAP_SLIDER_ANALYSE('Property','Value',...) creates a new MAP_SLIDER_ANALYSE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before map_slider_analyse_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to map_slider_analyse_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help map_slider_analyse

% Last Modified by GUIDE v2.5 12-Mar-2017 17:46:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @map_slider_analyse_OpeningFcn, ...
                   'gui_OutputFcn',  @map_slider_analyse_OutputFcn, ...
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


% --- Executes just before map_slider_analyse is made visible.
function map_slider_analyse_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to map_slider_analyse (see VARARGIN)

% Choose default command line output for map_slider_analyse
handles.output = hObject;

global xy_start
global ydata_start  %for XX
global xdata_start  %for YY
xy_start=[];
ydata_start=[];
xdata_start=[];

global xc_data
global yc_data
global zc_data
global x_label
global y_label
global z_label
global h
global f
global t
global up
up=4;
h='';
f='';
t='';
xc_data=[];
yc_data=[];
zc_data=[];
x_label='';
y_label='';
z_label='';

global state
state=0;
% Initialize Java class
dndcontrol.initJava();
hFig = handles.uipanel_below;
% a=axes(handles.axes1);
% % Create Java Swing JTextArea
% jTextArea = javaObjectEDT('javax.swing.JTextArea', ...
% sprintf('Drop some files or text content here.\n\n'));
% Create Java Swing JScrollPane
jScrollPane = javaObjectEDT('javax.swing.JPanel');
% jScrollPane.setVerticalScrollBarPolicy(jScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
% Add Scrollpane to figure
[~,hContainer] = javacomponent(jScrollPane,[],hFig);
set(hContainer,'Units','normalized','Position',[0 0 1 1]);

% Create dndcontrol for the JTextArea object
dndobj = dndcontrol(jScrollPane);
% Set Drop callback functions
dndobj.DropFileFcn = @myDropFcn;
dndobj.DropStringFcn = @myDropFcn;
dndobj.handles=handles;  
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes map_slider_analyse wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = map_slider_analyse_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% Callback function
function myDropFcn(obj,evt)
switch evt.DropType
    case 'file'  
        if numel(evt.Data)~=1
            disp('too much input file');
            return;
        end     
        for n = 1:numel(evt.Data)
            get_the_data(obj,evt.Data{n}); 
%             if state==0
%                 return;
%             end
        end
   case 'string'
        axes(obj.handles.axes1);
        title(evt.Data);
end

function get_the_data(obj,file_add)
% file.csv
% file.fig
% file.dat
% file.txt
global xc_data
global yc_data
global zc_data
global x_label
global y_label
global z_label
global h
global f
global t
global up
global state
state=0;
file_type=2;
type_sample={'csv','fig','dat','txt'};
type_position=strfind(file_add,'.');
if isempty(type_position)
    disp('error file add!!');
    return;
end
type_postfix=file_add(type_position(end)+1:end);
file_type_justify=strcmp(type_sample,type_postfix);
if ~file_type_justify(file_type)
    disp('error file type!!');
    return;
end
open(file_add); % fnam是文件名
hid=findall(gca,'type','Contour'); % 从当前图(gca)中取出曲线的handle
if isempty(hid)
    disp('error plot type(contour)!!');
    close(gcf);
    return;
end
xc_data=get(hid,'xdata'); % 取出x轴数据，注意，这个x和y是以cell的数据结构保存的
yc_data=get(hid,'ydata'); % 取出y轴数据
zc_data=get(hid,'zdata');
x_label=get(get(gca,'xlabel'),'string');
y_label=get(get(gca,'ylabel'),'string');
z_label=get(get(gca,'zlabel'),'string');
close(gcf);
%file_name均为cell输出
if iscell(xc_data)
   disp('too much map!!');
   return;
else
    file_name=get_file_name(file_add);
    file_name=strrep(file_name,'_','\_');
    axes(obj.handles.axes1);  
    contourf(xc_data,yc_data,zc_data);
    xlabel(x_label);ylabel(y_label);
    colormap(jet);
    colorbar;
    title(file_name);
    up=(floor(length(yc_data(1,:))/100)+1)*3*(yc_data(1,2)-yc_data(1,1));
    f=line(xc_data(1,:),yc_data(1,:),'color','black','linewidth',2);%竖线
    h=line(xc_data(:,1),yc_data(:,1),'color','black','linewidth',2);%横线
    t=text(xc_data(1,1),yc_data(1,1)+up,['(',num2str(xc_data(1,1)),',',num2str(yc_data(1,1)),',',num2str(zc_data(1,1)),')']);
    t.Color='black';
    t.FontSize=14;
    %     set(f,'xdata',xc_data(2,:));
%     set(h,'ydata',yc_data(:,20));
    axes(obj.handles.axes2);
    plot(xc_data(:,1),zc_data(:,1));
    title(['ICO= ',num2str(yc_data(1,1)),' GHz']);
    xlabel(x_label);ylabel(z_label);
    axes(obj.handles.axes3);
    plot(zc_data(1,:),yc_data(1,:));
    title(['DS= ',num2str(xc_data(1,1)),' ps']);
    xlabel(z_label);ylabel(x_label);
%     set(gca,'XDir','reverse');%调整坐标轴位置至右上
%     set(gca,'xaxislocation','bottom','yaxislocation','right');
    set(obj.handles.left_slider,'SliderStep',[1/(length(yc_data(1,:))-1),1/(length(yc_data(1,:))-1)]);
    set(obj.handles.right_slider,'SliderStep',[1/(length(xc_data(:,1))-1),1/(length(xc_data(:,1))-1)]);
%     add_value=get(handles.right_slider,'Value');
end
state=1;
DragModeYY(gcf,obj.handles.axes1,f,xc_data,obj.handles.axes3,obj.handles.right_slider);
DragModeXX(gcf,obj.handles.axes1,h,f,t,yc_data,xc_data,zc_data,obj.handles.axes2,obj.handles.axes3,obj.handles.left_slider);


function file_name=get_file_name(file_add)
file_position=strfind(file_add,'\');
if isempty(file_position)
    file_name=[];
else
   file_name=file_add(file_position(end)+1:end);
end


% --- Executes on slider movement.
function left_slider_Callback(hObject, eventdata, handles)
% hObject    handle to left_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xc_data
global yc_data
global zc_data
global h
global t
global up
global state
if state==0
    set(hObject,'Value',0);
else
left_value_slider=get(hObject,'Value');
left_value=floor(left_value_slider*(length(yc_data(1,:))-1))+1;
right_value_slider=get(handles.right_slider,'Value');
right_value=floor(right_value_slider*(length(xc_data(:,1))-1))+1;
temp_t=get(t,'position');
temp_t(2)=yc_data(1,left_value)+up;
set(t,'position',temp_t);
set(t,'String',['(',num2str(temp_t(1)),',',num2str(temp_t(2)-up),',',num2str(zc_data(right_value,left_value)),')']);
set(h,'ydata',yc_data(:,left_value));
showInputXLine(handles.axes2,left_value);
end

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function left_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to left_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function right_slider_Callback(hObject, eventdata, handles)
% hObject    handle to right_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xc_data
global yc_data
global zc_data
global f
global t
global up
global state
if state==0
    set(hObject,'Value',0);
else
right_value_slider=get(hObject,'Value');
right_value=floor(right_value_slider*(length(xc_data(:,1))-1))+1;
left_value_slider=get(handles.left_slider,'Value');
left_value=floor(left_value_slider*(length(yc_data(1,:))-1))+1;
temp_t=get(t,'position');
temp_t(1)=xc_data(right_value,1);
set(t,'position',temp_t);
set(t,'String',['(',num2str(temp_t(1)),',',num2str(temp_t(2)-up),',',num2str(zc_data(right_value,left_value)),')']);
set(f,'xdata',xc_data(right_value,:));
showInputYLine(handles.axes3,right_value);
% set(gca,'XDir','reverse');%调整坐标轴位置至右上
% set(gca,'xaxislocation','bottom','yaxislocation','right');
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function right_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to right_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function showInputXLine(handles_axes,left_value)
global xc_data
global yc_data
global zc_data
global x_label
global z_label
axes(handles_axes);
plot(xc_data(:,1),zc_data(:,left_value));
title(['ICO= ',num2str(yc_data(1,left_value)),' GHz']);
xlabel(x_label);ylabel(z_label);


function showInputYLine(handles_axes,right_value)
global xc_data
global yc_data
global zc_data
global x_label
global z_label
axes(handles_axes);
plot(zc_data(right_value,:),yc_data(1,:));
title(['DS= ',num2str(xc_data(right_value,1)),' ps']);
xlabel(z_label);ylabel(x_label);




% --- Executes on button press in enlarge_button.
function enlarge_button_Callback(hObject, eventdata, handles)
% hObject    handle to enlarge_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state
if state==1
newFig = figure('Name','huye');%由于直接保存axes1上的图像有困难，所以保存在新建的figure中的谱图
% set(newFig,'Visible','off')%设置新建的figure为不可见
newAxes = copyobj(handles.axes1,newFig);   %将axes1中的图复制到新建的figure中
set(newAxes,'Units','default','Position','default');    % 设置图显示的位置
end


% --- Executes on button press in save_left_button.
function save_left_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_left_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in save_right_button.
function save_right_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_right_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

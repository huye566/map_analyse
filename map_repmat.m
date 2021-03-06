function varargout = map_repmat(varargin)
% MAP_REPMAT MATLAB code for map_repmat.fig
%      MAP_REPMAT, by itself, creates a new MAP_REPMAT or raises the existing
%      singleton*.
%
%      H = MAP_REPMAT returns the handle to a new MAP_REPMAT or the handle to
%      the existing singleton*.
%
%      MAP_REPMAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAP_REPMAT.M with the given input arguments.
%
%      MAP_REPMAT('Property','Value',...) creates a new MAP_REPMAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before map_repmat_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to map_repmat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help map_repmat

% Last Modified by GUIDE v2.5 13-Mar-2017 16:09:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @map_repmat_OpeningFcn, ...
                   'gui_OutputFcn',  @map_repmat_OutputFcn, ...
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


% --- Executes just before map_repmat is made visible.
function map_repmat_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to map_repmat (see VARARGIN)

% Choose default command line output for map_repmat
handles.output = hObject;

global xc_data
global yc_data
global zc_data
global x_label
global y_label
global z_label
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
hFig = handles.uipanel_botttom;
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

% UIWAIT makes map_repmat wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = map_repmat_OutputFcn(hObject, eventdata, handles) 
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
    %     set(f,'xdata',xc_data(2,:));
%     set(h,'ydata',yc_data(:,20));
   add_type_value=get(obj.handles.add_type_popupmenu,'Value');
   switch add_type_value
       case 1
           add_xc_data=repmat(xc_data,1,2);
           add_zc_data=repmat(zc_data,1,2);
           add_yc_data=repmat(yc_data,1,2);
           add_yc_data(:,length(yc_data(1,:))+1:end)=yc_data+length(yc_data(1,:))*(yc_data(1,end)-yc_data(1,1))/(length(yc_data(1,:))-1);
           axes(obj.handles.axes2);  
           contourf(add_xc_data,add_yc_data,add_zc_data);
           xlabel(x_label);ylabel(y_label);
           colormap(jet);
           colorbar;
       case 2
           add_xc_data=repmat(xc_data,1,2);
           add_zc_data=repmat(zc_data,1,2);
           add_yc_data=repmat(yc_data,1,2);
           add_yc_data(:,1:length(yc_data(1,:)))=yc_data-length(yc_data(1,:))*(yc_data(1,end)-yc_data(1,1))/(length(yc_data(1,:))-1);
           axes(obj.handles.axes2);  
           contourf(add_xc_data,add_yc_data,add_zc_data);
           xlabel(x_label);ylabel(y_label);
           colormap(jet);
           colorbar;
       case 3
           add_xc_data=repmat(xc_data,1,3);
           add_zc_data=repmat(zc_data,1,3);
           add_yc_data=repmat(yc_data,1,3);
           add_yc_data(:,1:length(yc_data(1,:)))=yc_data-length(yc_data(1,:))*(yc_data(1,end)-yc_data(1,1))/(length(yc_data(1,:))-1);
           add_yc_data(:,length(yc_data(1,:))*2+1:end)=yc_data+length(yc_data(1,:))*(yc_data(1,end)-yc_data(1,1))/(length(yc_data(1,:))-1);
           axes(obj.handles.axes2);  
           contourf(add_xc_data,add_yc_data,add_zc_data);
           xlabel(x_label);ylabel(y_label);
           colormap(jet);
           colorbar;
   end
end
state=1;

function file_name=get_file_name(file_add)
file_position=strfind(file_add,'\');
if isempty(file_position)
    file_name=[];
else
   file_name=file_add(file_position(end)+1:end);
end

% --- Executes on button press in new_fig2_button.
function new_fig2_button_Callback(hObject, eventdata, handles)
% hObject    handle to new_fig2_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state
if state==1
newFig = figure('Name','fig2');%由于直接保存axes1上的图像有困难，所以保存在新建的figure中的谱图
% set(newFig,'Visible','off')%设置新建的figure为不可见
newAxes = copyobj(handles.axes2,newFig);   %将axes1中的图复制到新建的figure中
set(newAxes,'Units','default','Position','default');    % 设置图显示的位置
end

% --- Executes on button press in save_fig_button.
function save_fig_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_fig_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in add_type_popupmenu.
function add_type_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to add_type_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state
global xc_data
global yc_data
global zc_data
global x_label
global y_label
if state==1
add_type_value=get(hObject,'Value');
   switch add_type_value
       case 1
           add_xc_data=repmat(xc_data,1,2);
           add_zc_data=repmat(zc_data,1,2);
           add_yc_data=repmat(yc_data,1,2);
           add_yc_data(:,length(yc_data(1,:))+1:end)=yc_data+length(yc_data(1,:))*(yc_data(1,end)-yc_data(1,1))/(length(yc_data(1,:))-1);
           axes(handles.axes2);  
           contourf(add_xc_data,add_yc_data,add_zc_data);
           xlabel(x_label);ylabel(y_label);
           colormap(jet);
           colorbar;
       case 2
           add_xc_data=repmat(xc_data,1,2);
           add_zc_data=repmat(zc_data,1,2);
           add_yc_data=repmat(yc_data,1,2);
           add_yc_data(:,1:length(yc_data(1,:)))=yc_data-length(yc_data(1,:))*(yc_data(1,end)-yc_data(1,1))/(length(yc_data(1,:))-1);
           axes(handles.axes2);  
           contourf(add_xc_data,add_yc_data,add_zc_data);
           xlabel(x_label);ylabel(y_label);
           colormap(jet);
           colorbar;
       case 3
           add_xc_data=repmat(xc_data,1,3);
           add_zc_data=repmat(zc_data,1,3);
           add_yc_data=repmat(yc_data,1,3);
           add_yc_data(:,1:length(yc_data(1,:)))=yc_data-length(yc_data(1,:))*(yc_data(1,end)-yc_data(1,1))/(length(yc_data(1,:))-1);
           add_yc_data(:,length(yc_data(1,:))*2+1:end)=yc_data+length(yc_data(1,:))*(yc_data(1,end)-yc_data(1,1))/(length(yc_data(1,:))-1);
           axes(handles.axes2);  
           contourf(add_xc_data,add_yc_data,add_zc_data);
           xlabel(x_label);ylabel(y_label);
           colormap(jet);
           colorbar;
   end
end
% Hints: contents = cellstr(get(hObject,'String')) returns add_type_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from add_type_popupmenu


% --- Executes during object creation, after setting all properties.
function add_type_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to add_type_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in new_fig1_button.
function new_fig1_button_Callback(hObject, eventdata, handles)
% hObject    handle to new_fig1_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state
if state==1
newFig = figure('Name','fig1');%由于直接保存axes1上的图像有困难，所以保存在新建的figure中的谱图
% set(newFig,'Visible','off')%设置新建的figure为不可见
newAxes = copyobj(handles.axes1,newFig);   %将axes1中的图复制到新建的figure中
set(newAxes,'Units','default','Position','default');    % 设置图显示的位置
end

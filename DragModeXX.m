function DragModeXX(g,handles_axes1,h,f,t,yc_data,xc_data,zc_data,handes_axes2,handes_axes3,handles_slider_left)
global xy_start
global ydata_start
global up
min_position_y=yc_data(1,1);
max_posittion_y=yc_data(1,end);
length_y=length(yc_data(1,:));
step_y=(max_posittion_y-min_position_y)/(length_y-1);
min_position_x=xc_data(1,1);
max_posittion_x=xc_data(end,1);
length_x=length(xc_data(:,1));
step_x=(max_posittion_x-min_position_x)/(length_x-1);

set(h,'ButtonDownFcn',@startDragXFcn);
set(g,'WindowButtonUpFcn',@stopDragXFcn);

function startDragXFcn(varargin)
set(g,'WindowButtonMotionFcn',@draggingXFcn);
xy_start=get(handles_axes1,'CurrentPoint');
ydata_start=get(h,'ydata');
end
    
function draggingXFcn(varargin)
xy_current=get(handles_axes1,'CurrentPoint');
if xy_current(3)>max_posittion_y
   xy_current(3)=max_posittion_y;%超出显示截面便置边界
elseif xy_current(3)<min_position_y
    xy_current(3)=min_position_y;
 else 
    xy_current(3)= xy_current(3);
end
dy=xy_current(3)-xy_start(3);
dy=round(dy/step_y)*step_y;%----------------------------
set(h,'ydata',ydata_start+dy);%获得截线x方向的实时位置
temp_y=get(h,'ydata');
set(handles_slider_left,'Value',(temp_y(1)-min_position_y)/(max_posittion_y-min_position_y));
end
    
function stopDragXFcn(varargin)
set(g,'WindowButtonMotionFcn','');
temp_y=get(h,'ydata');
left_value=floor((temp_y(1)-min_position_y)/step_y)+1;
showInputXLine(handes_axes2,left_value);
temp_x=get(f,'xdata');
right_value=floor((temp_x(1)-min_position_x)/step_x)+1;
showInputYLine(handes_axes3,right_value);
axes(handles_axes1);
temp_t=get(t,'Position');
temp_t(1:2)=[temp_x(1),temp_y(1)+up];
set(t,'position',temp_t);
set(t,'String',['(',num2str(temp_t(1)),',',num2str(temp_t(2)-up),',',num2str(zc_data(right_value,left_value)),')']);
% showInputYLine(hObject, eventdata, handles,right_value);
end

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
end   


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
end

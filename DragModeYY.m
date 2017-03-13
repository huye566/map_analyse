function DragModeYY(g,handles_axes1,f,xc_data,handes_axes3,handles_slider_right)
global xy_start
global xdata_start
min_position_x=xc_data(1,1);
max_posittion_x=xc_data(end,1);
length_x=length(xc_data(:,1));
step_x=(max_posittion_x-min_position_x)/(length_x-1);
set(f,'ButtonDownFcn',@startDragYFcn);
set(g,'WindowButtonUpFcn',@stopDragYFcn);

function startDragYFcn(varargin)
set(g,'WindowButtonMotionFcn',@draggingYFcn);
xy_start=get(handles_axes1,'CurrentPoint');
xdata_start=get(f,'xdata');
end
    
function draggingYFcn(varargin)
xy_current=get(handles_axes1,'CurrentPoint');
if xy_current(1)>max_posittion_x
   xy_current(1)=max_posittion_x;%超出显示截面便置边界
elseif xy_current(1)<min_position_x
    xy_current(1)=min_position_x;
 else 
    xy_current(1)= xy_current(1);
end
dx=xy_current(1)-xy_start(1);
dx=round(dx/step_x)*step_x;%----------------------------
set(f,'xdata',xdata_start+dx);%获得截线x方向的实时位置
temp_x=get(f,'xdata');
set(handles_slider_right,'Value',(temp_x(1)-min_position_x)/(max_posittion_x-min_position_x));
end
    
% function stopDragYFcn(varargin)
% set(g,'WindowButtonMotionFcn','');
% temp_x=get(f,'xdata');
% right_value=floor((temp_x(1)-min_position_x)/step_x)+1;
% showInputYLine(handes_axes3,right_value);
% % showInputYLine(hObject, eventdata, handles,right_value);
% end
end
% 
% function showInputYLine(handles_axes,right_value)
% global xc_data
% global yc_data
% global zc_data
% global x_label
% global z_label
% axes(handles_axes);
% plot(zc_data(right_value,:),yc_data(1,:));
% title(['DS= ',num2str(xc_data(right_value,1)),' ps']);
% xlabel(z_label);ylabel(x_label);
% end


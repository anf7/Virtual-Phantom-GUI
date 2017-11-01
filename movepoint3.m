function movepoint3(pos)

global e1 e3 sl1 sl3 dataarray

set(e1,'String',num2str(round(10*pos(1))/10))
set(e3,'String',num2str(round(10*pos(2))/10))

v1 = str2double(get(e1,'String'));
v3 = str2double(get(e3,'String'));

set(sl1,'Value',v1)
set(sl3,'Value',v3)

dataarray(1) = v1;
dataarray(3) = v3;

% Adjust_Shape(0) 
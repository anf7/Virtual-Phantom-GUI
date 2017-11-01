function movepoint2(pos)

global e2 e3 sl2 sl3 dataarray

set(e3,'String',num2str(round(10*pos(1))/10))
set(e2,'String',num2str(round(10*pos(2))/10))

v2 = str2double(get(e2,'String'));
v3 = str2double(get(e3,'String'));

set(sl2,'Value',v2)
set(sl3,'Value',v3)

dataarray(2) = v2;
dataarray(3) = v3;

% Adjust_Shape(0)
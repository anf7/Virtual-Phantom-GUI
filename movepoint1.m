function movepoint1(pos)

global e1 e2 sl1 sl2 dataarray

% profile on

set(e1,'String',num2str(round(10*pos(1))/10))
set(e2,'String',num2str(round(10*pos(2))/10))

v1 = str2double(get(e1,'String'));
v2 = str2double(get(e2,'String'));

set(sl1,'Value',v1)
set(sl2,'Value',v2)

dataarray(1) = v1;
dataarray(2) = v2;


% Adjust_Shape(0)

% profile off
% profile viewer
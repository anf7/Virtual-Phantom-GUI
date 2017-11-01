function main_fig_resize(~,~)

global FIGURE_HANDLE
global AXES1_HANDLE AXES2_HANDLE AXES3_HANDLE AXES4_HANDLE
global UIPANEL_HANDLE 

set(FIGURE_HANDLE,'Units','Pixels');
set(UIPANEL_HANDLE,'Units','Pixels');

fpos = get(FIGURE_HANDLE,'Position');
upos = get(UIPANEL_HANDLE,'Position');
if fpos(4) < 689
    set(UIPANEL_HANDLE,'Position',[upos(1),upos(2),upos(3),689-20])
else
    set(UIPANEL_HANDLE,'Position',[upos(1),upos(2),upos(3),fpos(4)-20])
end
upos = get(UIPANEL_HANDLE,'Position');


% a1pos = [upos(3)+40,20+fpos(4)/2,(fpos(3)-upos(3)-40)/2,(fpos(4)-40)/2];
% a2pos = [upos(3)+40+(fpos(3) - (upos(3)+40))/2,20+fpos(4)/2,(fpos(3)-upos(3)-40)/2,(fpos(4)-40)/2];
% a3pos = [upos(3)+40,20,(fpos(3)-upos(3)-40)/2,(fpos(4)-40)/2];
% a4pos = [upos(3)+40+(fpos(3) - (upos(3)+40))/2,20,(fpos(3)-upos(3)-40)/2,(fpos(4)-40)/2];

a1pos = [upos(3)+70,20+fpos(4)/2,(fpos(3)-upos(3)-70)/2,(fpos(4)-40)/2];
a2pos = [upos(3)+70+(fpos(3) - (upos(3)+70))/2,20+fpos(4)/2,(fpos(3)-upos(3)-70)/2,(fpos(4)-40)/2];
a3pos = [upos(3)+70,20,(fpos(3)-upos(3)-40)/2,(fpos(4)-70)/2];
a4pos = [upos(3)+70+(fpos(3) - (upos(3)+70))/2,20,(fpos(3)-upos(3)-70)/2,(fpos(4)-40)/2];

if a1pos(3) < 200
    a1pos(3) = 200;
    a2pos(3) = 200;
    a3pos(3) = 200;
    a4pos(3) = 200;
    a2pos(1) = upos(3)+40 + 200;
    a4pos(1) = upos(3)+40 + 200;
end
if a1pos(4) < 200
    a1pos(4) = 200;
    a2pos(4) = 200;
    a3pos(4) = 200;
    a4pos(4) = 200;
    a1pos(2) = 40 + 200;
    a2pos(2) = 40 + 200;
end

set(AXES1_HANDLE,'OuterPosition',a1pos);
set(AXES1_HANDLE,'Position',[a1pos(1) + 30,a1pos(2)+30,a1pos(3) - 60,a1pos(4) - 60]);

set(AXES2_HANDLE,'OuterPosition',a2pos);
set(AXES2_HANDLE,'Position',[a2pos(1) + 30,a2pos(2)+30,a2pos(3) - 60,a2pos(4) - 60]);

set(AXES3_HANDLE,'OuterPosition',a3pos);
set(AXES3_HANDLE,'Position',[a3pos(1) + 30,a3pos(2)+30,a3pos(3) - 60,a3pos(4) - 60]);

set(AXES4_HANDLE,'OuterPosition',a4pos);
set(AXES4_HANDLE,'Position',[a4pos(1) + 30,a4pos(2)+30,a4pos(3) - 60,a4pos(4) - 60]);

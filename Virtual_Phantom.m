function Virtual_Phantom

initfpos = [1 124 1169 771];
initfpos = [-1200 124 1169 771];


close all
clc

global FIGURE_HANDLE FIGURE_POSITION
global AXESGROUP_HANDLE AXES1_HANDLE AXES2_HANDLE AXES3_HANDLE AXES4_HANDLE
global UIPANEL_HANDLE 
global ADD_OBJECT_BUTTON_HANDLE REMOVE_OBJECT_BUTTON_HANDLE
global ADD_DICOM_BUTTON_HANDLE CLEAR_DICOM_BUTTON_HANDLE
global SET_OBJ_PROPERTIES_BUTTON_HANDLE CANCEL_OBJ_PROPERTIES_BUTTON_HANDLE
global OBJECTS
global LISTBOX_HANDLE
global DICOM
global IMG1 IMG2 IMG3
global AX1_LINE_V AX1_LINE_H AX2_LINE_V AX2_LINE_H AX3_LINE_V AX3_LINE_H
global r1 r2 r3 r4
global t1 t2 t3 t4 t5 t6 t7 t8 t9
global e1 e2 e3 e4 e5 e6 e7 e8 e9 sl
global sl1 sl2 sl3 sl4 sl5 sl6 sl7 sl8 sl9 ckh
global ADDOBJ_ACTIVE_H ADDOBJ_INACTIVE_H
global NEW_OBJ_ID
global AX1_TEXT AX2_TEXT AX3_TEXT
global jRangeSlider
global OBJECTARRAY
global INITRUN
global Xcenter Ycenter Zcenter
global Xpts Ypts Zpts maxdim dataarray postsetdataarray


OBJECTARRAY = zeros(0,4);
NEW_OBJ_ID = 1;

OBJECTS = struct([]);
[Xpts,Ypts,Zpts,Xcenter,Ycenter,Zcenter,maxdim,DICOM] = deal([]);
dataarray = single(NaN(1,12));
postsetdataarray = single(NaN(1,12));
INITRUN = true;

FIGURE_HANDLE = figure('Units','normalized','outerposition',[0.1 0.1 0.8 0.8]);
set(FIGURE_HANDLE,'Units','pixels','Name','Virtual Phantom')
set(FIGURE_HANDLE,'Position',initfpos,'Colormap',gray)
set(FIGURE_HANDLE,'SizeChangedFcn',@main_fig_resize)
set(FIGURE_HANDLE,'WindowScrollWheelFcn', @scrollfunc);
set(FIGURE_HANDLE,'GraphicsSmoothing','off')

% set(FIGURE_HANDLE,'ToolBar','none');




% a = findall(FIGURE_HANDLE);
% b1 = findall(a,'ToolTipString','Show Plot Tools and Dock Figure');
% b2 = findall(a,'ToolTipString','New Figure');
% b3 = findall(a,'ToolTipString','Open File');
% b4 = findall(a,'ToolTipString','Save Figure');
% b5 = findall(a,'ToolTipString','Print Figure');
% b6 = findall(a,'ToolTipString','Edit Plot');
% b7 = findall(a,'ToolTipString','Zoom In');
% b8 = findall(a,'ToolTipString','Zoom Out');
% b9 = findall(a,'ToolTipString','Pan');
% b10 = findall(a,'ToolTipString','Rotate 3D');
% b11 = findall(a,'ToolTipString','Data Cursor');
% b12 = findall(a,'ToolTipString','Brush/Select Data');
% b13 = findall(a,'ToolTipString','Link Plot');
% b14 = findall(a,'ToolTipString','Insert Colorbar');
% b15 = findall(a,'ToolTipString','Insert Legend');
% b16 = findall(a,'ToolTipString','Hide Plot Tools');
% set([b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16],'Visible','Off');


AXES1_HANDLE = axes;
xlabel('X')
ylabel('Y')
AX1_TEXT = text(0,0,'Z = 0');
set(AX1_TEXT,'Color','y','FontSize',9,'VerticalAlignment','bottom','HitTest','off')
AXES2_HANDLE = axes;
xlabel('Z')
ylabel('Y')
AX2_TEXT = text(0,0,'X = 0');
set(AX2_TEXT,'Color','y','FontSize',9,'VerticalAlignment','bottom','HitTest','off')
AXES3_HANDLE = axes;
xlabel('X')
ylabel('Z')
AX3_TEXT = text(0,0,'Y = 0');
set(AX3_TEXT,'Color','y','FontSize',9,'VerticalAlignment','bottom','HitTest','off')
AXES4_HANDLE = axes;
AXESGROUP_HANDLE = [AXES1_HANDLE,AXES2_HANDLE,AXES3_HANDLE];

set(AXESGROUP_HANDLE,'XGrid','on','YGrid','On')
set(AXESGROUP_HANDLE,'GridLineStyle',':')
set(AXESGROUP_HANDLE,'FontSize',9)
set(AXESGROUP_HANDLE,'FontSmoothing','on')
set(AXESGROUP_HANDLE,'XTickLabelRotation',90)
set(AXESGROUP_HANDLE,'YDir','reverse')

set(AXES3_HANDLE,'YDir','normal')
set(AXES2_HANDLE,'XDir','reverse')
set(AXES4_HANDLE,'ZDir','reverse')
set(AXES4_HANDLE,'XLim',[-1,1])
set(AXES4_HANDLE,'YLim',[-1,1])
set(AXES4_HANDLE,'ZLim',[-1,1])

axis(AXESGROUP_HANDLE,'square')
hold(AXES1_HANDLE,'on')
hold(AXES2_HANDLE,'on')
hold(AXES3_HANDLE,'on')
% hold(AXES4_HANDLE,'on')
% axis(AXES4_HANDLE,'off')

Initialize_DICOM

uistack(AX1_TEXT,'top');
uistack(AX2_TEXT,'top');
uistack(AX3_TEXT,'top');
uistack(AX1_TEXT,'down',2);
uistack(AX2_TEXT,'down',2);
uistack(AX3_TEXT,'down',2);

FIGURE_POSITION = get(FIGURE_HANDLE,'Position');

UIPANEL_HANDLE = uipanel('Title','','Units','Pixels');
set(UIPANEL_HANDLE,'Position',[10, 10, 250, FIGURE_POSITION(4)-20])
u = get(UIPANEL_HANDLE,'Position');
upos = [u(3),u(4),u(3),u(4)];

set(AXESGROUP_HANDLE,'Units','Pixels')
set(AXES4_HANDLE,'Units','Pixels')


% SIRES_EDIT_HANDLE = uicontrol('Parent',UIPANEL_HANDLE,'Style','edit','FontSize',9,'FontAngle','Italic');

ADD_DICOM_BUTTON_HANDLE = uicontrol('Parent',UIPANEL_HANDLE,'Style','pushbutton','FontSize',9,'FontAngle','Italic');
set(ADD_DICOM_BUTTON_HANDLE,'Units','Pixels','String','Import DICOM')
set(ADD_DICOM_BUTTON_HANDLE,'Position',upos.*[0.05,0.82,0.425,0.04])
set(ADD_DICOM_BUTTON_HANDLE,'Callback',@Add_DICOM_Callback)

CLEAR_DICOM_BUTTON_HANDLE = uicontrol('Parent',UIPANEL_HANDLE,'Style','pushbutton','FontSize',9,'FontAngle','Italic');
set(CLEAR_DICOM_BUTTON_HANDLE,'Units','Pixels','String','Clear DICOM')
set(CLEAR_DICOM_BUTTON_HANDLE,'Position',upos.*[0.525,0.82,0.425,0.04])
set(CLEAR_DICOM_BUTTON_HANDLE,'Callback',@Clear_DICOM_Callback)



ADD_OBJECT_BUTTON_HANDLE = uicontrol('Parent',UIPANEL_HANDLE,'Style','pushbutton','FontSize',9,'FontAngle','Italic');
set(ADD_OBJECT_BUTTON_HANDLE,'Units','Pixels','String','Add Object')
set(ADD_OBJECT_BUTTON_HANDLE,'Position',upos.*[0.05,0.76,0.425,0.04])
set(ADD_OBJECT_BUTTON_HANDLE,'Callback',@Add_Object_Callback)

REMOVE_OBJECT_BUTTON_HANDLE = uicontrol('Parent',UIPANEL_HANDLE,'Style','pushbutton','FontSize',9,'FontAngle','Italic');
set(REMOVE_OBJECT_BUTTON_HANDLE,'Units','Pixels','String','Remove Object')
set(REMOVE_OBJECT_BUTTON_HANDLE,'Position',upos.*[0.525,0.76,0.425,0.04])
set(REMOVE_OBJECT_BUTTON_HANDLE,'Callback',@Remove_Object_Callback)

SET_OBJ_PROPERTIES_BUTTON_HANDLE = uicontrol('Parent',UIPANEL_HANDLE,'Style','pushbutton','FontSize',9,'FontAngle','Italic');
set(SET_OBJ_PROPERTIES_BUTTON_HANDLE,'Units','Pixels','String','Set Object Properties')
set(SET_OBJ_PROPERTIES_BUTTON_HANDLE,'Position',upos.*[0.05,0.01,0.6,0.04])
set(SET_OBJ_PROPERTIES_BUTTON_HANDLE,'Callback',@Set_Object_Callback)

CANCEL_OBJ_PROPERTIES_BUTTON_HANDLE = uicontrol('Parent',UIPANEL_HANDLE,'Style','pushbutton','FontSize',9,'FontAngle','Italic');
set(CANCEL_OBJ_PROPERTIES_BUTTON_HANDLE,'Units','Pixels','String','Cancel')
set(CANCEL_OBJ_PROPERTIES_BUTTON_HANDLE,'Position',upos.*[0.68,0.01,0.27,0.04])
set(CANCEL_OBJ_PROPERTIES_BUTTON_HANDLE,'Callback',@Cancel_Object_Callback)

LISTBOX_HANDLE = uicontrol('Parent',UIPANEL_HANDLE,'Style','listbox','FontSize',9,'FontAngle','Italic','Min',0,'Max',2);
set(LISTBOX_HANDLE,'Units','Pixels')
set(LISTBOX_HANDLE,'Position',upos.*[0.05,0.55,0.90,0.2])

set(AX1_TEXT,'Position',[DICOM.RR(1),DICOM.RC(end),0],'String',[' Z = ',num2str(DICOM.CS)])
set(AX2_TEXT,'Position',[DICOM.RS(end),DICOM.RR(end),0],'String',[' X = ',num2str(DICOM.CC)])
set(AX3_TEXT,'Position',[DICOM.RC(1),DICOM.RS(1),0],'String',[' Y = ',num2str(DICOM.CR)])

uicontrol('Style','text','String',{'HU','Range'},...
                  'FontSize',10,...
                  'Units','pixels',...
                  'Position',[265,620,50,40],...
                  'HorizontalAlignment','center');
              
jRangeSlider = com.jidesoft.swing.RangeSlider(-1000,3096,-1000,3096);  % min,max,low,high
jRangeSlider = javacomponent(jRangeSlider, [265,120,55,500], gcf);
set(jRangeSlider, 'MajorTickSpacing',200, 'MinorTickSpacing',50, 'PaintTicks',true, 'PaintLabels',true, ...
    'StateChangedCallback',@RangeSlider_Callback);
set(jRangeSlider, 'Orientation', 1)


%%

bg = uibuttongroup('Parent',UIPANEL_HANDLE,'Visible','on',...
                  'Units','Pixels',...
                  'Position',upos.*[0.05,0.47,0.90,0.07],...
                  'SelectionChangedFcn',@bselection);
              

set(AXES4_HANDLE,'Box','on')
set(AXES4_HANDLE,'DataAspectRatio',[1 1 1])
set(AXES4_HANDLE,'Color',[0.95,0.92,0.9])
axis tight
xlabel(AXES4_HANDLE,'X')
ylabel(AXES4_HANDLE,'Z')
zlabel(AXES4_HANDLE,'Y')
view(AXES4_HANDLE,[-30,30])

              
r1 = uicontrol(bg,'Style',...
                  'radiobutton',...
                  'String','Spheroid',...
                  'Units','normalized',...
                  'FontSize',9,...
                  'Position',[0.05 0.60 0.5 0.3],...
                  'HandleVisibility','off');
              
r2 = uicontrol(bg,'Style','radiobutton',...
                  'String','Cylinder',...
                  'Units','normalized',...
                  'FontSize',9,...
                  'Position',[0.05 0.15 0.5 0.3],...
                  'HandleVisibility','off');

r3 = uicontrol(bg,'Style','radiobutton',...
                  'String','Cuboid',...
                  'Units','normalized',...
                  'FontSize',9,...
                  'Position',[0.50 0.60 0.5 0.3],...
                  'HandleVisibility','off');
              
r4 = uicontrol(bg,'Style','radiobutton',...
                  'String','Custom Shape',...
                  'Units','normalized',...
                  'FontSize',9,...
                  'Position',[0.50 0.15 0.5 0.3],...
                  'HandleVisibility','off');


bg.Visible = 'on';

x = [0.04,0.42];
y =  linspace(0.1,0.41,9);
y(7:9) = y(7:9) + 0.015;
y(4:6) = y(4:6) + 0.005;
y(1:3) = y(1:3) - 0.005;
w = [0.38, 0.2];
h = [0.027,0.030];
hoff = 0.002;

fsize = 8;

t1 = uicontrol('Parent',UIPANEL_HANDLE,'Style','text',...
                  'String','X Position [cm] = ',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(1) y(9) w(1) h(1)],...
                  'HorizontalAlignment','right');
e1 = uicontrol('Parent',UIPANEL_HANDLE,'Style','edit',...
                  'String','0',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(2) y(9)+hoff w(2) h(2)],...
                  'CallBack',@Constr_Numeric1);


              
t2 = uicontrol('Parent',UIPANEL_HANDLE,'Style','text',...
                  'String','Y Position [cm] = ',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(1) y(8) w(1) h(1)],...
                  'HorizontalAlignment','right');
e2 = uicontrol('Parent',UIPANEL_HANDLE,'Style','edit',...
                  'String','0',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(2) y(8)+hoff w(2) h(2)],...
                  'CallBack',@Constr_Numeric1);
              
              
t3 = uicontrol('Parent',UIPANEL_HANDLE,'Style','text',...
                  'String','Z Position [cm] = ',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(1) y(7) w(1) h(1)],...
                  'HorizontalAlignment','right');
e3 = uicontrol('Parent',UIPANEL_HANDLE,'Style','edit',...
                  'String','0',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(2) y(7)+hoff w(2) h(2)],...
                  'CallBack',@Constr_Numeric1);
              
              
t4 = uicontrol('Parent',UIPANEL_HANDLE,'Style','text',...
                  'String','Polar Ang. [d] = ',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(1) y(6) w(1) h(1)],...
                  'HorizontalAlignment','right');
e4 = uicontrol('Parent',UIPANEL_HANDLE,'Style','edit',...
                  'String','0',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(2) y(6)+hoff w(2) h(2)],...
                  'CallBack',@Constr_Numeric2);
              
              
t5 = uicontrol('Parent',UIPANEL_HANDLE,'Style','text',...
                  'String','Azimuth Ang. [d] = ',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(1) y(5) w(1) h(1)],...
                  'HorizontalAlignment','right');
e5 = uicontrol('Parent',UIPANEL_HANDLE,'Style','edit',...
                  'String','0',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(2) y(5)+hoff w(2) h(2)],...
                  'CallBack',@Constr_Numeric2);

              
t6 = uicontrol('Parent',UIPANEL_HANDLE,'Style','text',...
                  'String','Axial Ang. [d] = ',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(1) y(4) w(1) h(1)],...
                  'HorizontalAlignment','right');
e6 = uicontrol('Parent',UIPANEL_HANDLE,'Style','edit',...
                  'String','0',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(2) y(4)+hoff w(2) h(2)],...
                  'CallBack',@Constr_Numeric2);

              
              
t7 = uicontrol('Parent',UIPANEL_HANDLE,'Style','text',...
                  'String','1st Axis [cm] = ',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(1) y(3) w(1) h(1)],...
                  'HorizontalAlignment','right');
e7 = uicontrol('Parent',UIPANEL_HANDLE,'Style','edit',...
                  'String','10',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(2) y(3)+hoff w(2) h(2)],...
                  'CallBack',@Constr_Numeric3);
              
              
t8 = uicontrol('Parent',UIPANEL_HANDLE,'Style','text',...
                  'String','2nd Axis [cm] = ',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(1) y(2) w(1) h(1)],...
                  'HorizontalAlignment','right');
e8 = uicontrol('Parent',UIPANEL_HANDLE,'Style','edit',...
                  'String','10',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(2) y(2)+hoff w(2) h(2)],...
                  'CallBack',@Constr_Numeric3);
              
              
t9 = uicontrol('Parent',UIPANEL_HANDLE,'Style','text',...
                  'String','3rd Axis [cm] = ',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(1) y(1) w(1) h(1)],...
                  'HorizontalAlignment','right');
e9 = uicontrol('Parent',UIPANEL_HANDLE,'Style','edit',...
                  'String','10',...
                  'FontSize',fsize,...
                  'Units','Pixels',...
                  'Position',upos.*[x(2) y(1)+hoff w(2) h(2)],...
                  'CallBack',@Constr_Numeric3);
              

% sl = uicontrol('Parent',UIPANEL_HANDLE,'Style','slider',...
%                   'Value',1000,...
%                   'FontSize',fsize,...
%                   'Units','Pixels',...
%                   'Position',upos.*[0.83 0.07 0.07 0.37],...
%                   'Min', -1000,...
%                   'Max', 3096,...
%                   'SliderStep', [0.002,0.02],...
%                   'Interruptible','off',...
%                   'BusyAction','cancel');
              
          
sl = javax.swing.JSlider;
sl = javacomponent(sl, upos.*[0.78, 0.1, 0.22, 0.38], gcf);
set(sl, 'MajorTickSpacing',200, 'MinorTickSpacing',50, 'PaintTicks',true, 'PaintLabels',true, ...
    'StateChangedCallback',@Change_HU);
set(sl, 'Orientation', 1, 'Maximum',3096,'Minimum',-1000,'Name','HI','Enabled',0)

% sl = com.jidesoft.swing.RangeSlider(-1000,3096);
% sl = javacomponent(sl, [usz(3)*0.80 usz(4)*0.09 usz(3)*0.2 usz(4)*0.37], gcf);
% set(sl, 'MajorTickSpacing',200, 'MinorTickSpacing',50, 'PaintTicks',true, 'PaintLabels',true, ...
%     'Background',java.awt.Color.white, 'StateChangedCallback',@RangeSlider_Callback);
% set(sl, 'Orientation', 1)


              
shiftstep = 0.1;
rotstep = 1;
expandstep = 0.1;
              

x = 0.63;
y = y + 0.002;
w = 0.08;
h = h(2);


sl1 = uicontrol('Parent',UIPANEL_HANDLE,'Style','slider',...
                  'Value',0,...
                  'Units','Pixels',...
                  'Position',upos.*[x, y(9), w, h],...
                  'Min', -100,...
                  'Max', 100,...
                  'SliderStep', [1/200*shiftstep,1],...
                  'String','1');  
              
sl2 = uicontrol('Parent',UIPANEL_HANDLE,'Style','slider',...
                  'Value',0,...
                  'Units','Pixels',...
                  'Position',upos.*[x, y(8), w, h],...
                  'Min', -100,...
                  'Max', 100,...
                  'SliderStep', [1/200*shiftstep,1],...
                  'String','2');   
              
sl3 = uicontrol('Parent',UIPANEL_HANDLE,'Style','slider',...
                  'Value',0,...
                  'Units','Pixels',...
                  'Position',upos.*[x, y(7), w, h],...
                  'Min', -100,...
                  'Max', 100,...
                  'SliderStep', [1/200*shiftstep,1],...
                  'String','3');   

sl4 = uicontrol('Parent',UIPANEL_HANDLE,'Style','slider',...
                  'Value',0,...
                  'Units','Pixels',...
                  'Position',upos.*[x, y(6), w, h],...
                  'Min', -3600,...
                  'Max', 3600,...
                  'SliderStep', [1/7200*rotstep,1],...
                  'String','4');   
      
sl5 = uicontrol('Parent',UIPANEL_HANDLE,'Style','slider',...
                  'Value',0,...
                  'Units','Pixels',...
                  'Position',upos.*[x, y(5), w, h],...
                  'Min', -3600,...
                  'Max', 3600,...
                  'SliderStep', [1/7200*rotstep,1],...
                  'String','5');   
              
sl6 = uicontrol('Parent',UIPANEL_HANDLE,'Style','slider',...
                  'Value',0,...
                  'Units','Pixels',...
                  'Position',upos.*[x, y(4), w, h],...
                  'Min', -3600,...
                  'Max', 3600,...
                  'SliderStep', [1/7200*rotstep,1],...
                  'String','6');   
                            
sl7 = uicontrol('Parent',UIPANEL_HANDLE,'Style','slider',...
                  'Value',10,...
                  'Units','Pixels',...
                  'Position',upos.*[x, y(3), w, h],...
                  'Min', 0,...
                  'Max', 100,...
                  'SliderStep', [1/100*expandstep,1],...
                  'String','7');   
      
sl8 = uicontrol('Parent',UIPANEL_HANDLE,'Style','slider',...
                  'Value',10,...
                  'Units','Pixels',...
                  'Position',upos.*[x, y(2), w, h],...
                  'Min', 0,...
                  'Max', 100,...
                  'SliderStep', [1/100*expandstep,1],...
                  'String','8');   
              
sl9 = uicontrol('Parent',UIPANEL_HANDLE,'Style','slider',...
                  'Value',10,...
                  'Units','Pixels',...
                  'Position',upos.*[x, y(1), w, h],...
                  'Min', 0,...
                  'Max', 100,...
                  'SliderStep', [1/100*expandstep,1],...
                  'String','9');
              
              
              
slb_handles = [sl1,sl2,sl3,sl4,sl5,sl6,sl7,sl8,sl9];
e_handles = [e1,e2,e3,e4,e5,e6,e7,e8,e9];
set(e_handles,'Interruptible','off','BusyAction','cancel')
set(slb_handles,'FontSize',fsize,'Interruptible','off','BusyAction','cancel');

addlistener(slb_handles,'Value','PostSet',@Slider_Change_Val);

              
ts = uicontrol('Parent',UIPANEL_HANDLE,'Style','text',...
                  'String','HU Value = 1000',...
                  'FontSize',10,...
                  'Units','Pixels',...
                  'Position',upos.*[0.1 0.065 0.7 0.02],...
                  'HorizontalAlignment','left',...
                  'FontWeight','bold');
              
ckh = uicontrol('Parent',UIPANEL_HANDLE,'Style','checkbox',...
                  'String','Transparent Obj.',...
                  'FontSize',8,...
                  'FontWeight','normal',...
                  'Units','Pixels',...
                  'Position',upos.*[0.54 0.065 0.7 0.02],...
                  'HorizontalAlignment','left',...
                  'CallBack',@Trans_Chk);
              
ADDOBJ_INACTIVE_H = [ADD_DICOM_BUTTON_HANDLE, CLEAR_DICOM_BUTTON_HANDLE,...
    LISTBOX_HANDLE, ADD_OBJECT_BUTTON_HANDLE, REMOVE_OBJECT_BUTTON_HANDLE];
              
              
ADDOBJ_ACTIVE_H = [r1,r2,r3,r4,t1,t2,t3,t4,t5,t6,t7,t8,t9,e1,e2,e3,e4,e5,e6,e7,e8,e9,...
    sl1,sl2,sl3,sl4,sl5,sl6,sl7,sl8,sl9,ts,ckh,SET_OBJ_PROPERTIES_BUTTON_HANDLE,...
    CANCEL_OBJ_PROPERTIES_BUTTON_HANDLE];
              
set(ADDOBJ_ACTIVE_H,'Enable','off')



%%
main_fig_resize


function scrollfunc(~,eventdata)
    get(gca,'Position');
    
    zoomfactor = 0.08;
    
    ax1pos = get(AXES1_HANDLE,'Position');
    ax2pos = get(AXES2_HANDLE,'Position');
    ax3pos = get(AXES3_HANDLE,'Position');
    ax4pos = get(AXES4_HANDLE,'Position');
    
    C = get (FIGURE_HANDLE, 'CurrentPoint');
    sc = eventdata.VerticalScrollCount;
    
    [~,Rind] = min(abs(DICOM.R - DICOM.CR));
    [~,Cind] = min(abs(DICOM.C - DICOM.CC));
    [~,Sind] = min(abs(DICOM.S - DICOM.CS));
    
    if C(1,1) >=  ax1pos(1) && C(1,1) <=  ax1pos(1) + ax1pos(3) &&...
            C(1,2) >=  ax1pos(2) && C(1,2) <=  ax1pos(2) + ax1pos(4)
        if Sind + sc >= 1 && Sind + sc <= DICOM.numslices
            Sind = Sind + sc;
        end
        if strcmp(get(e1,'Enable'),'on')
            bmaskax1 = find_inner_slice_points(dataarray,Sind,3,[DICOM.numrows,DICOM.numcols]);
            img1 = squeeze(DICOM.img(:,:,Sind));
            if any(bmaskax1(:))
                if get(ckh,'Value')
                    oimg = squeeze(DICOM.img_original(:,:,Sind));
                    img1(bmaskax1) = oimg(bmaskax1);
                else
                    img1(bmaskax1) = get(sl,'Value');
                end
            end
            set(IMG1,'CData',img1)
        else
            img1 = squeeze(DICOM.img(:,:,Sind));
            set(IMG1,'CData',img1)
        end
    elseif C(1,1) >=  ax2pos(1) && C(1,1) <=  ax2pos(1) + ax2pos(3) &&...
            C(1,2) >=  ax2pos(2) && C(1,2) <=  ax2pos(2) + ax2pos(4)
        if Cind + sc >= 1 && Cind + sc <= DICOM.numcols
            Cind = Cind + sc;
        end
        if strcmp(get(e1,'Enable'),'on')
            bmaskax2 = find_inner_slice_points(dataarray,Cind,2,[DICOM.numrows,DICOM.numslices]);
            img2 = squeeze(DICOM.img(:,Cind,:));
            if any(bmaskax2(:))
                if get(ckh,'Value')
                    oimg = squeeze(DICOM.img_original(:,Cind,:));
                    img2(bmaskax2) = oimg(bmaskax2);
                else
                    img2(bmaskax2) = get(sl,'Value');
                end
            end
            set(IMG2,'CData',img2)
        else
            img2 = squeeze(DICOM.img(:,Cind,:));
            set(IMG2,'CData',img2)
        end
    elseif C(1,1) >=  ax3pos(1) && C(1,1) <=  ax3pos(1) + ax3pos(3) &&...
            C(1,2) >=  ax3pos(2) && C(1,2) <=  ax3pos(2) + ax3pos(4)
        if Rind + sc >= 1 && Rind + sc <= DICOM.numrows
            Rind = Rind + sc;
        end
        if strcmp(get(e1,'Enable'),'on')
            bmaskax3 = find_inner_slice_points(dataarray,Rind,1,[DICOM.numcols,DICOM.numslices]);
            img3 = squeeze(DICOM.img(Rind,:,:))';
            if any(bmaskax3(:))
                if get(ckh,'Value')
                    oimg = squeeze(DICOM.img_original(Rind,:,:));
                    img3(bmaskax3) = oimg(bmaskax3);
                else
                    img3(bmaskax3) = get(sl,'Value');
                end
            end
            set(IMG3,'CData',img3)
        else
            img3 = squeeze(DICOM.img(Rind,:,:))';
            set(IMG3,'CData',img3)
        end
    elseif C(1,1) >=  ax4pos(1) && C(1,1) <=  ax4pos(1) + ax4pos(3) &&...
            C(1,2) >=  ax4pos(2) && C(1,2) <=  ax4pos(2) + ax4pos(4)
        
        xlim4 = get(AXES4_HANDLE,'XLim');
        ylim4 = get(AXES4_HANDLE,'YLim');
        zlim4 = get(AXES4_HANDLE,'ZLim');
        
        if isempty(Xcenter) && isempty(Ycenter) && isempty(Zcenter)
            xzoom = xlim4*(1+zoomfactor*sc);
            yzoom = ylim4*(1+zoomfactor*sc);
            zzoom = zlim4*(1+zoomfactor*sc);
        else

            xlowrange = max([0,min(Ypts(:)) - DICOM.RR(1)]);
            xhighrange = max([0,DICOM.RR(2) - max(Ypts(:))]);
            
            ylowrange = max([0,min(-Zpts(:)) - DICOM.RS(1)]);
            yhighrange = max([0,DICOM.RS(2) - max(-Zpts(:))]);
            
            zlowrange = max([0,min(Xpts(:)) - DICOM.RC(1)]);
            zhighrange = max([0,DICOM.RC(2) - max(Xpts(:))]);
            
            xzoom(1) = xlim4(1) - xlowrange*zoomfactor*sc;
            xzoom(2) = xlim4(2) + xhighrange*zoomfactor*sc;
            yzoom(1) = ylim4(1) - ylowrange*zoomfactor*sc;
            yzoom(2) = ylim4(2) + yhighrange*zoomfactor*sc;
            zzoom(1) = zlim4(1) - zlowrange*zoomfactor*sc;
            zzoom(2) = zlim4(2) + zhighrange*zoomfactor*sc;
            
            
        end
        
        if isempty(Xpts) && isempty(Xpts) && isempty(Xpts)
            if xzoom(1) < DICOM.RR(1) 
                xzoom(1) = DICOM.RR(1);
            end
            if xzoom(2) > DICOM.RR(2)
                xzoom(2) = DICOM.RR(2);
            end
            if yzoom(1) < DICOM.RS(1) 
                yzoom(1) = DICOM.RS(1);
            end
            if yzoom(2) > DICOM.RS(2)
                yzoom(2) = DICOM.RS(2);
            end
            if zzoom(1) < DICOM.RC(1) 
                zzoom(1) = DICOM.RC(1);
            end
            if zzoom(2) > DICOM.RC(2)
                zzoom(2) = DICOM.RC(2);
            end
        else
            mXpts = min(Xpts(:));
            MXpts = max(Xpts(:));
            mYpts = min(Ypts(:));
            MYpts = max(Ypts(:));
            mZpts = min(-Zpts(:));
            MZpts = max(-Zpts(:));

            if xzoom(1) < DICOM.RR(1)
                xzoom(1) = DICOM.RR(1);
            elseif xzoom(1) > DICOM.RR(1) && xzoom(1) > mYpts
                xzoom(1) = max([DICOM.RR(1), mYpts]);
            end
            if xzoom(2) > DICOM.RR(2)
                xzoom(2) = DICOM.RR(2);
            elseif xzoom(2) < DICOM.RR(2) && xzoom(2) < MYpts
                xzoom(2) = min([DICOM.RR(2), MYpts]);
            end
            if yzoom(1) < DICOM.RS(1)
                yzoom(1) = DICOM.RS(1);
            elseif yzoom(1) > DICOM.RS(1) && yzoom(1) > mZpts
                yzoom(1) = max([DICOM.RS(1), mZpts]);
            end
            if yzoom(2) > DICOM.RS(2)
                yzoom(2) = DICOM.RS(2);
            elseif yzoom(2) < DICOM.RS(2) && yzoom(2) < MZpts
                yzoom(2) = min([DICOM.RS(2), MZpts]);
            end
            if zzoom(1) < DICOM.RC(1)
                zzoom(1) = DICOM.RC(1);
            elseif zzoom(1) > DICOM.RC(1) && zzoom(1) > mXpts
                zzoom(1) = max([DICOM.RC(1), mXpts]);
            end
            if zzoom(2) > DICOM.RC(2)
                zzoom(2) =DICOM.RC(2);
            elseif zzoom(2) < DICOM.RC(2) && zzoom(2) < MXpts
                zzoom(2) = min([DICOM.RC(2), MXpts]);
            end

        end
           
        xlim(AXES4_HANDLE,xzoom)
        ylim(AXES4_HANDLE,yzoom)
        zlim(AXES4_HANDLE,zzoom)
    end
    DICOM.CR = DICOM.R(Rind);
    DICOM.CC = DICOM.C(Cind);
    DICOM.CS = DICOM.S(Sind);

    setPosition(AX1_LINE_V,double([DICOM.CC,DICOM.RR(1);DICOM.CC,DICOM.RR(2)]));
    setPosition(AX1_LINE_H,double([DICOM.RC(1),DICOM.CR;DICOM.RC(2),DICOM.CR]));
    setPosition(AX2_LINE_V,double([DICOM.CS,DICOM.RR(1);DICOM.CS,DICOM.RR(2)]));
    setPosition(AX2_LINE_H,double([DICOM.RS(1),DICOM.CR;DICOM.RS(2),DICOM.CR]));
    setPosition(AX3_LINE_V,double([DICOM.CC,DICOM.RS(1);DICOM.CC,DICOM.RS(2)]));
    setPosition(AX3_LINE_H,double([DICOM.RC(1),DICOM.CS;DICOM.RC(2),DICOM.CS]));
    
    set(AX1_TEXT,'Position',[DICOM.RR(1),DICOM.RC(end),0],'String',[' Z = ',num2str(DICOM.CS)])
    set(AX2_TEXT,'Position',[DICOM.RS(end),DICOM.RR(end),0],'String',[' X = ',num2str(DICOM.CC)])
    set(AX3_TEXT,'Position',[DICOM.RC(1),DICOM.RS(1),0],'String',[' Y = ',num2str(DICOM.CR)])
    
end
function Change_HU(~,~)

    slID = 0;
    hu = get(sl,'Value');
    hu = 10*round(hu/10);
    set(ts,'String',['HU Value = ',num2str(hu)])
    set(sl,'Value',hu)

    if INITRUN
        Update_3D
        INITRUN = false;
    else
        Adjust_Shape(slID)
    end
end 
function Trans_Chk(~,~)
    chkval = get(ckh,'Value');
    hu = get(sl,'Value');
    if chkval
        set(ts,'String','HU Value = N/A')
        set(ts,'Enable','off')
        set(sl,'Enabled',0)
    else
        set(ts,'String',['HU Value = ',num2str(hu)])
        set(ts,'Enable','on')
        set(sl,'Enabled',1)
    end
end

%%
function Slider_Change_Val(~,src)
    slID = str2double(src.AffectedObject.String);
    vals = zeros(1,9);
    vals_cell = get(slb_handles,'Value');
    for n = 1:9
        vals(n) = vals_cell{n};
    end
    for n = 4:6
        if vals(n) == -3600
            vals(n) = 0;
            set(slb_handles(n),'Value',vals(n));
        elseif vals(n) == 3600
            vals(n) = 0;
            set(slb_handles(n),'Value',vals(n));
        end
    end
    vals(4:6) = mod(vals(4:6),360);
    for n = 7:9
        if vals(n) < 0.01
            vals(n) = 0.01;
            set(slb_handles(n),'Value',vals(n));
        end
    end
    for n = 1:9
        set(e_handles(n),'String',num2str(vals(n)))
    end
    Adjust_Shape(slID)
end

%%       
function bselection(~,callbackdata)

   slID = 0;
   if strcmp(callbackdata.NewValue.String,'Spheroid')
       set(t7,'String','1st Axis [cm] = ')
       set(t8,'String','2nd Axis [cm] = ')
       set(t9,'String','3rd Axis [cm] = ')
       NEW_OBJ_ID = 1;
   elseif strcmp(callbackdata.NewValue.String,'Cylinder')
       set(t7,'String','1st Axis [cm] = ')
       set(t8,'String','2nd Axis [cm] = ')
       set(t9,'String','Length [cm] = ')
       NEW_OBJ_ID = 2;
   elseif strcmp(callbackdata.NewValue.String,'Cuboid')
       set(t7,'String','1st Axis [cm] = ')
       set(t8,'String','2nd Axis [cm] = ')
       set(t9,'String','3rd Axis [cm] = ')
       NEW_OBJ_ID = 3;
   elseif strcmp(callbackdata.NewValue.String,'Custom Shape')
       set(t7,'String','1st Axis Scale = ')
       set(t8,'String','2nd Axis Scale = ')
       set(t9,'String','3rd Axis Scale = ')
       NEW_OBJ_ID = 4;
   end
   postsetdataarray = NaN(1,12);
   Adjust_Shape(slID)

end

%%



%%
function Constr_Numeric1(src,~)
    slID = 0;
    str = get(src,'String');
    if isnan(str2double(str))
        set(src,'String','0');
    elseif str2double(str) > 100
        set(src,'String','100');
    elseif str2double(str) < -100
        set(src,'String','-100');
    end
    for n = 1:3
        val = get(e_handles(n),'String');
        set(slb_handles(n),'Value',(str2double(val)))
    end
    Adjust_Shape(slID)    
    
end  

%%
function Constr_Numeric2(src,~)
    slID = 0;
    str = get(src,'String');
    if isnan(str2double(str))
        set(src,'String','0');
    elseif str2double(str) < 0
        v = str2double(str);
        v = v - 360*ceil(v/360);
        v = 360 + v;
        set(src,'String',num2str(v));
    elseif str2double(str) >= 360
        v = str2double(str);
        v = v - 360*floor(v/360);
        set(src,'String',num2str(v));
    end
    for n = 4:6
        val = get(e_handles(n),'String');
        set(slb_handles(n),'Value',(str2double(val)))
    end
    Adjust_Shape(slID)
end

%%
function Constr_Numeric3(src,~)
    slID = 0;
    str = get(src,'String');
    if isnan(str2double(str)) || str2double(str) <= 0
        set(src,'String','0.1');
    elseif str2double(str) > 100
        set(src,'String','100');
    end
    for n = 7:9
        val = get(e_handles(n),'String');
        set(slb_handles(n),'Value',(str2double(val)))
    end
    Adjust_Shape(slID)
end   

end

